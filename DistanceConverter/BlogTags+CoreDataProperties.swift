//
//  BlogTags+CoreDataProperties.swift
//  12parsecs
//
//  Created by Alan Glasby on 16/03/2017.
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
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for tags
extension BlogTags {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: BlogPosts)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: BlogPosts)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
