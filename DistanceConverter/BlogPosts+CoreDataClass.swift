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
    
    class func extractPost(json: [String: Any], blogPost: BlogPosts, context: NSManagedObjectContext) -> Bool? {
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


        let tagsSet = blogPost.mutableSetValue(forKey: #keyPath(BlogPosts.tagSet))
        for t in 0..<tagsInJson.count {
            if tagsInJson[t] != 0 {
                let fetch: NSFetchRequest<TagsForPost> = TagsForPost.createFetchRequest()
                fetch.predicate = NSPredicate(format: "tagId == %d", tagsInJson[t])
                var results: [TagsForPost]? = nil
                do {
                    results = try context.fetch(fetch)
                } catch {
                    fatalError("Failed to retrieve TagsForPosts from core data \(error)")
                }
                if results?.count == 0 {
                    
                } else {
                    let tag = TagsForPost(context: context)
                    tag.tagId = tagsInJson[t]
                    tagsSet.add(tag)
                }
            }
        }
        blogPost.tagSet = tagsSet.copy() as? NSSet

        for t in 0..<tagsInJson.count {
            if tagsInJson[t] != 0 {
                let fetchP: NSFetchRequest<PostsForTag> = PostsForTag.createFetchRequest()
                fetchP.predicate = NSPredicate(format: "tagId == %d", tagsInJson[t])
                var results: [PostsForTag]? = nil
                do {
                    results = try context.fetch(fetchP)
                } catch {
                    fatalError("Failed to retrieve TagsForPosts from core data \(error)")
                }
                if results?.count == 0 {
                    let tag = PostsForTag(context: context)
                    tag.tagId = tagsInJson[t]
                    tag.addToPost(blogPost as BlogPosts)
                } else {
                    results?.first?.addToPost(blogPost)
                }
            }
        }

//        let categoriesSet = blogPost.mutableSetValue(forKey: #keyPath(BlogPosts.categories))
//        let categoriesForBlogs = NSEntityDescription.entity(forEntityName: "BlogCategories", in: blogCategoriesMO!)
//        for c in 0..<categoriesInJson.count {
//            var category = BlogCategories(entity: categoriesForBlogs!, insertInto: blogCategoriesMO!)
//            if let iIndex = blogCategories.index(where: {$0.categoryId == categoriesInJson[c]}) {
//                category = blogCategories[iIndex]
//            }
//            if category.categoryName != nil && category.categoryId != 0 {
//                categoriesSet.add(category)
//            } else {
//                category.removeFromPosts(blogPost)
//            }
//        }
//        blogPost.categories = categoriesSet.copy() as? NSSet

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




