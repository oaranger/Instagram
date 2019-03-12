//
//  Post.swift
//  FirebaseInstagram
//
//  Created by Binh Huynh on 1/10/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import UIKit

struct Post {
    let imageUrl: String
    let user: User
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
