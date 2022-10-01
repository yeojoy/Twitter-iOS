//
//  LoginViewController.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-09-28.
//

import UIKit
import FirebaseAuth

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
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities.attributedButton("Don't have an account? ", "Sign up")
        return button
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
        
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, height: 50)
        dontHaveAccountButton.addTarget(self, action: #selector(handleDontHaveAccount), for: .touchUpInside)
    }
    
    // MARK: - Selecters
        
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        AuthService.shared.logUserIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Error is \(error.localizedDescription)")
                return
            }
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tabController = window.rootViewController as? MainTabController else { return }
            tabController.authenticateUserAndCongifureUI()
            
            print("DEBUG: successful login in")
            // Move back to MainTabViewController.
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleDontHaveAccount() {
        print("Handle don't have account button")
        let controller = RegistrationViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
