//
//  LoginViewController.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-09-28.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "TwitterLogo") // need to type "#imageLiteral("
        return iv
    }()
    
    // MARK: - Lifecycler
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .twitterBlue
        // It makes statusBar text color white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 12)
        logoImageView.setDimensions(width: 150, height: 150)
    }
    
    // MARK: - Selecters
    
}
