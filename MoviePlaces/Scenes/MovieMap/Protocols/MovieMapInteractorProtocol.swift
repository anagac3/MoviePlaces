//
//  MovieMapInteractorProtocol.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

protocol MovieMapInteractorProtocol {
    
    var delegate: MovieMapViewControllerDelegate? { get set }
    
    func getLocations(for movie: Movie)
}
