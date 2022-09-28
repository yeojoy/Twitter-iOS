//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-09-27.
//

import UIKit

class MainTabController: UITabBarController {

    // MARK: - Properties
    
    // MARK: - Lifecycler
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewControllers()
    }
    
    // MARK: - Helpers
    func configureViewControllers() {
        let feed = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: FeedViewController())
        let explore = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: ExploreViewController())
        let noti = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: NotificationViewController())
        let conversation = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: ConversationViewController())
        
        viewControllers = [ feed, explore, noti, conversation ]
    }

    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
}
