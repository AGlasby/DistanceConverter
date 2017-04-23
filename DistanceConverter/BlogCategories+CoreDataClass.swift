//
//  BlogCategories+CoreDataClass.swift
//  12parsecs
//
//  Created by Alan Glasby on 05/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData

var blogCategoriesMO: NSManagedObjectContext?

@objc(BlogCategories)
public class BlogCategories: NSManagedObject {

    class func extractCategories(json: [String: Any], category: BlogCategories) -> Bool? {
        guard let categoryId = json["id"] as? Int32,
            let categoryName = json["name"] as? String
            else {
                return nil
        }
        category.categoryId = categoryId
        category.categoryName = categoryName
        return true
    }
}
