//
//  BlogCategories+CoreDataProperties.swift
//  12parsecs
//
//  Created by Alan Glasby on 05/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData


extension BlogCategories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlogCategories> {
        return NSFetchRequest<BlogCategories>(entityName: "BlogCategories");
    }

    @NSManaged public var categoryId: Int32
    @NSManaged public var categoryName: String?
    @NSManaged public var category: BlogPost?

}
