//
//  BlogPosts+CoreDataProperties.swift
//  12parsecs
//
//  Created by Alan Glasby on 23/04/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData


extension BlogPosts {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<BlogPosts> {
        return NSFetchRequest<BlogPosts>(entityName: "BlogPosts")
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
    @NSManaged public var title: String?
    @NSManaged public var media: MediaDetails?
    @NSManaged public var tag: PostsForTag?
    @NSManaged public var tagSet: NSSet?

}

// MARK: Generated accessors for tagSet
extension BlogPosts {

    @objc(addTagSetObject:)
    @NSManaged public func addToTagSet(_ value: TagsForPost)

    @objc(removeTagSetObject:)
    @NSManaged public func removeFromTagSet(_ value: TagsForPost)

    @objc(addTagSet:)
    @NSManaged public func addToTagSet(_ values: NSSet)

    @objc(removeTagSet:)
    @NSManaged public func removeFromTagSet(_ values: NSSet)

}
