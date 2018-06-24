//
//  NetworkingFactory.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/23/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation

struct NetworkingFactory {
    
    static func getNetworkingManager() -> NetworkingManagerProtocol {
        
        return NetworkingManager()
        
    }
}
