//
//  MovieMapGeolocationService.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation
import CoreLocation

class MovieMapGeolocationService: MovieMapGeolocationServiceProtocol {
    
    func geolocatePlace(place: String, completion: @escaping (((Double, Double)?) -> Void)) {
        
        let geocoderManager = GeocoderFactory.getStorageManager()
        geocoderManager.geolocatePlace(place: place, completion: completion)
    }
    
}
