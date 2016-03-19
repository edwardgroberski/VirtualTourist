//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Eddie Groberski on 3/19/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import UIKit
import MapKit


/**
View Controller for main MapView
*/
class MapViewController: UIViewController {

    // MARK: Properties
    
    
    let mapRegionArchiver = MapRegionArchiver()
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: View Management
    
    
    /**
    View did load
    */
    override func viewDidLoad() {
        super.viewDidLoad()
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


// MARK: MKMapViewDelegate


extension MapViewController : MKMapViewDelegate {
    
    /**
     Archive the map region
     */
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapRegionArchiver.archiveMapRegion(MapRegion(mapView: mapView))
    }
}