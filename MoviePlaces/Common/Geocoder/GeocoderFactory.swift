//
//  GeocoderFactory.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation

struct GeocoderFactory {
    
    static func getStorageManager() -> GeocoderManagerProtocol {
        return GeocoderManager.shared
    }
}
