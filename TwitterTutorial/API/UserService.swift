//
//  UserService.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-10-04.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct UserService {
    static let shared = UserService()
    
    func fetchUser(uid: String?, completion: @escaping(TwitterUser) -> Void) {
        guard let uid = uid else { return }
        print("DEBUG: fetchUser(uid: \(uid))")
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            completion(TwitterUser(uid: uid, dict: dictionary))
        }
    }
}
