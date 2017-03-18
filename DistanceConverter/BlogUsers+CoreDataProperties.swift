//
//  BlogUsers+CoreDataProperties.swift
//  12parsecs
//
//  Created by Alan Glasby on 05/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData


extension BlogUsers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlogUsers> {
        return NSFetchRequest<BlogUsers>(entityName: "BlogUsers");
    }

    @NSManaged public var userId: Int32
    @NSManaged public var userName: String?
    @NSManaged public var user: BlogPosts?

}
