//
//  FeeViewController.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-09-27.
//

import UIKit

class FeedViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Lifecycler
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

}
