//
//  MovieListParser.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation

struct MovieListParser {
    
    private enum MovieParserPosition: Int {
        case title = 8
        case releaseYear = 9
        case locations = 10
        case productionCompany = 12
        case director = 14
    }
    
    func parseData(_ data: Any) -> [Movie] {
        
        let largestKey = 14
        
        //Holding generated data
        var titlesDictionary = Dictionary<String, Movie>()
        
        guard let data = data as? Data else { return [Movie]() }
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        guard let dataDictionary = jsonObject as? Dictionary<String, Any>, let moviesData = dataDictionary["data"] as? [[Any]] else { return [Movie]() }
        //Merging movies based on movie title, and updating locations
        for movieData in moviesData {
            guard movieData.count > largestKey, let title = movieData[MovieParserPosition.title.rawValue] as? String else { continue }
            var newMovie: Movie
            //Prevent titles repeating over spaces at the end of title
            let trimmedTitle = title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            // If movie object is already created, retrieve and update it for the new location, otherwise, create  a new one
            if let movie = titlesDictionary[trimmedTitle] {
                newMovie = movie
            } else {
                let releaseYear = movieData[MovieParserPosition.releaseYear.rawValue] as? String ?? ""
                let director = movieData[MovieParserPosition.director.rawValue] as? String ?? ""
                let productionCompany = movieData[MovieParserPosition.productionCompany.rawValue] as? String ?? ""
                
                newMovie = Movie(title: trimmedTitle, releaseYear: releaseYear, director: director, productionCompany: productionCompany, locations: [Location]())
            }
            guard let location = movieData[MovieParserPosition.locations.rawValue] as? String else { continue }
            let newLocation = Location(name: location, latitude: nil, longitude: nil)
            newMovie.locations.append(newLocation)
            titlesDictionary[trimmedTitle] = newMovie
        }
        
        return Array(titlesDictionary.values)
    }
    
}
