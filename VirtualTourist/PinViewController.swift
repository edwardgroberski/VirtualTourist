//
//  PinViewController.swift
//  VirtualTourist
//
//  Created by Eddie Groberski on 3/19/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class PinViewController: UIViewController {
    
    // MARK: Properties
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var photoAlbumCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var noPhotosLabel: UILabel!
    
    var annotation: VirtualTouristAnnotation!
    var pin: Pin!
    
    var insertedIndexPaths: [NSIndexPath]!
    var deletedIndexPaths: [NSIndexPath]!
    var updatedIndexPaths: [NSIndexPath]!
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: String(Photo))
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Photo.Keys.Url, ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "%K == %@", Photo.Keys.Pin, self.pin);
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
    }()
    
    
    // MARK: View Management
    
    
    /**
    View did load
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnnotation()

        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        getImages()
    }
    
    
    /**
     Set annotation on MapView
     */
    func setAnnotation() {
        // Clear existing annotations and then add the annotation to map view
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations([annotation])
        
        // Create zoomed region for pin
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: annotation.pin!.coordinate, span: span)
        mapView.setRegion(region, animated: false)
    }
}


// MARK: UICollectionViewDataSource & UICollectionViewDelegate


extension PinViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /**
     Number of sections
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        print("number Of sections: \(fetchedResultsController.sections?.count)")
        return fetchedResultsController.sections?.count ?? 0
    }
    
    
    /**
     Number of cells
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        
        print("number Of Cells: \(sectionInfo.numberOfObjects)")
        return sectionInfo.numberOfObjects
    }
    
    
    /**
     Cell at index path
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCollectionViewCell.Contants.cellIdentifier, forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        cell.photo = photo
        cell.loadPhoto()
        return cell
    }
    
    
    /**
     Interitem spacing for section
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.0
    }

    
    /**
     Line spacing for section
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.0
    }
    
    
    /**
     Cell size
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize = view.frame.size.width - 6
        return CGSize(width: screenSize/3, height: screenSize/3);
    }
}


// MARK: NSFetchedResultsControllerDelegate


extension PinViewController: NSFetchedResultsControllerDelegate {
    
    /**
     NSFetchedResultsController will change its content
     */
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        insertedIndexPaths = [NSIndexPath]()
        deletedIndexPaths = [NSIndexPath]()
        updatedIndexPaths = [NSIndexPath]()
    }
    
    
    /**
     NSFetchedResultsController object did change
     */
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
        
        switch type{
        case .Insert:
            print("Insert an item")
            insertedIndexPaths.append(newIndexPath!)
            break
        case .Delete:
            print("Delete an item")
            deletedIndexPaths.append(indexPath!)
            break
        case .Update:
            print("Update an item.")
            updatedIndexPaths.append(indexPath!)
            break
        default:
            break
        }
    }
    
    
    /**
     NSFetchedResultsController did change its content
     */
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        photoAlbumCollectionView.performBatchUpdates({() -> Void in
            
            for indexPath in self.insertedIndexPaths {
                self.photoAlbumCollectionView.insertItemsAtIndexPaths([indexPath])
            }
            
            for indexPath in self.deletedIndexPaths {
                self.photoAlbumCollectionView.deleteItemsAtIndexPaths([indexPath])
            }
            
            for indexPath in self.updatedIndexPaths {
                self.photoAlbumCollectionView.reloadItemsAtIndexPaths([indexPath])
            }
            
            }, completion: nil)
    }
}


// MARK: Flickr Requests


extension PinViewController {
    
    /**
     Get Pin images
     */
    private func getImages() {
        // Get images if Pin has no Photos
        if pin.photos.isEmpty {
        
            FlickrRequestManager.sharedInstance().flickrImageSearchWithPin(pin) { (result, error) -> Void in
                guard (error == nil) else {
                    print("There was an error with your request: \(error)")
                    return
                }
                
                // Create photo
                let photosArray = result as! [[String: AnyObject]]
                for photo in photosArray {
                    let url = photo[FlickrRequestConstants.FlickrResponseKeys.MediumURL] as! String
                    let _ = Photo(photoUrl: url, userPin: self.pin, context: self.sharedContext)
                }
                
                CoreDataStackManager.sharedInstance().saveContext()
                print("Photos: \(photosArray)")
                dispatch_async(dispatch_get_main_queue()) {
                    self.photoAlbumCollectionView.reloadData()
                }
            }
        }
    }
}


