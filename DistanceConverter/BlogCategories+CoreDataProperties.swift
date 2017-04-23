//
//  BlogCategories+CoreDataProperties.swift
//  12parsecs
//
//  Created by Alan Glasby on 09/04/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData


extension BlogCategories {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<BlogCategories> {
        return NSFetchRequest<BlogCategories>(entityName: "BlogCategories")
    }

    @NSManaged public var categoryId: Int32
    @NSManaged public var categoryName: String?
    @NSManaged public var posts: NSSet?

}

// MARK: Generated accessors for posts
extension BlogCategories {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: BlogPosts)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: BlogPosts)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}
