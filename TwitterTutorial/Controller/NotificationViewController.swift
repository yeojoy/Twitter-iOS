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
    
    private var notifictaions = [Notification]() {
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
            self.notifictaions = notifications
        }
    }
    
}

// MARK: - UITableViewDatasource
extension NotificationViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifictaions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdendifier, for: indexPath) as! NotificationCell
        cell.notification = notifictaions[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotificationViewController {
    
}
