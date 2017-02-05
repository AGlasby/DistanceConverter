//
//  blogCategories.swift
//  12parsecs
//
//  Created by Alan Glasby on 25/01/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation

struct BlogCategory {

    private var _categoryId: Int
    private var _categoryName: String

    var categoryId: Int {
        return _categoryId
    }

    var categoryName: String {
        return _categoryName
    }

    init(categoryId: Int, categoryName: String) {
        _categoryId = categoryId
        _categoryName = categoryName
    }

    init?(json: [String: Any]) {
        guard let categoryId = json["id"] as? Int,
        let categoryName = json["name"] as? String
            else {
                return nil
        }
        _categoryId = categoryId
        _categoryName = categoryName
    }
}

