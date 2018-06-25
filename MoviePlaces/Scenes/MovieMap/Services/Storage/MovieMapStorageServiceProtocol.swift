//
//  MovieMapServiceProtocol.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation

protocol MovieMapStorageServiceProtocol {
    
    func save(locations: [Location], for movie: Movie) -> Bool
    func retrieveLocations(for movie: Movie) -> [Location]?
    
}
