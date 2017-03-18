//
//  BlogPosts+CoreDataProperties.swift
//  12parsecs
//
//  Created by Alan Glasby on 16/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData


extension BlogPosts {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<BlogPosts> {
        return NSFetchRequest<BlogPosts>(entityName: "BlogPosts");
    }

    @NSManaged public var author: Int32
    @NSManaged public var category: Int32
    @NSManaged public var content: String?
    @NSManaged public var date: String?
    @NSManaged public var dateGmt: String?
    @NSManaged public var excerpt: String?
    @NSManaged public var featuredMedia: Int32
    @NSManaged public var id: Int32
    @NSManaged public var link: String?
    @NSManaged public var slug: String?
    @NSManaged public var tag: Int32
    @NSManaged public var title: String?
    @NSManaged public var categories: NSSet?
    @NSManaged public var media: MediaDetails?
    @NSManaged public var tags: NSSet?
    @NSManaged public var user: BlogUsers?

}

// MARK: Generated accessors for categories
extension BlogPosts {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: BlogCategories)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: BlogCategories)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension BlogPosts {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: BlogTags)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: BlogTags)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
