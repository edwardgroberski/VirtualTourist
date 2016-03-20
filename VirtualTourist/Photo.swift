//
//  Photo.swift
//  VirtualTourist
//
//  Created by Eddie Groberski on 3/20/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import CoreData

class Photo: NSManagedObject {
    
    // MARK: Properties
    
    @NSManaged var url: String?
    @NSManaged var pin: Pin?
    
    
    // MARK: Initializers
    
    
    /**
     Override init
     */
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    
    /**
     Init Photo with URL
     */
    init(photoUrl: String, context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entityForName(String(Photo), inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        url = photoUrl
    }
}