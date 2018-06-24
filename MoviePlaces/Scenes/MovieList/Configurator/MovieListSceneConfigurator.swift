//
//  Configurator.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/23/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import UIKit

struct MovieListSceneConfigurator {
    
    static func configureViewController() -> UIViewController {
        
        let networkingService = MovieListNetworkingService()
        let storageService = MovieListStorageService()
        let interactor = MovieListInteractor(networkingService: networkingService, storageService: storageService)
        let viewController = MovieListViewController(interactor: interactor)
        
        interactor.delegate = viewController
        
        return viewController
    }
    
}
