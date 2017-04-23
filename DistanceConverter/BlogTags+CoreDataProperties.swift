//
//  BlogTags+CoreDataProperties.swift
//  12parsecs
//
//  Created by Alan Glasby on 17/04/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData


extension BlogTags {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<BlogTags> {
        return NSFetchRequest<BlogTags>(entityName: "BlogTags")
    }

    @NSManaged public var tagId: Int32
    @NSManaged public var tagName: String?
    @NSManaged public var tag: TagsForPost?
    @NSManaged public var postSet: PostsForTag?

}
