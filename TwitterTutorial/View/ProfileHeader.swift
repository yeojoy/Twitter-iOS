//
//  ProfileHeader.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-10-11.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func handleBackButton()
    
    func handleEditProfileButton()
    func handleFollowButton()
    
    func onFollowingTapped()
    func onFollowersTapped()
}

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    weak var delegate: ProfileHeaderDelegate?
    
    var user: TwitterUser? {
        didSet {
            bindUserData()
        }
    }
    
    private let filterBar = ProfileFilterView()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Yeojong Kim"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.text = "@kirby"
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkGray
        label.numberOfLines = 3
        label.text = "This is a user bio that will span more than one line for test purpose. This user is a best developer in the world and he's working in LiveBarn now. He is an android app developer."
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // MARK: - Lifecycler
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor, paddingTop: -24, paddingLeft: 8)
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12, width: 100, height: 40)
//        editProfileFollowButton.setDimensions(width: 100, height: 40)
        editProfileFollowButton.layer.cornerRadius = 40 / 2
        
//        addSubview(fullnameLabel)
//        fullnameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
//
//        addSubview(usernameLabel)
//        usernameLabel.anchor(top: fullnameLabel.bottomAnchor, left: fullnameLabel.leftAnchor, paddingTop: 8)
//
//        addSubview(bioLabel)
//        bioLabel.anchor(top: usernameLabel.bottomAnchor, left: usernameLabel.leftAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 12)
        
        let userDetailStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel, bioLabel])
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 6
        addSubview(userDetailStack)
        userDetailStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingRight: 12)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 2)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        addSubview(followStack)
        followStack.anchor(top: userDetailStack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12, height: 30)
        
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        
        followingLabel.addGestureRecognizer(followingTap)
        followersLabel.addGestureRecognizer(followersTap)
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        editProfileFollowButton.addTarget(self, action: #selector(handleEditProfileFollowButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func bindUserData() {
        guard let user = self.user else { return }
        let viewModel = ProfileHeaderViewModel(user: user)
        fullnameLabel.text = viewModel.fullnameString
        usernameLabel.text = viewModel.usernameString
        
        followersLabel.attributedText = viewModel.followersString
        followingLabel.attributedText = viewModel.followingString
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        
        profileImageView.sd_setImage(with: viewModel.userProfileImageUrl)
    }
    
    // MARK: - Selectors
    @objc func handleBackButton() {
        delegate?.handleBackButton()
    }
    
    @objc func handleEditProfileFollowButton() {
        // TODO: divide edit profile, follow, and following
        print("DEBUG: handleEditProfileFollowButton()")
    }
    
    @objc func handleFollowingTapped() {
        delegate?.onFollowingTapped()
    }
    
    @objc func handleFollowersTapped() {
        delegate?.onFollowersTapped()
    }
}

// MARK: - PRofileFilterViewDelegate
extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else { return }
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
}
