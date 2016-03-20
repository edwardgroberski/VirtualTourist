//
//  FlickrRequestConstants.swift
//  VirtualTourist
//
//  Created by Eddie Groberski on 3/19/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation

struct FlickrRequestConstants {
    
    // MARK: Flickr
    struct Flickr {
        static let APIScheme = "https"
        static let APIHost   = "api.flickr.com"
        static let APIPath   = "/services/rest"
        
        static let SearchBBoxHalfWidth  = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange       = (-90.0, 90.0)
        static let SearchLonRange       = (-180.0, 180.0)
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method         = "method"
        static let APIKey         = "api_key"
        static let GalleryID      = "gallery_id"
        static let Extras         = "extras"
        static let Format         = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch     = "safe_search"
        static let BoundingBox    = "bbox"
        static let Page           = "page"
        static let Per_Page       = "per_page"
    }
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let SearchMethod        = "flickr.photos.search"
        static let APIKey              = ""
        static let ResponseFormat      = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let MediumURL           = "url_m"
        static let UseSafeSearch       = "1"
        static let Per_Page            = 21
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status    = "stat"
        static let Photos    = "photos"
        static let Photo     = "photo"
        static let Title     = "title"
        static let MediumURL = "url_m"
        static let Pages     = "pages"
        static let Total     = "total"
        static let Secret    = "secret"
        static let Id        = "id"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
    
    // MARK: Flickr Response Error Messages
    struct FlickrResponseErrors {
        static let NoPictures = "There are no pictures."
    }
    
    // MARK: Flickr Response Error Codes
    struct FlickrResponseErrorCodes {
        static let NoPictures = 1111
        static let otherError = 2222
    }
}