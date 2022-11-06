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
    
    func uploadTweet(caption: String, completion: @escaping((Error?, DatabaseReference) -> Void)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = createTweetDictionary(caption: caption, userId: uid)
        
        REF_TWEETS.childByAutoId().updateChildValues(values) { (err, ref) in
            guard let tweetId = ref.key else { return }
            REF_USER_TWEETS.child(uid).updateChildValues([tweetId: 1], withCompletionBlock: completion)
        }
    }
    
    func uploadReply(caption: String, tweetId: String, completion: @escaping((Error?, DatabaseReference) -> Void)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = createTweetDictionary(caption: caption, userId: uid)
        
        REF_TWEET_REPLIES.child(tweetId).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        tweets.removeAll()
        
        REF_TWEETS.observe(.childAdded) { snapshot in
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
    
    func fetchTweetsByUser(forUser user: TwitterUser, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        tweets.removeAll()
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetId = snapshot.key
            print("DEBUG: fetchTweetsByUser(uid: \(user.uid), tweetId: \(tweetId)")
            REF_TWEETS.child(tweetId).observeSingleEvent(of: .value) { tweetSnapshot in
                guard let dictionary = tweetSnapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(tweetId: tweetId, user: user, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var replies = [Tweet]()
        REF_TWEET_REPLIES.child(tweet.tweetId).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetId = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(tweetId: tweetId, user: user, dictionary: dictionary)
                replies.append(tweet)
                completion(replies)
            }
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        
        // 1. update likes count in tweet
        REF_TWEETS.child(tweet.tweetId).child("likes").setValue(likes)
        
        // 2. update user-likes and tweet-likes table
        if tweet.didLike {
            // unlike tweet. remove like data from realtime db
            REF_USER_LIKES.child(uid).child(tweet.tweetId).removeValue { (err, ref) in
                REF_TWEET_LIKES.child(tweet.tweetId).child(uid).removeValue(completionBlock: completion)
            }
        } else {
            // like tweet. add like data to db
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetId: 1]) { (err, ref) in
                REF_TWEET_LIKES.child(tweet.tweetId).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USER_LIKES.child(currentUid).child(tweet.tweetId).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    private func createTweetDictionary(caption: String, userId: String) -> Dictionary<String, Any> {
        let timestamp = Int(NSDate().timeIntervalSince1970) * 1000 // make seconds milliseconds.
        return [
            DB_FILED_USER_ID: userId,
            DB_FILED_TIMESTAMP: timestamp,
            DB_FILED_LIKES: 0,
            DB_FILED_RETWEETS: 0,
             DB_FILED_CAPTION: caption
        ]
    }
}
