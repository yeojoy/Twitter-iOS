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
    
    func fetchUser(completion: @escaping(TwitterUser) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            print("DEBUG: Snapshot: \(snapshot.key)")
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            completion(TwitterUser(uid: uid, dict: dictionary))
        }
    }
}
