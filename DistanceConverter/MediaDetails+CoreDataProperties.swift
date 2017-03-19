//
//  MediaDetails+CoreDataProperties.swift
//  12parsecs
//
//  Created by Alan Glasby on 19/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData


extension MediaDetails {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<MediaDetails> {
        return NSFetchRequest<MediaDetails>(entityName: "MediaDetails");
    }

    @NSManaged public var mediaCaption: String?
    @NSManaged public var mediaDate: String?
    @NSManaged public var mediaDescription: String?
    @NSManaged public var mediaId: Int32
    @NSManaged public var mediaThumbUrl: String?
    @NSManaged public var mediaUrl: String?
    @NSManaged public var posts: BlogPosts?

}
