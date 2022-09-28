//
//  ExploreViewController.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-09-27.
//

import UIKit

class ExploreViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Lifecycler
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Helpers

    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
    }
}
