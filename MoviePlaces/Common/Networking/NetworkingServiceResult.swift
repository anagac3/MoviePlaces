//
//  NetworkingResult.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/23/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation

enum NetworkingServiceResult<T, Error> {
    case success(T)
    case failure(Error)
}
