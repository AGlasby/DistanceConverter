//
//  BlogUsers+CoreDataClass.swift
//  12parsecs
//
//  Created by Alan Glasby on 05/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData

var blogUsersMO: NSManagedObjectContext?

@objc(BlogUsers)
public class BlogUsers: NSManagedObject {

    class func extractUsers(json: [String: Any], user: BlogUsers) -> Bool? {
        guard let userId = json["id"] as? Int32,
            let userName = json["name"] as? String
            else {
                return nil
        }
        user.userId  = userId
        user.userName = userName
        return true
    }
}
