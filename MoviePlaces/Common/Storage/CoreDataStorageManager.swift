//
//  StorageManager.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStorageManager: StorageManagerProtocol {
    
    static let shared = CoreDataStorageManager()
    
    private var persistentStoreLoaded = false
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoviePlaces")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            self.persistentStoreLoaded = (error == nil) ? true: false
        })
        return container
    }()
    
    func save(movies: [Movie]) -> Bool {
        
        for movie in movies {
            let _ = encode(movie: movie)
        }
        return saveContext()
    }
    
    func retrieveMovies() -> [Movie]? {
        
        let context = persistentContainer.viewContext
        guard persistentStoreLoaded else { return nil }
        let fetchRequest: NSFetchRequest<MOMovie> = MOMovie.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            guard result.count > 0 else { return nil }
            var movies = [Movie]()
            for moMovie in result {
                let newMovie = decodeToMovie(moMovie: moMovie)
                movies.append(newMovie)
            }
            return movies
        } catch {
            return nil
        }
        
    }
    
    // MARK: - Core Data Saving support
    private func saveContext () -> Bool {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                return false
            }
        }
        return true
    }
}

//Encoding & Decoding
extension CoreDataStorageManager {
    private func encode (movie: Movie) -> MOMovie {
        let context = persistentContainer.viewContext
        
        var locationsSet = Set<MOLocation>()
        for location in movie.locations {
            let newLocation = encode(location: location)
            locationsSet.insert(newLocation)
        }
        
        let moMovie = MOMovie(entity: MOMovie.entity(), insertInto: context)
        moMovie.title = movie.title
        moMovie.director = movie.director
        moMovie.productionCompany = movie.productionCompany
        moMovie.releaseYear = movie.releaseYear
        
        moMovie.addToLocations(NSSet(set: locationsSet))
        return moMovie
    }
    
    private func decodeToMovie (moMovie: MOMovie) -> Movie {
        
        var locations = [Location]()
        if let moLocations = moMovie.locations as? Set<MOLocation> {
            
            for moLocation in moLocations {
                guard let newLocation = decodeToLocation(moLocation: moLocation) else { continue }
                locations.append(newLocation)
            }
        }
        
        let newMovie = Movie(title: moMovie.title, releaseYear: moMovie.releaseYear ?? "", director: moMovie.director ?? "", productionCompany: moMovie.productionCompany ?? "", locations: locations)
        
        return newMovie
    }
    
    private func encode (location: Location) -> MOLocation {
        let context = persistentContainer.viewContext
        
        let newLocation = MOLocation(entity: MOLocation.entity(), insertInto: context)
        newLocation.name = location.name
        newLocation.latitude = location.latitude ?? 0
        newLocation.longitude = location.longitude ?? 0
        return newLocation
    }
    
    private func decodeToLocation(moLocation: MOLocation) -> Location? {
        guard let name = moLocation.name else { return nil }
        let latitude = (moLocation.latitude != 0) ? moLocation.latitude : nil
        let longitude = (moLocation.longitude != 0) ? moLocation.longitude : nil
        let newLocation = Location(name: name, latitude: latitude, longitude: longitude)
        return newLocation
    }
}
