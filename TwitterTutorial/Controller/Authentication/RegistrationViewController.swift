//
//  RegistrationViewController.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-09-28.
//

import UIKit

class RegistrationViewController: UIViewController {

    // MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        return button
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
    
    private lazy var fullNameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities.inputContainerView(withImage: image, textField: fullNameTextField)
        return view
    }()
    
    private lazy var usernameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities.inputContainerView(withImage: image, textField: usernameTextField)
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
    
    private let fullNameTextField: UITextField = {
        let tf = Utilities.textField(withPlaceholder: "Full name")
        tf.keyboardType = .default
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        let tf = Utilities.textField(withPlaceholder: "Username")
        tf.keyboardType = .default
        return tf
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities.attributedButton("Already have an account? ", "Log in")
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
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 24)
        plusPhotoButton.setDimensions(width: 128, height: 128)
        plusPhotoButton.addTarget(self, action: #selector(handlePlusPhotoButton), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullNameContainerView, usernameContainerView, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        signUpButton.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, height: 50)
        alreadyHaveAccountButton.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
    }
    
    // MARK: - Selecters

    @objc func handlePlusPhotoButton() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleRegistration() {
        print("Handle Sign up")
    }
    
    @objc func handleAlreadyHaveAccount() {
        print("Handle already have an account button")
        navigationController?.popViewController(animated: true)
    }
}

extension RegistrationViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // an image comes from photo app
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        let image = profileImage.withRenderingMode(.alwaysOriginal)
        self.plusPhotoButton.layer.cornerRadius = 128 / 2
        self.plusPhotoButton.layer.masksToBounds = true
        self.plusPhotoButton.imageView?.contentMode = .scaleAspectFit
        self.plusPhotoButton.imageView?.clipsToBounds = true
        self.plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        self.plusPhotoButton.layer.borderWidth = 3
        
        self.plusPhotoButton.setImage(image , for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}
