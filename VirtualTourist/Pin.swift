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

class Pin: NSManagedObject {
    
    
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    
    lazy var coordinate: CLLocationCoordinate2D = {
        return CLLocationCoordinate2D(latitude: self.latitude.doubleValue, longitude: self.longitude.doubleValue)
    }()
    
    init(coordinate: CLLocationCoordinate2D, context: NSManagedObjectContext) {
        // Core Data
        let entity =  NSEntityDescription.entityForName(String(Pin), inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        latitude = coordinate.latitude as NSNumber
        longitude = coordinate.longitude as NSNumber
    }
    
    func annotation() -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        return annotation
    }
}
