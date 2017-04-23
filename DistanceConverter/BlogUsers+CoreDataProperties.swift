//
//  BlogUsers+CoreDataProperties.swift
//  12parsecs
//
//  Created by Alan Glasby on 09/04/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData


extension BlogUsers {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<BlogUsers> {
        return NSFetchRequest<BlogUsers>(entityName: "BlogUsers")
    }

    @NSManaged public var userId: Int32
    @NSManaged public var userName: String?
    @NSManaged public var posts: NSSet?

}

// MARK: Generated accessors for posts
extension BlogUsers {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: BlogPosts)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: BlogPosts)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}
