//
//  PhotoCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Eddie Groberski on 3/20/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: Constants
    
    struct Contants {
        static let cellIdentifier = "photoCell"
    }

    // MARK: Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var photo: Photo?
    
    
    // MARK: Photo Methods

    
    /**
    Download and set image for cell
    */
    func loadPhoto() {

        if NSFileManager.defaultManager().fileExistsAtPath(photo!.filePath.path!) {
            let image = UIImage(data: NSData(contentsOfURL: (photo!.filePath))!)
            self.photoImageView.image = image
            self.activityIndicator.hidden = true
        } else {
            activityIndicator.startAnimating()
            self.activityIndicator.hidesWhenStopped = true
            FlickrRequestManager.sharedInstance().flickrDownloadImage(photo!.url) { (imageData, error) -> Void in
                guard (error == nil) else {
                    print("There was an error with your request: \(error)")
                    return
                }
                
                if let data = imageData {
                    NSFileManager.defaultManager().createFileAtPath(self.photo!.filePath.path!, contents: data, attributes: nil)
                    dispatch_async(dispatch_get_main_queue()) {
                        let image = UIImage(data: data)
                        self.photoImageView.image = image
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }

    }
}