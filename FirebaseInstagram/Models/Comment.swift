//
//  Comment.swift
//  FirebaseInstagram
//
//  Created by Binh Huynh on 1/19/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import UIKit

struct Comment {
    let text: String
    let uid: String
    var user: User
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
