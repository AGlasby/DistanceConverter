//
//  BlogCategories+CoreDataProperties.swift
//  12parsecs
//
//  Created by Alan Glasby on 16/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData


extension BlogCategories {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<BlogCategories> {
        return NSFetchRequest<BlogCategories>(entityName: "BlogCategories");
    }

    @NSManaged public var categoryId: Int32
    @NSManaged public var categoryName: String?
    @NSManaged public var categories: NSSet?

}

// MARK: Generated accessors for categories
extension BlogCategories {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: BlogPosts)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: BlogPosts)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}
