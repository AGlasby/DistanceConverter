//
//  BlogPost+CoreDataProperties.swift
//  12parsecs
//
//  Created by Alan Glasby on 08/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData


extension BlogPost {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<BlogPost> {
        return NSFetchRequest<BlogPost>(entityName: "BlogPost");
    }

    @NSManaged public var author: Int32
    @NSManaged public var categories: Int32
    @NSManaged public var content: String?
    @NSManaged public var date: String?
    @NSManaged public var dateGmt: String?
    @NSManaged public var excerpt: String?
    @NSManaged public var featuredMedia: Int32
    @NSManaged public var id: Int32
    @NSManaged public var link: String?
    @NSManaged public var slug: String?
    @NSManaged public var tags: Int32
    @NSManaged public var title: String?
    @NSManaged public var category: NSSet?
    @NSManaged public var media: MediaDetails?
    @NSManaged public var tag: NSSet?
    @NSManaged public var user: BlogUsers?

}

// MARK: Generated accessors for category
extension BlogPost {

    @objc(addCategoryObject:)
    @NSManaged public func addToCategory(_ value: BlogCategories)

    @objc(removeCategoryObject:)
    @NSManaged public func removeFromCategory(_ value: BlogCategories)

    @objc(addCategory:)
    @NSManaged public func addToCategory(_ values: NSSet)

    @objc(removeCategory:)
    @NSManaged public func removeFromCategory(_ values: NSSet)

}

// MARK: Generated accessors for tag
extension BlogPost {

    @objc(addTagObject:)
    @NSManaged public func addToTag(_ value: BlogTags)

    @objc(removeTagObject:)
    @NSManaged public func removeFromTag(_ value: BlogTags)

    @objc(addTag:)
    @NSManaged public func addToTag(_ values: NSSet)

    @objc(removeTag:)
    @NSManaged public func removeFromTag(_ values: NSSet)

}
