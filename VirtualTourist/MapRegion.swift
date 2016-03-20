//
//  MapRegion.swift
//  VirtualTourist
//
//  Created by Eddie Groberski on 3/19/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import MapKit


/**
Map region of a MapView
*/
class MapRegion: NSObject, NSCoding {
    
    // MARK: Constants
    
    
    struct Keys {
        static let Latitude       = "latitude"
        static let Longitude      = "longitude"
        static let LatitudeDelta  = "latitudeDelta"
        static let LongitudeDelta = "longitudeDelta"
    }
    
    
    // MARK: Properties
    
        
    var latitude: CLLocationDegrees       = 0.0
    var longitude: CLLocationDegrees      = 0.0
    
    var latitudeDelta: CLLocationDegrees  = 0.0
    var longitudeDelta: CLLocationDegrees = 0.0
    
    var center: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var span: MKCoordinateSpan {
        return MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
    
    var region: MKCoordinateRegion {
        return MKCoordinateRegion(center: center, span: span)
    }
    
    
    // MARK: Initializers
    
    
    /**
    Init MapRegion with MapView
    */
    init(mapView:MKMapView) {
        super.init()
        latitude       = mapView.region.center.latitude
        longitude      = mapView.region.center.longitude
        latitudeDelta  = mapView.region.span.latitudeDelta
        longitudeDelta = mapView.region.span.longitudeDelta
    }
    
    
    /**
    Encode MapRegion
    */
    func encodeWithCoder(archiver: NSCoder) {
        archiver.encodeObject(latitude, forKey: Keys.Latitude)
        archiver.encodeObject(longitude, forKey: Keys.Longitude)
        archiver.encodeObject(latitudeDelta, forKey: Keys.LatitudeDelta)
        archiver.encodeObject(longitudeDelta, forKey: Keys.LongitudeDelta)
    }
    
    
    /**
    Init with coder MapRegion
     */
    required init(coder unarchiver: NSCoder) {
        super.init()
        latitude = unarchiver.decodeObjectForKey(Keys.Latitude) as! CLLocationDegrees
        longitude = unarchiver.decodeObjectForKey(Keys.Longitude) as! CLLocationDegrees
        latitudeDelta = unarchiver.decodeObjectForKey(Keys.LatitudeDelta) as! CLLocationDegrees
        longitudeDelta = unarchiver.decodeObjectForKey(Keys.LongitudeDelta) as! CLLocationDegrees
    }
}