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
    
    class func extractPost(json: [String: Any], blogPost: BlogPosts, blogTags: [BlogTags], blogCategories: [BlogCategories]) -> Bool? {
        guard let date_gmt = json["date_gmt"] as? String,
            let date = json["date"] as? String,
            let id = json["id"] as? Int32,
            let slug = json["slug"] as? String,
            let titleTemp = json["title"] as? [String: Any],
            let contentTemp = json["content"] as? [String: Any],
            let author = json["author"] as? Int32,
            let excerptTemp = json["excerpt"] as? [String: Any],
            let featuredMedia = json["featured_media"] as? Int32,
            let tagsInJson = json["tags"] as? [Int32],
            let categoriesInJson = json["categories"] as? [Int32],
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

        let tagsCopy = blogPost.tags!.mutableCopy() as! NSMutableSet
        let tagsForBlogs = NSEntityDescription.entity(forEntityName: "BlogTags", in: container.viewContext)
        for t in 0..<tagsInJson.count {
            let tag = BlogTags(entity: tagsForBlogs!, insertInto: container.viewContext)
            tag.tagId = tagsInJson[t]
            if let iIndex = blogTags.index(where: {$0.tagId == tagsInJson[t]}) {
                tag.tagName = blogTags[iIndex].tagName
            }
            tagsCopy.add(tag)
        }
        blogPost.tags = tagsCopy.copy() as? NSSet

        let categoriesCopy = blogPost.categories!.mutableCopy() as! NSMutableSet
        let categoriesForBlogs = NSEntityDescription.entity(forEntityName: "BlogCategories", in: container.viewContext)
        for c in 0..<categoriesInJson.count {
            let category = BlogCategories(entity: categoriesForBlogs!, insertInto: container.viewContext)
            category.categoryId = categoriesInJson[c]
            if let iIndex = blogCategories.index(where: {$0.categoryId == categoriesInJson[c]}) {
                category.categoryName = blogCategories[iIndex].categoryName
            }
            categoriesCopy.add(category)
        }
        blogPost.categories = categoriesCopy.copy() as? NSSet

        blogPost.dateGmt = date_gmt
        blogPost.date = date
        blogPost.id = id
        blogPost.slug = slug
        blogPost.title = title
        blogPost.content = content
        blogPost.author = author
        blogPost.excerpt = excerpt
        blogPost.featuredMedia = featuredMedia
        blogPost.link = link
        return true
    }
}
