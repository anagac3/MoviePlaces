//
//  MovieMapStorageService.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation

class MovieMapStorageService: MovieMapStorageServiceProtocol {
    
    func save(locations: [Location], for movie: Movie) -> Bool {
        let storageManager = StorageFactory.getStorageManager()
        return storageManager.save(locations:locations, for: movie)
    }
    
    func retrieveLocations(for movie: Movie) -> [Location]? {
        let storageManager = StorageFactory.getStorageManager()
        return storageManager.retrieveLocations(for: movie)
    }
}
