//
//  NetowrkingAPIProtocol.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/23/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//

import Foundation

protocol NetworkingManagerProtocol {
    func get(at path: String, success: @escaping ((Any) -> Void), failure: @escaping ((Error) -> Void))
}
