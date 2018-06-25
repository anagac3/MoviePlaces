//
//  MovieMapGeolocationServiceProtocol.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation
import CoreLocation.CLRegion

protocol MovieMapGeolocationServiceProtocol {
    
    func geolocatePlace(place: String, completion: @escaping (((Double, Double)?) -> Void))
    
}
