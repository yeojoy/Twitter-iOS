//
//  TwitterUser.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-10-04.
//

import Foundation

struct TwitterUser {
    let username: String
    let email: String
    let fullname: String
    let profileImageUrl: URL?
    let uid: String
    
    init(uid: String, dict: [String: AnyObject]) {
        self.uid = uid
        self.username = dict[DB_FIELD_USERNAME] as? String ?? "" // "" is default value. it means empty string.
        self.fullname = dict[DB_FIELD_FULLNAME] as? String ?? ""
        self.email = dict[DB_FIELD_EMAIL] as? String ?? ""

        if let profileImageString = dict[DB_FIELD_PROFILE_IMAGE_URL] as? String {
            self.profileImageUrl = URL(string: profileImageString)
        } else {
            self.profileImageUrl = URL(string: "")
        }
    }
}
