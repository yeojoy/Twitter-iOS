//
//  Constants.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-10-03.
//

import FirebaseDatabase
import FirebaseStorage

private let TABLE_USERS = "users"
private let TABLE_TWEETS = "tweets"
private let TABLE_USER_TWEETS = "user-tweets"
private let TABLE_FOLLOWERS = "user-followers"
private let TABLE_FOLLOWING = "user-following"

private let STORAGE_DIR = "profile_images"

// Firebase Storage
private let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child(STORAGE_DIR)

// Realtime database
private let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child(TABLE_USERS)
let REF_TWEETS = DB_REF.child(TABLE_TWEETS)
let REF_USER_TWEETS = DB_REF.child(TABLE_USER_TWEETS)
let REF_USER_FOLLOWERS = DB_REF.child(TABLE_FOLLOWERS)
let REF_USER_FOLLOWING = DB_REF.child(TABLE_FOLLOWING)


// Realtime Table Field
let DB_FIELD_USERNAME = "username"
let DB_FIELD_FULLNAME = "fullname"
let DB_FIELD_EMAIL = "email"
let DB_FIELD_PROFILE_IMAGE_URL = "profileImageUrl"

let DB_FILED_USER_ID = "uid"
let DB_FILED_TIMESTAMP = "timestamp"
let DB_FILED_LIKES = "likes"
let DB_FILED_RETWEETS = "retweets"
let DB_FILED_CAPTION = "caption"

