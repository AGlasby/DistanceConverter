//
//  blogUser.swift
//  12parsecs
//
//  Created by Alan Glasby on 25/01/2017.
//  Copyright © 2017 Alan Glasby. All rights reserved.
//

import Foundation

struct BlogUser {
    private var _userId: Int!
    private var _userName: String!

    var userId: Int {
        return _userId
    }

    var userName: String {
        return _userName
    }

    init(userId: Int, userName: String) {
        _userId = userId
        _userName = userName
    }
}
