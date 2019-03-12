//
//  User.swift
//  FirebaseInstagram
//
//  Created by Binh Huynh on 1/11/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let username: String
    let profileImageUrl: String
    init(uid: String, dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImage"] as? String ?? ""
        self.uid = uid
    }
}
