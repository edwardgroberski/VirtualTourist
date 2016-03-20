//
//  FlickrRequestManager.swift
//  VirtualTourist
//
//  Created by Eddie Groberski on 3/19/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation

/**
Request manager for Flickr API
 
Based on: https://github.com/udacity/ud421-ios-networking/tree/master/FlickFinderComplete
*/
class FlickrRequestManager: NSObject {
    
    // MARK: Properties
    
    
    typealias CompletionHander = (result: AnyObject!, error: NSError?) -> Void
    let session = NSURLSession.sharedSession()
    
    let noPicturesError = NSError(domain: FlickrRequestConstants.FlickrResponseErrors.NoPictures,
        code: FlickrRequestConstants.FlickrResponseErrorCodes.NoPictures, userInfo: nil)
    
    
    // MARK: Singleton instance
    
    
    class func sharedInstance() -> FlickrRequestManager {
        
        struct Singleton {
            static var sharedInstance = FlickrRequestManager()
        }
        
        return Singleton.sharedInstance
    }
    
    
    // MARK: Requests
    
    
    /**
    Search Flickr for images based on Pin location
    */
    func flickrImageSearchWithPin(pin: Pin, completionHandler: CompletionHander) {
        var parameters = methodParameters(pin)
        
        // Make request to get total number of pages
        flickrImageSearch(parameters) { (result, error) -> Void in
            // GUARD: Is "pages" key in the photosDictionary?
            guard let totalPages = result[FlickrRequestConstants.FlickrResponseKeys.Pages] as? Int else {
                print("Cannot find key '\(FlickrRequestConstants.FlickrResponseKeys.Pages)' in \(result)")
                return
            }
            
            // GUARD: Number of pages is not 0
            guard totalPages > 0 else {
                
                completionHandler(result: nil, error: self.noPicturesError)
                return
            }
            
            // Get random page
            let pageLimit = min(totalPages, 40)
            let randomPage = Int(arc4random_uniform(UInt32(pageLimit))) + 1
            
            // Add new parameters
            parameters[FlickrRequestConstants.FlickrParameterKeys.Page] = randomPage
            parameters[FlickrRequestConstants.FlickrParameterKeys.Per_Page] = FlickrRequestConstants.FlickrParameterValues.Per_Page
            
            // Make another request for random page images
            self.flickrImageSearch(parameters, completionHandler: { (result, error) -> Void in
                /* GUARD: Is the "photo" key in photosDictionary? */
                guard let photosArray = result[FlickrRequestConstants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                    print("Cannot find key '\(FlickrRequestConstants.FlickrResponseKeys.Photo)' in \(result)")
                    return
                }
                
                if photosArray.count == 0 {
                    print("No Photos Found. Search Again.")
                    completionHandler(result: nil, error: self.noPicturesError)
                    return
                } else {
                    completionHandler(result: photosArray, error: nil)
                }
            })
            
        }
    }
    
    
    /**
     Download Flickr image
     */
    func flickrDownloadImage(url: String, completionHandler: (imageData: NSData?, error: NSError?) ->  Void){
        let request = NSURLRequest(URL: NSURL(string: url)!)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                completionHandler(imageData: nil, error: error)
            } else {
                completionHandler(imageData: data, error: nil)
            }
        }
        
        task.resume()
    }
    
    
    /**
     Search Flickr for images with parameters and completion handler
     */
    private func flickrImageSearch(methodParameters: [String:AnyObject], completionHandler: CompletionHander) {
        let request = NSURLRequest(URL: flickrURLFromParameters(methodParameters))
        
        // Create request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            // GUARD: Was there an error?
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            // GUARD: Did we get a successful 2XX response?
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            // GUARD: Was there any data returned?
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            // Parse data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            // GUARD: Did Flickr return an error (stat != ok)?
            guard let stat = parsedResult[FlickrRequestConstants.FlickrResponseKeys.Status] as? String where stat == FlickrRequestConstants.FlickrResponseValues.OKStatus else {
                print("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            // GUARD: Is "photos" key in our result?
            guard let photosDictionary = parsedResult[FlickrRequestConstants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                print("Cannot find keys '\(FlickrRequestConstants.FlickrResponseKeys.Photos)' in \(parsedResult)")
                return
            }
            
            // Succesful
            completionHandler(result: photosDictionary, error: nil)
        }
        
        task.resume()
    }

    
    // MARK: Helper methods
    

    /**
    Create URL for Flickr API
    */
    private func flickrURLFromParameters(parameters: [String:AnyObject]) -> NSURL {
        let components = NSURLComponents()
        components.scheme = FlickrRequestConstants.Flickr.APIScheme
        components.host = FlickrRequestConstants.Flickr.APIHost
        components.path = FlickrRequestConstants.Flickr.APIPath
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    
    /**
    Return method parameters based on Pin
     */
    private func methodParameters(pin:Pin) -> [String:AnyObject] {
        return [
            FlickrRequestConstants.FlickrParameterKeys.Method: FlickrRequestConstants.FlickrParameterValues.SearchMethod,
            FlickrRequestConstants.FlickrParameterKeys.APIKey: FlickrRequestConstants.FlickrParameterValues.APIKey,
            FlickrRequestConstants.FlickrParameterKeys.BoundingBox: bboxString(pin),
            FlickrRequestConstants.FlickrParameterKeys.SafeSearch: FlickrRequestConstants.FlickrParameterValues.UseSafeSearch,
            FlickrRequestConstants.FlickrParameterKeys.Extras: FlickrRequestConstants.FlickrParameterValues.MediumURL,
            FlickrRequestConstants.FlickrParameterKeys.Format: FlickrRequestConstants.FlickrParameterValues.ResponseFormat,
            FlickrRequestConstants.FlickrParameterKeys.NoJSONCallback: FlickrRequestConstants.FlickrParameterValues.DisableJSONCallback
        ]
    }
    

    /**
     Return bounding box based on Pin
     */
    private func bboxString(pin:Pin) -> String {
        let latitude = pin.latitude.doubleValue
        let longitude = pin.longitude.doubleValue
        let minimumLon = max(longitude - FlickrRequestConstants.Flickr.SearchBBoxHalfWidth, FlickrRequestConstants.Flickr.SearchLonRange.0)
        let minimumLat = max(latitude - FlickrRequestConstants.Flickr.SearchBBoxHalfHeight, FlickrRequestConstants.Flickr.SearchLatRange.0)
        let maximumLon = min(longitude + FlickrRequestConstants.Flickr.SearchBBoxHalfWidth, FlickrRequestConstants.Flickr.SearchLonRange.1)
        let maximumLat = min(latitude + FlickrRequestConstants.Flickr.SearchBBoxHalfHeight, FlickrRequestConstants.Flickr.SearchLatRange.1)
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    }
}