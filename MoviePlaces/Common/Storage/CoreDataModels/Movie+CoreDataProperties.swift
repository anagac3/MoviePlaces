//
//  Movie+CoreDataProperties.swift
//  MoviePlaces
//
//  Created by Andres Aguilar on 6/23/18.
//  Copyright © 2018 Andres Aguilar. All rights reserved.
//
//

import Foundation
import CoreData


extension MOMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOMovie> {
        return NSFetchRequest<MOMovie>(entityName: "MOMovie")
    }

    @NSManaged public var title: String
    @NSManaged public var releaseYear: String?
    @NSManaged public var director: String?
    @NSManaged public var productionCompany: String?
    @NSManaged public var locations: NSSet?

}

// MARK: Generated accessors for locations
extension MOMovie {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: MOLocation)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: MOLocation)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSSet)

}
