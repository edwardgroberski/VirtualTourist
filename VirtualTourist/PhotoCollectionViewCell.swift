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
    
    struct Contants {
        static let cellIdentifier = "photoCell"
    }

    @IBOutlet weak var photoImageView: UIImageView!
    var photo: Photo?
    
    
    func configure() {
        print(photo?.url)
    }
}