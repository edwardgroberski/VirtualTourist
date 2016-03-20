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
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: String(Pin))
        
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
    Set the long press gesture on the MapView
    */
    func setMapViewGesture() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "addPin:")
        longPressGestureRecognizer.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    
    /**
    Add pin to MapView
    */
    func addPin(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            // Get coordinate of user's touch
            let touchLocation = gestureRecognizer.locationInView(mapView)
            let coordinate = mapView.convertPoint(touchLocation, toCoordinateFromView: mapView)
            
            // Create pin if no other annotation is at current coordinate
            if !mapView.doesAnnotationExistAtCoordinate(coordinate) {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                mapView.addAnnotation(annotation)
                
                let _ = Pin(coordinate: coordinate, context: sharedContext)
                CoreDataStackManager.sharedInstance().saveContext()
            }
        }
    }
    
}





