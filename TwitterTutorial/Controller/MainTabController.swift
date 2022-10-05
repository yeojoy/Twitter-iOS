//
//  MainTabController.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-09-27.
//

import UIKit
import FirebaseAuth

class MainTabController: UITabBarController {

    // MARK: - Properties
    
    var user: TwitterUser? {
        didSet {
            // ****** It's important ******
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedViewController else { return }
            
            feed.user = user
        }
    }
    
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
        view.backgroundColor = .twitterBlue
        authenticateUserAndCongifureUI()
    }
    
    
    
    // MARK: - API
    
    func fetchUser() {
        UserService.shared.fetchUser { twitterUser in
            self.user = twitterUser
        }
    }
    
    func authenticateUserAndCongifureUI() {
        if Auth.auth().currentUser == nil {
            // Need to sign in or sign up
            print("DEBUG: No user")
            moveToLoginScreen()
        } else {
            // user was signed in.
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
        
        moveToLoginScreen()
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
    
    func moveToLoginScreen() {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LoginViewController())
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    // MARK: - Selectors
    @objc func actionButtonTapped() {
        guard let user = user else { return }
        let nav = UINavigationController(rootViewController: UploadTweetViewController(user: user))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
        
//        logUserOut()
    }
}
