//
//  blogTags.swift
//  12parsecs
//
//  Created by Alan Glasby on 25/01/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation

struct BlogTag {
    private var _tagId: Int
    private var _tagName: String

    var tagId: Int {
        return _tagId
    }

    var tagName: String {
        return _tagName
    }

    init(tagId: Int, tagName: String) {
        _tagId = tagId
        _tagName = tagName
    }

    init?(json: [String: Any]) {
        guard let tagId = json["id"] as? Int,
        let tagName = json["name"] as? String
            else {
                return nil
        }
        _tagId = tagId
        _tagName = tagName
    }
}
