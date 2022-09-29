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
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "mail")
        let tf = UITextField()
        tf.placeholder = "Email"
        let view = Utilities.inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities.inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utilities.textField(withPlaceholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Utilities.textField(withPlaceholder: "Password")
        tf.keyboardType = .twitter
        tf.isSecureTextEntry = true
        return tf
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
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView])
        stackView.axis = .vertical
        stackView.spacing = 8
        view.addSubview(stackView)
        stackView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
    }
    
    // MARK: - Selecters
    
}
