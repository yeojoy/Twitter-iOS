//
//  Notification.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-11-06.
//

import Foundation

enum NotificationType: Int {
    case follow // 0
    case like // 1
    case reply // 2
    case retweet // 3
    case mention // 4
}

struct Notification {
    
    let tweetId: String?
    var timestamp: Date!
    let user: TwitterUser
    /*var tweet: Tweet? */
    var type: NotificationType!
    
    init(user: TwitterUser, /*tweet: Tweet?, */dictionary: [String: Any]) {
        self.user = user
        // self.tweet = tweet
        
        self.tweetId = dictionary[DB_FIELD_TWEET_ID] as? String ?? ""
        
        if let timestamp = dictionary[DB_FILED_TIMESTAMP] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp / 1000)
        }

        if let type = dictionary[DB_FIELD_TYPE] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
