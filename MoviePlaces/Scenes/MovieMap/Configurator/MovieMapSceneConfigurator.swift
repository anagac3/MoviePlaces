//
//  MovieMapSceneConfigurator.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import UIKit

struct MovieMapSceneConfigurator {
    
    static func configureViewController() -> MovieMapViewController {
        
        let storageService = MovieMapStorageService()
        let geolocationService = MovieMapGeolocationService()
        
        let interactor = MovieMapInteractor(storageService: storageService, geolocationService: geolocationService)
        let movieMapVC = MovieMapViewController(interactor: interactor)
        
        interactor.delegate = movieMapVC
        
        return movieMapVC
    }
    
}
