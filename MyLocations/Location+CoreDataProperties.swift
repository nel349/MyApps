//
//  Location+CoreDataProperties.swift
//  MyLocations
//
//  Created by Norman Lopez on 5/19/17.
//  Copyright © 2017 Norman Lopez. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var placemark: CLPlacemark?
    @NSManaged public var locationDescription: String
    @NSManaged public var date: Date?
    @NSManaged public var category: String
    @NSManaged var photoID: NSNumber?

}
