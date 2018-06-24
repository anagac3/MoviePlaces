//
//  NetworkingAPI.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/23/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation

struct NetworkingManager: NetworkingManagerProtocol {
    
    private let baseUrl = "https://data.sfgov.org"
    private let query = "accessType=DOWNLOAD"
    
    func get(at path: String, success: @escaping ((Any) -> Void), failure: @escaping ((Error) -> Void)) {
        
        let defaultSession = URLSession(configuration: .default)
        
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = path
        
        
        guard let url = urlComponents?.url else {
            let genericError = NSError(domain: "MovieListNetworkService", code: 999, userInfo: [NSLocalizedDescriptionKey : "Invalid URL"])
            failure(genericError)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = defaultSession.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                DispatchQueue.main.async {
                    success(data)
                }
            }else {
                let error = error ?? NSError(domain: "MovieListNetworkService", code: 999, userInfo: [NSLocalizedDescriptionKey : "Could not get movie data"])
                
                DispatchQueue.main.async {
                    failure(error)
                }
            }
            
            
        }
        
        dataTask.resume()
    }

}
