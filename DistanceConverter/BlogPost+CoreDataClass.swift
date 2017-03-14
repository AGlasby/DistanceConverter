//
//  BlogPost+CoreDataClass.swift
//  12parsecs
//
//  Created by Alan Glasby on 05/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData

@objc(BlogPost)
public class BlogPost: NSManagedObject {

    class func extractPost(json: [String: Any], blogPost: BlogPost) -> Bool? {
        guard let date_gmt = json["date_gmt"] as? String,
            let date = json["date"] as? String,
            let id = json["id"] as? Int32,
            let slug = json["slug"] as? String,
            let titleTemp = json["title"] as? [String: Any],
            let contentTemp = json["content"] as? [String: Any],

            let author = json["author"] as? Int32,
            let excerptTemp = json["excerpt"] as? [String: Any],

            let featuredMedia = json["featured_media"] as? Int32,
//            let categories = json["categories"] as? [Int],
//            let tags = json["tags"] as? [Int],
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
//        blogPost.categories = categories
//        blogPost.tags = tags
        blogPost.link = link
        return true

        //  The following fields in the json data are not currently handled
        //    private var _guid: [String: Any]!
        //    private var _modified: String!
        //    private var _modified_gmt: String!
        //    private var _status: String!
        //    private var _type: String!
        //    private var _password: String!
        //    private var _comment_status: String!
        //    private var _ping_status: String!
        //    private var _format: String!
        //    private var _meta: [String: Any]!
        //    private var _sticky: Bool!
        //    private var _template: String!
        //    private var _liveblog_likes: Int!
    }
}
