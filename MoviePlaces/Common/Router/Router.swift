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
    
    enum Routes: String {
        case list
        case map
    }
    
    private var currentNavigationController: UINavigationController?
    private var currentRootViewController: UIViewController?
    
    func initializeApp() -> UIViewController {
        
        let movieListVC = configureMovieList()
        let navigationController = UINavigationController.init(rootViewController: movieListVC)
        
        currentNavigationController = navigationController
        currentRootViewController = movieListVC
        
        return navigationController
    }
    
    func navigate(to route: Routes, parameters: Any?) {
        switch route {
        case .list:
            //We'll go back with back button
            break
        case .map:
            if let currentNav = currentNavigationController, let movie = parameters as? Movie{
                let movieMapVC = configureMovieMap(selectedMovie: movie)
                currentNav.pushViewController(movieMapVC, animated: true)
            }
        }
    }
    
    private func configureMovieList() -> UIViewController {
        return MovieListSceneConfigurator.configureViewController()
    }
    
    private func configureMovieMap(selectedMovie movie: Movie) -> UIViewController {
        return MovieMapSceneConfigurator.configureViewController(selectedMovie: movie)
    }
    
}
