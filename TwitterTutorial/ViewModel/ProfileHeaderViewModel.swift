//
//  ProfileHeaderViewModel.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-10-13.
//

import UIKit


enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var displayName: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: TwitterUser
    
    var followersString: NSAttributedString? {
        return attributedText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: "following")
    }
    
    var usernameString: String {
        return "@\(user.username)"
    }
    
    var fullnameString: String {
        return user.fullname
    }
    
    var userProfileImageUrl: URL? { return user.profileImageUrl }
    
    var actionButtonTitle: String {
        // if user is current user then set to edit profile
        // else figure out following/follow
        
        if user.isCurrentUser {
            return "Edit Profile"
        } else {
            if user.isFollowed {
                return "Following"
            } else {
                return "Follow"
            }
        }
    }
    
    init(user: TwitterUser) {
        self.user = user
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
