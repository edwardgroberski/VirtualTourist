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

class PinViewController: UIViewController {
    
    // MARK: Properties
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var picturesCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    var annotation: VirtualTouristAnnotation!
    
    
    // MARK: View Management
    
    
    /**
    View did load
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnnotation()
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