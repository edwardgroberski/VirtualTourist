//
//  MapRegionArchiver.swift
//  VirtualTourist
//
//  Created by Eddie Groberski on 3/19/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation

/**
File path for NSKeyedUnarchiver
*/
class MapRegionArchiver {
    
    // MARK: Constants
    
    
    struct Constants {
        static let FilePath = "mapRegionArchive"
    }
    
    
    // MARK: Properties
    
    
    /**
    File path for NSKeyedUnarchiver
    */
    var filePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent(Constants.FilePath).path!
    }
    
    
    // MARK: Archiving methods
    
    
    /**
     Archive MapRegion with NSKeyedUnarchiver
     */
    func archiveMapRegion(mapRegion:MapRegion) {
        NSKeyedArchiver.archiveRootObject(mapRegion, toFile: filePath)
    }
    
    
    /**
     Restore MapRegion from NSKeyedUnarchiver
     */
    func restoreMapRegion() -> MapRegion? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? MapRegion
    }
}