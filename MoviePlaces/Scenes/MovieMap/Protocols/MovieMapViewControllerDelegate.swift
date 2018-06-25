//
//  MovieMapViewControllerDelegate.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation

protocol MovieMapViewControllerDelegate: class {
    
    func successFetchedLocations(locations: [LocationAnnotation])
    func failedFetchingLocations(error: String)
    
}
