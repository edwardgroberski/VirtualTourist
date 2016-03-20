//
//  PinViewController.swift
//  VirtualTourist
//
//  Created by Eddie Groberski on 3/19/16.
//  Copyright © 2016 Edward Groberski. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PinViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var picturesCollectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}