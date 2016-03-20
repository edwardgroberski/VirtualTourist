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
    @IBOutlet weak var photoAlbumCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var noPhotosLabel: UILabel!
    var annotation: VirtualTouristAnnotation!
    var pin: Pin!
    
    
    // MARK: View Management
    
    
    /**
    View did load
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnnotation()
        FlickrRequestManager.sharedInstance().flickrImageSearchWithPin(pin) { (result, error) -> Void in
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            print("photos array \(result)")
        }
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