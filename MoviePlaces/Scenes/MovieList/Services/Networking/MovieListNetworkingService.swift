//
//  MovieListNetworkingService.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/23/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation

class MovieListNetworkingService: MovieListNetworkingServiceProtocol {
    
    let path = "/api/views/yitu-d5am/rows.json"
    
    func downloadMovies(completion: @escaping ((NetworkingServiceResult<Any, Error>) -> Void)) {
        let networkingManager = NetworkingFactory.getNetworkingManager()
        
        networkingManager.get(at: path, success: { (data) in
            completion(NetworkingServiceResult.success(data))
        }) { (error) in
            completion(NetworkingServiceResult.failure(error))
        }
    }
}
