//
//  StorageManagerFactory.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation

struct StorageFactory {
    
    static func getStorageManager() -> StorageManagerProtocol {
        
        return CoreDataStorageManager.shared
        
    }
}
