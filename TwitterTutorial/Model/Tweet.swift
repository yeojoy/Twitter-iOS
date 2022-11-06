//
//  Tweet.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-10-07.
//

import FirebaseDatabase

struct Tweet {
    var tweetId: String
    let caption: String
    let uid: String
    var likes: Int
    var timestamp: Date?
    var retweetCount: Int
    
    var user: TwitterUser
    var didLike = false
    
    init(tweetId: String, user: TwitterUser, dictionary: [String: Any]) {
        self.tweetId = tweetId
        self.user = user
        
        self.caption = dictionary[DB_FILED_CAPTION] as? String ?? ""
        self.uid = dictionary[DB_FILED_USER_ID] as? String ?? ""
        self.likes = dictionary[DB_FILED_LIKES] as? Int ?? 0
        self.retweetCount = dictionary[DB_FILED_RETWEETS] as? Int ?? 0
        
        if let timestamp = dictionary[DB_FILED_TIMESTAMP] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp / 1000)
        } else {
            self.timestamp = nil
        }
    }
}
