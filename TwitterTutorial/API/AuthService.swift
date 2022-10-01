//
//  AuthService.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-10-03.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let profileImage = credentials.profileImage
        let email = credentials.email
        let password = credentials.password
        let username = credentials.username
        let fullname = credentials.fullname
                
        // Compress profile image with jpeg
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        storageRef.putData(imageData) { (metaData, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG: Error is \(error.localizedDescription)")
                        return
                    }
                
                    
                    // TODO: add user data into Realtime database
                    
                    // uid coming from Firebase auth is unique id for each user
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["email": email, "username": username, "fullname": fullname, "profileImageUrl": profileImageUrl]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
