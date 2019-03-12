//
//  FirebaseUtils.swift
//  FirebaseInstagram
//
//  Created by Binh Huynh on 1/11/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> Void) {
        print("Fetching user with uid:", uid)
        let usersRef = Database.database().reference().child("users").child(uid)
        usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { (error) in
            print("Failed to fetch users for posts", error)
        }
    }
}
