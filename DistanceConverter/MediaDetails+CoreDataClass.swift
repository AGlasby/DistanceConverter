//
//  MediaDetails+CoreDataClass.swift
//  12parsecs
//
//  Created by Alan Glasby on 05/03/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation
import CoreData

@objc(MediaDetails)
public class MediaDetails: NSManagedObject {

    class func extractMedia(json: [String: Any], media: MediaDetails) -> Bool? {
        guard let mediaId = json["id"] as? Int32,
            let date = json["date"] as? String,
            let mediaLink = json["link"] as? String,
            let mediaDescriptionTmp = json["description"] as? Dictionary<String, Any>,
            let mediaCaptionTmp = json["caption"] as? Dictionary<String, Any>,
            let mediaDetails = json["media_details"] as? Dictionary<String, Any>,
            let mediaSizes = mediaDetails["sizes"] as? Dictionary<String, Any>,
            let mediaThumb = mediaSizes["thumbnail"] as? Dictionary<String, Any>,
            let mediaThumbUrl = mediaThumb["source_url"] as? String
            else {
                return nil
        }
        guard let mediaDescription = mediaDescriptionTmp["rendered"] as? String,
            let mediaCaption = mediaCaptionTmp["rendered"] as? String
            else {
                return nil
        }
        media.mediaId = mediaId
        media.mediaDate = date
        media.mediaUrl = mediaLink
        media.mediaCaption = mediaCaption
        media.mediaDescription = mediaDescription
        media.mediaThumbUrl = mediaThumbUrl
        return true
    }
}
