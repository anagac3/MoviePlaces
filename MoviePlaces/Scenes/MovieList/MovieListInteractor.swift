//
//  MovieListInteractor.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/23/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation


class MovieListInteractor: MovieListInteractorProtocol {
    
    weak var delegate: MovieListViewControllerDelegate?
    
    private let networkingService: MovieListNetworkingServiceProtocol
    private let storageService: MovieListStorageServiceProtocol
    
    init(networkingService: MovieListNetworkingServiceProtocol, storageService: MovieListStorageServiceProtocol) {
        self.networkingService = networkingService
        self.storageService = storageService
    }
    
    func getMovies() {
        //Checking if movies are stored already
        if let movies = storageService.retrieveMovies() {
            delegate?.successFetchedMovies(movies: movies)
            return
        }
        //If movies not stored, download and save
        networkingService.downloadMovies { (result: NetworkingServiceResult<Any, Error>) in
            switch (result) {
            case .success(let data):
                let parser = MovieListParser()
                let movies = parser.parseData(data)
                let _ = self.storageService.save(movies: movies)
                self.delegate?.successFetchedMovies(movies: movies)
            case .failure(let error):
                let specificError = error as NSError
                if let description = specificError.userInfo[NSLocalizedDescriptionKey] as? String {
                    self.delegate?.errorFetchingMovies(error: description)
                }
            }
        }
    }
}


