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

    class func extractTag(json: [String: Any], tag: BlogTags, context: NSManagedObjectContext) -> Bool? {
        guard let tagId = json["id"] as? Int32,
            let tagName = json["name"] as? String
            else {
                return nil
        }
        tag.tagId = tagId
        tag.tagName = tagName

        let fetch: NSFetchRequest<TagsForPost> = TagsForPost.createFetchRequest()
        fetch.predicate = NSPredicate(format: "tagId == %d", tagId)
        var results: [TagsForPost]? = nil
        do {
            results = try context.fetch(fetch)
        } catch {
            fatalError("Failed to retrieve TagsForPosts from core data \(error)")
        }
        if results?.count == 0 {            
            let newTag = TagsForPost(context: context)
            newTag.tagId = tagId
            tag.setValue(newTag, forKey: "tag")
        }

        let fetch2: NSFetchRequest<PostsForTag> = PostsForTag.createFetchRequest()
        fetch.predicate = NSPredicate(format: "tagId == %d", tagId)
        var results2: [PostsForTag]? = nil
        do {
            results2 = try context.fetch(fetch2)
        } catch {
            fatalError("Failed to retrieve PostsForTag from core data \(error)")
        }
        if results2?.count == 0 {

            let newTag = PostsForTag(context: context)
            newTag.tagId = tagId
            tag.setValue(newTag, forKey: "postSet")

        }
        return true
    }
}


