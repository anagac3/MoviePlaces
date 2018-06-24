//
//  MovieListStorageService.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation

class MovieListStorageService: MovieListStorageServiceProtocol {
    
    func save(movies: [Movie]) -> Bool {
        let storageManager = StorageFactory.getStorageManager()
        return storageManager.save(movies:movies)
    }
    
    func retrieveMovies() -> [Movie]? {
        let storageManager = StorageFactory.getStorageManager()
        return storageManager.retrieveMovies()
    }
    
}
