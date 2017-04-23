//
//  TagsForPost+CoreDataProperties.swift
//  12parsecs
//
//  Created by Alan Glasby on 17/04/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData


extension TagsForPost {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<TagsForPost> {
        return NSFetchRequest<TagsForPost>(entityName: "TagsForPost")
    }

    @NSManaged public var tagId: Int32
    @NSManaged public var details: BlogTags?
    @NSManaged public var post: BlogPosts?

}
