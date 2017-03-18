//
//  BlogPosts+CoreDataClass.swift
//  12parsecs
//
//  Created by Alan Glasby on 16/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData

@objc(BlogPosts)
public class BlogPosts: NSManagedObject {
    
    class func extractPost(json: [String: Any], blogPost: BlogPosts) -> Bool? {
        guard let date_gmt = json["date_gmt"] as? String,
            let date = json["date"] as? String,
            let id = json["id"] as? Int32,
            let slug = json["slug"] as? String,
            let titleTemp = json["title"] as? [String: Any],
            let contentTemp = json["content"] as? [String: Any],
            let author = json["author"] as? Int32,
            let excerptTemp = json["excerpt"] as? [String: Any],
            let featuredMedia = json["featured_media"] as? Int32,
//            let tags = json["tags"] as? [Int32],
//            let categories = json["categories"] as? [Int32],
            let link = json["link"] as? String
            else {
                return nil
        }

        guard let title = titleTemp["rendered"] as? String
            else {
                return nil
        }

        guard let content = contentTemp["rendered"] as? String
            else {
                return nil
        }

        guard let excerpt = excerptTemp["rendered"] as? String
            else {
                return nil
        }


        blogPost.dateGmt = date_gmt
        blogPost.date = date
        blogPost.id = id
        blogPost.slug = slug
        blogPost.title = title
        blogPost.content = content
        blogPost.author = author
        blogPost.excerpt = excerpt
        blogPost.featuredMedia = featuredMedia
//        blogPost.addToCategories(categories)
//        blogPost.addToTags(tags)
        blogPost.link = link
        return true
    }
}
