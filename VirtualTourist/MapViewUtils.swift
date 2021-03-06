//
//  MapViewUtils.swift
//  VirtualTourist
//
//  Created by Eddie Groberski on 3/19/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {

    /**
    Return if annotation exists at coordinate
    */
    func doesAnnotationExistAtCoordinate(coordinate:CLLocationCoordinate2D) -> Bool {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        for annotation in annotations {
            // Compare latitude and longitude
            if annotation.coordinate.latitude == latitude && annotation.coordinate.longitude == longitude {
                return true
            }
        }
        
        return false
    }
    
    
    /**
    Set Annotations from array of Pins
     */
    func setAnnotationsWithPins(pins:[Pin]) {
        var annotations = [MKPointAnnotation]()
        
        for pin in pins {
            // Add Pin's Annotation to array
            annotations.append(pin.annotation())
        }
        
        // Clear existing annotations and then add new annotations to map view
        removeAnnotations(annotations)
        addAnnotations(annotations)
    }
}