//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-09-27.
//

import UIKit

class MainTabController: UITabBarController {

    // MARK: - Properties
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycler
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewControllers()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    func configureViewControllers() {
        let feed = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: FeedViewController())
        let explore = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: ExploreViewController())
        let noti = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: NotificationViewController())
        let conversation = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: ConversationViewController())
        
        viewControllers = [ feed, explore, noti, conversation ]
    }

    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
    
    // MARK: - Selectors
    @objc func actionButtonTapped() {
        print("123")
    }
}
