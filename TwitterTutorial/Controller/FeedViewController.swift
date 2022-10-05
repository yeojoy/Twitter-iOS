//
//  FeeViewController.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-09-27.
//

import UIKit
import SDWebImage

class FeedViewController: UIViewController {

    // MARK: - Properties
    var user: TwitterUser? {
        didSet {
            guard let u = user else { return }
            print("DEBUG: FeedViewController User name is \(u.username)")
            configureLeftBarButton()
        }
    }
    
    
    // MARK: - Lifecycler
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = .white
        // Top center image
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
    }
    
    func configureLeftBarButton() {
        // Top left bar button
        guard let user = user else { return }
        guard let profileImageUrl = user.profileImageUrl else { return }
        
        let profileImageView = UIImageView()

        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.sd_setImage(with: profileImageUrl)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
