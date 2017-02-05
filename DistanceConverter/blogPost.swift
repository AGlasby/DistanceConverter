//
//  blogPost.swift
//  12parsecs
//
//  Created by Alan Glasby on 20/01/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation

struct BlogPost {

    private var _date_gmt: String!
    private var _id: Int!
    private var _slug: String!
    private var _title: String!
    private var _content: String!
    private var _author: Int!
    private var _excerpt: String!
    private var _featured_media: Int!
    private var _categories: [Int]!
    private var _tags: [Int]!
    private var _link: String!

    var date_gmt: String {
        return _date_gmt
    }

    var id: Int {
        return _id
    }

    var slug: String {
        return _slug
    }

    var title: String {
        return _title
    }

    var content: String {
        return _content
    }

    var author: Int {
        return _author
    }

    var excerpt: String {
        return _excerpt
    }

    var featured_media: Int {
        return _featured_media
    }

    var categories: [Int] {
        return _categories
    }

    var tags: [Int] {
        return _tags
    }

    var link: String {
        return _link
    }

    init(date_gmt: String, id: Int, slug: String, title: String, content: String, author: Int, excerpt: String, featuredMedia: Int, categories: [Int], tags: [Int], link: String) {
        _date_gmt = date_gmt
        _id = id
        _slug = slug
        _title = title
        _content = content
        _author = author
        _excerpt = excerpt
        _featured_media = featuredMedia
        _categories = categories
        _tags = tags
        _link = link
    }

    init?(json: [String: Any]) {
        guard let date_gmt_tmp = json["date_gmt"] as? String,
            let id = json["id"] as? Int,
            let slug = json["slug"] as? String,
            let titleTemp = json["title"] as? [String: Any],
            let contentTemp = json["content"] as? [String: Any],

            let author = json["author"] as? Int,
            let excerptTemp = json["excerpt"] as? [String: Any],

            let featuredMedia = json["featured_media"] as? Int,
            let categories = json["categories"] as? [Int],
            let tags = json["tags"] as? [Int],
            let link = json["link"] as? String
            else {
                return nil
            }
            var date_gmt = "0000-01-01"
            if let range = date_gmt_tmp.range(of: "T") {
                date_gmt = date_gmt_tmp.substring(to: range.lowerBound)
            }
            let title = titleTemp["rendered"] as? String
            let content = contentTemp["rendered"] as? String
            let excerpt = excerptTemp["rendered"] as? String

            _date_gmt = date_gmt
            _id = id
            _slug = slug
            _title = title
            _content = content
            _author = author
            _excerpt = excerpt
            _featured_media = featuredMedia
            _categories = categories
            _tags = tags
            _link = link
        }


//    private var _date: Date!
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
