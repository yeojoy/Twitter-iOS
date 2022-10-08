//
//  TweetService.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-10-05.
//

import FirebaseDatabase
import FirebaseAuth

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let timestamp = Int(NSDate().timeIntervalSince1970) * 1000 // make seconds milliseconds.
        let values = [
            DB_FILED_USER_ID: uid,
            DB_FILED_TIMESTAMP: timestamp,
            DB_FILED_LIKES: 0,
            DB_FILED_RETWEETS: 0,
            DB_FILED_CAPTION: caption
        ] as [String: Any]
        
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        tweets.removeAll()
        
        REF_TWEETS.observe(.childAdded) { snapshot, _ in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetId = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(tweetId: tweetId, user: user, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
}
