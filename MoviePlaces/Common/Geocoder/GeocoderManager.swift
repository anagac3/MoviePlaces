//
//  GeolocationManager.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/24/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation
import CoreLocation

class GeocoderManager: GeocoderManagerProtocol {
    
    static let shared = GeocoderManager()
    
    private lazy var region: CLCircularRegion = {
        let center = CLLocationCoordinate2D(latitude: MoviePlacesConstants.initialCoordinateLatitude, longitude: MoviePlacesConstants.initialCoordinateLongitude)
        let radius: Double = 20000
        let region = CLCircularRegion(center: center, radius: radius, identifier: MoviePlacesConstants.moviePlace)
        return region
    }()
    
    func geolocatePlace(place: String, completion: @escaping (((Double, Double)?) -> Void)) {
        //Using apple's decoder, even after including region to prioritize results for the region we are interested,
        //does not return accurate results sometimes, and can include results outside of region
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(place, in: region) { (placemark, error) in
            guard error == nil, let first = placemark?.first, let location = first.location else {
                completion(nil)
                return
            }
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            completion((latitude, longitude))
        }
    }
    
}
