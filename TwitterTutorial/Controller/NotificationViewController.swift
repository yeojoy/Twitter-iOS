//
//  NotificationViewController.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-09-27.
//

import UIKit

private let reuseIdendifier = "NotificationCell"

class NotificationViewController: UITableViewController {

    // MARK: - Properties
    
    private var notifications = [Notification]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycler
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    // MARK: - Helpers

    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifictaions"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdendifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
    // MARK: - API
    func fetchNotifications() {
        NotificationService.shared.fetchNotifications { notifications in
            self.notifications = notifications
        }
    }
    
}

// MARK: - UITableViewDatasource
extension NotificationViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdendifier, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noti = notifications[indexPath.row]
        guard let tweetId = noti.tweetId else { return }
        
        TweetService.shared.fetchTweet(withTweetId: tweetId) { tweet in
            let controller = TweetViewController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - NotificationCellDelegate
extension NotificationViewController: NotificationCellDelegate {
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        let controller = ProfileViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
