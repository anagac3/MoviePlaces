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
    
    private var masterViewController: MovieListViewController!
    private var detailViewController: MovieMapViewController!
    private var splitViewController: UISplitViewController!
    
    func initializeApp() -> UIViewController {
        splitViewController = UISplitViewController()
        
        masterViewController = configureMovieList()
        let navigationController = UINavigationController.init(rootViewController: masterViewController)
        
        detailViewController = configureMovieMap()
        let navigationControllerDetail = UINavigationController.init(rootViewController: detailViewController)
        
        splitViewController.viewControllers = [navigationController, navigationControllerDetail]
        splitViewController.preferredDisplayMode = .allVisible
        splitViewController.delegate = masterViewController
        
        //Setting the display button
        detailViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        detailViewController.navigationItem.leftItemsSupplementBackButton = true
        
        return splitViewController
    }
    
    func navigate(to route: Routes, parameters: Any?) {
        switch route {
        case .list:
            //We'll go back with back button
            break
        case .map:
            guard let movie = parameters as? Movie else { return }
            masterViewController.collapseDetail = false
            splitViewController.showDetailViewController(detailViewController.navigationController!, sender: nil)
            detailViewController.movie = movie
        }
    }
    
    private func configureMovieList() -> MovieListViewController {
        return MovieListSceneConfigurator.configureViewController()
    }
    
    private func configureMovieMap() -> MovieMapViewController {
        return MovieMapSceneConfigurator.configureViewController()
    }
    
}
