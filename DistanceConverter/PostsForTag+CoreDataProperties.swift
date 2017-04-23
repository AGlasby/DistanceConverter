//
//  PostsForTag+CoreDataProperties.swift
//  12parsecs
//
//  Created by Alan Glasby on 17/04/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData


extension PostsForTag {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<PostsForTag> {
        return NSFetchRequest<PostsForTag>(entityName: "PostsForTag")
    }

    @NSManaged public var tagId: Int32
    @NSManaged public var post: NSSet?
    @NSManaged public var tagDetails: BlogTags?

}

// MARK: Generated accessors for post
extension PostsForTag {

    @objc(addPostObject:)
    @NSManaged public func addToPost(_ value: BlogPosts)

    @objc(removePostObject:)
    @NSManaged public func removeFromPost(_ value: BlogPosts)

    @objc(addPost:)
    @NSManaged public func addToPost(_ values: NSSet)

    @objc(removePost:)
    @NSManaged public func removeFromPost(_ values: NSSet)

}
