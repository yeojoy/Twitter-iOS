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
    
    private let forgotPasswordButton: UIButton = {
        let button = Utilities.attributedButton("Forgot your password? ", "Click here!")
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
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
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16, height: 48)
        forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, height: 50)
        dontHaveAccountButton.addTarget(self, action: #selector(handleDontHaveAccount), for: .touchUpInside)
        
        view.addSubview(label)
        label.anchor(left: view.leftAnchor, bottom: dontHaveAccountButton.topAnchor, right: view.rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
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
            
            // since iOS 16, need to use windowScene to get windows object.
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            // in the view stack, first one is MainTabController, and last is current ViewController,
            // This case LoginViewController is last.
            guard let window = windowScene?.windows.first(where: { $0.isKeyWindow }) else { return }
            
            guard let tabController = window.rootViewController as? MainTabController else { return }
            tabController.authenticateUserAndCongifureUI()
            
            // Move back to MainTabViewController.
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleForgotPassword() {
        // To use this, type email address. If possible, check email validation
        // Notify user to check email box. If there is no one, check spam mail box.
        // If changing was done, try to log in again with new password.
        guard let email = emailTextField.text else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("DEBUG: sendPasswordReset has occurred an error, \(error)")
                self.label.text = error.localizedDescription
                return
            }
            
            self.label.text = "Please check your email and then reset your password"
        }
        // TODO notify user to check a spam mail box to reset it. Then change it.
    }
    
    @objc func handleDontHaveAccount() {
        let controller = RegistrationViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
