//
//  PhotoCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Eddie Groberski on 3/20/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import UIKit

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
        print(photo?.url)
        
        if let url = photo?.url {
            activityIndicator.startAnimating()
            self.activityIndicator.hidesWhenStopped = true
            FlickrRequestManager.sharedInstance().flickrDownloadImage(url) { (imageData, error) -> Void in
                guard (error == nil) else {
                    print("There was an error with your request: \(error)")
                    return
                }
                
                if let data = imageData {
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