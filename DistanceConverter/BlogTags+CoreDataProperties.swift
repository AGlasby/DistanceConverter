//
//  BlogTags+CoreDataProperties.swift
//  12parsecs
//
//  Created by Alan Glasby on 19/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData


extension BlogTags {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<BlogTags> {
        return NSFetchRequest<BlogTags>(entityName: "BlogTags");
    }

    @NSManaged public var tagId: Int32
    @NSManaged public var tagName: String?
    @NSManaged public var posts: NSSet?

}

// MARK: Generated accessors for posts
extension BlogTags {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: BlogPosts)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: BlogPosts)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}
