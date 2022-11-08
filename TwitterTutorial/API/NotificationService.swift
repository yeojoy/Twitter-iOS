//
//  NotificationService.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-11-06.
//

import FirebaseDatabase
import FirebaseAuth

struct NotificationService {
    static let shared = NotificationService()
    
    func uploadNotification(type: NotificationType, tweet: Tweet? = nil, user: TwitterUser? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var values: [String: Any] = [DB_FILED_TIMESTAMP: Int(NSDate().timeIntervalSince1970 * 1000),
                                        DB_FILED_USER_ID: uid,
                                        DB_FIELD_TYPE: type.rawValue]
        if let tweet = tweet {
            // Like notification
            values[DB_FIELD_TWEET_ID] = tweet.tweetId
            REF_NOTIFICATIONS.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        } else if let user = user {
            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
        } else {
            // Follow or reply
        }
    }
    
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        var notifcations = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary[DB_FILED_USER_ID] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let notification = Notification(user: user, dictionary: dictionary)
                notifcations.append(notification)
                completion(notifcations)
            }
        }
    }
}
