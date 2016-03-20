//
//  Pin.swift
//  VirtualTourist
//
//  Created by Eddie Groberski on 3/19/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import CoreData
import MapKit


/**
Class representing a Pin
*/
class Pin: NSManagedObject {
    
    // MARK: Constants
    struct Keys {
        static let Latitude  = "latitude"
        static let Longitude = "longitude"
        static let Photos    = "photos"
    }
    
    
    // MARK: Properties
    
    
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var photos: [Photo]
    
    lazy var coordinate: CLLocationCoordinate2D = {
        return CLLocationCoordinate2D(latitude: self.latitude.doubleValue, longitude: self.longitude.doubleValue)
    }()
    
    
    // MARK: Initializers
    
    
    /**
    Override init
    */
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    
    /**
     Init Pin with CLLocationCoordinate2D
     */
    init(coordinate: CLLocationCoordinate2D, context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName(String(Pin), inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        latitude = coordinate.latitude as NSNumber
        longitude = coordinate.longitude as NSNumber
    }
    
    
    // MARK: Annotation
    
    
    /**
    Return Annotation from coordinate
    */
    func annotation() -> VirtualTouristAnnotation {
        let annotation = VirtualTouristAnnotation()
        annotation.coordinate = coordinate
        annotation.pin = self
        return annotation
    }
}
