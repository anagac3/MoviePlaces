//
//  Router.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import UIKit

class Router {
    
    static let shared = Router()
    
    func initializeApp() -> UIViewController {
        
        let movieListVC = MovieListSceneConfigurator.configureViewController()
        let navigationController = UINavigationController.init(rootViewController: movieListVC)
        
        return navigationController
    }
    
}
