//
//  BlogTags+CoreDataClass.swift
//  12parsecs
//
//  Created by Alan Glasby on 05/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData

@objc(BlogTags)
public class BlogTags: NSManagedObject {

    class func extractTag(json: [String: Any], tag: BlogTags) -> Bool? {
        guard let tagId = json["id"] as? Int32,
            let tagName = json["name"] as? String
            else {
                return nil
        }
        tag.tagId = tagId
        tag.tagName = tagName
        return true
    }
}
