//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Eddie Groberski on 3/19/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import UIKit
import MapKit
import CoreData


/**
View Controller for main MapView
*/
class MapViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    let mapRegionArchiver = MapRegionArchiver()
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    /**
    NSFetchedResultsController with all Pins
     */
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: String(Pin))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Pin.Keys.Latitude, ascending: true)]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }()
    
    
    // MARK: View Management
    
    
    /**
    View did load
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFetchedResultsController()
        setMapViewGesture()
        restoreMapRegion(false)
    }
    
    
    // MARK: Region Management
    
    
    /**
    Restore the map region if it has been archived before
    */
    func restoreMapRegion(animated: Bool) {
        if let mapRegion = mapRegionArchiver.restoreMapRegion() {
            mapView.setRegion(mapRegion.region, animated: animated)
        }
    }
}


// MARK: NSFetchedResultsControllerDelegate


extension MapViewController : NSFetchedResultsControllerDelegate {
    
    /**
    Perform fetch and set delegate
     */
    func setUpFetchedResultsController() {
        do {
            try fetchedResultsController.performFetch()
        } catch {}
        
        fetchedResultsController.delegate = self
        
        dispatch_async(dispatch_get_main_queue()) {
            // Create all of the saved annotations
            self.mapView.setAnnotationsWithPins(self.fetchedResultsController.fetchedObjects as! [Pin])
        }
    }
    
    
    /**
    Pin changed in NSFetchedResultsController
     */
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            let pin = anObject as! Pin
            
            switch type {
            case .Insert:
                // Add annotation to MapView
                mapView.addAnnotation(pin.annotation())
            default:
                break
            }
    }
}


// MARK: MKMapViewDelegate


extension MapViewController : MKMapViewDelegate {

    /**
    Archive the map region
    */
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapRegionArchiver.archiveMapRegion(MapRegion(mapView: mapView))
    }
    
    
    /**
    Set pins to use MKPinAnnotationView
    */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        let pin = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView ??
            MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)

        pin.animatesDrop = true
        pin.pinTintColor = UIColor.redColor()
        pin.annotation = annotation

        return pin
    }
    
    /**
     Selected pin, push PinViewController
    */
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier(String(PinViewController))
            as! PinViewController

        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    
    /**
    Set the long press gesture on the MapView
    */
    func setMapViewGesture() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "createPin:")
        longPressGestureRecognizer.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    
    /**
    Add pin to MapView
    */
    func createPin(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            // Get coordinate of user's touch
            let touchLocation = gestureRecognizer.locationInView(mapView)
            let coordinate = mapView.convertPoint(touchLocation, toCoordinateFromView: mapView)
            
            // Create pin if no other annotation is at current coordinate
            if !mapView.doesAnnotationExistAtCoordinate(coordinate) {
                let _ = Pin(coordinate: coordinate, context: sharedContext)
                CoreDataStackManager.sharedInstance().saveContext()
            }
        }
    }
}





