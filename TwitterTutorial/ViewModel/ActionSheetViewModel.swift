//
//  ActionSheetViewModel.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-11-05.
//

import Foundation

struct ActionSheetViewModel {
    
    private let user: TwitterUser
    
    var options: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
            results.append(.report)
        }
        return results
    }
    
    init(user: TwitterUser) {
        self.user = user
    }
}

enum ActionSheetOptions {
    case follow(TwitterUser)
    case unfollow(TwitterUser)
    case report
    case delete
    
    var description: String {
        switch self {
            case .follow(let user): return "Follow @\(user.username)"
            case .unfollow(let user): return "Unfollow @\(user.username)"
            case .report: return "Report Tweet"
            case .delete: return "Delete Tweet"
        }
    }
}
