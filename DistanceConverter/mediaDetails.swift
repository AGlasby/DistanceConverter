//
//  mediaDetails.swift
//  12parsecs
//
//  Created by Alan Glasby on 26/01/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation

struct MediaDetails {
    private var _mediaId: Int
    private var _mediaLink: String
    private var _mediaCaption: String
    private var _mediaDescription: String
    private var _mediaThumbUrl: String

    var mediaId: Int {
        return _mediaId
    }

    var mediaLink: String {
        return _mediaLink
    }

    var mediaCaption: String {
        return _mediaCaption
    }

    var mediaDescription: String {
        return _mediaDescription
    }

    var mediaThumbUrl: String {
        return _mediaThumbUrl
    }

    init(id: Int, link: String, caption: String, desc: String, thumbUrl: String) {
        _mediaId = id
        _mediaLink = link
        _mediaCaption = caption
        _mediaDescription = desc
        _mediaThumbUrl = thumbUrl
    }
}

extension MediaDetails: Equatable {}
func == (lhs: MediaDetails, rhs: MediaDetails) -> Bool {
    let areEqual = lhs.mediaId == rhs.mediaId &&
    lhs.mediaLink == rhs.mediaLink &&
    lhs.mediaCaption == rhs.mediaCaption &&
    lhs.mediaDescription == rhs.mediaDescription &&
    lhs.mediaThumbUrl == rhs.mediaThumbUrl
    return areEqual
}


