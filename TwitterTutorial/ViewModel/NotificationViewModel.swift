//
//  NotificationViewModel.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-11-08.
//

import UIKit

struct NotificationViewModel {
    private let notification: Notification
    private let type: NotificationType
    private let user: TwitterUser
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp, to: now) ?? "2m"
    }
    
    var notificationMesssage: String {
        switch type {
            case .follow: return " started following you."
            case .like: return " liked one of your tweet."
            case .reply: return " replied to your tweet."
            case .retweet: return " retweeted your tweet."
            case .mention: return " montioned you in a tweet"
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timestamp = timestampString else { return nil }
        let attributedText = NSMutableAttributedString(string: user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: notificationMesssage, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: " \(timestamp)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return attributedText
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
