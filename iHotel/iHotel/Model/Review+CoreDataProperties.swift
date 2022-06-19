//
//  Review+CoreDataProperties.swift
//  
//
//  Created by admin on 17/07/2022.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var genre: String?
    @NSManaged public var id: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var lastUpdated: Int64
    @NSManaged public var hotelName: String?
    @NSManaged public var rating: Int64
    @NSManaged public var review: String?
    @NSManaged public var userId: String?
    @NSManaged public var wasDeleted: Bool

}
