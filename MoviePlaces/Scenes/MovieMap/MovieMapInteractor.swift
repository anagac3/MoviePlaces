//
//  MovieMapInteractor.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

class MovieMapInteractor: MovieMapInteractorProtocol {
    
    weak var delegate: MovieMapViewControllerDelegate?
    
    private let storageService: MovieMapStorageServiceProtocol
    private let geolocationService: MovieMapGeolocationServiceProtocol
    
    init(storageService: MovieMapStorageServiceProtocol, geolocationService: MovieMapGeolocationServiceProtocol) {
        self.storageService = storageService
        self.geolocationService = geolocationService
    }
    
    func getLocations(for movie: Movie) {
        
        guard let savedLocations = storageService.retrieveLocations(for: movie) else {
            delegate?.failedFetchingLocations(error: "No locations for this movie")
            return
        }
        var missingLocations = [Location]()
        var fetchedLocations = [Location]()
        //Check what locations are missing
        for location in savedLocations {
            if ( location.latitude == nil || location.longitude == nil) {
                missingLocations.append(location)
            }else {
                fetchedLocations.append(location)
            }
        }
        //If Location coordinates are already fetch
        if missingLocations.count == 0 {
            let annotations = decodeToLocationAnnotatios(locations: savedLocations)
            delegate?.successFetchedLocations(locations: annotations)
            return
        }
        
        let privateQueue = DispatchQueue(label: "GeolocalizationPrivateQueue")
        let group = DispatchGroup()
        var newLocations = [Location]()
        for missingLocation in missingLocations {
            group.enter()
            privateQueue.async {
                self.geolocationService.geolocatePlace(place: missingLocation.name, completion: { (coordinates) in
                    if let (latitude, longitude) = coordinates {
                        var newLocation = missingLocation
                        newLocation.latitude = latitude
                        newLocation.longitude = longitude
                        newLocations.append(newLocation)
                    }
                    group.leave()
                })
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            let merged = newLocations + fetchedLocations
            let _ = self.storageService.save(locations: merged, for: movie)
            let annotations = self.decodeToLocationAnnotatios(locations: merged)
            self.delegate?.successFetchedLocations(locations: annotations)
        }
        
    }
    
    private func decodeToLocationAnnotatios(locations: [Location]) -> [LocationAnnotation] {
        var annotations = [LocationAnnotation]()
        for location in locations {
            guard let latitude = location.latitude, let longitude = location.longitude else { continue }
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let newAnnotation = LocationAnnotation(title: location.name, coordinate: coordinate)
            annotations.append(newAnnotation)
        }
        return annotations
    }
    
}
