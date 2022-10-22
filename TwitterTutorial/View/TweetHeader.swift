//
//  TweetHeader.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-10-21.
//

import UIKit

private let PROFILE_IMAGE_SIZE = CGFloat(48)

protocol TweetHeaderDelegate: AnyObject {
    func onProfileImageTapped(_ header: TweetHeader)
}

class TweetHeader: UICollectionReusableView {
    
    // MARK: - Properties
    var tweet: Tweet? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: TweetHeaderDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: PROFILE_IMAGE_SIZE, height: PROFILE_IMAGE_SIZE)
        iv.layer.cornerRadius = PROFILE_IMAGE_SIZE / 2
        iv.backgroundColor = .twitterBlue
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Hello"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "@yeojoy"
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "Hello world!"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "6:33 PM - Oct 26, 2022"
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        return button
    }()
    
    private lazy var retweetLabel = UILabel()
    
    private lazy var likesLabel = UILabel()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        let stack = UIStackView(arrangedSubviews: [retweetLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(top: divider1.bottomAnchor, left: view.leftAnchor, paddingTop: 4, paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 4, paddingLeft: 8, height: 1.0)
        
        return view
    }()
    
    private lazy var commentButton: UIButton = {
        let button = createButton(withImageName: "comment")
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = createButton(withImageName: "retweet")
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImageName: "like")
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = createButton(withImageName: "share")
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
           
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        stack.axis = .horizontal // Default is horizontal. It's ok to remove this line
        stack.spacing = 12
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 16)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: stack)
        optionsButton.anchor(right: rightAnchor, paddingRight: 8, width: 42, height: 42)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.axis = .horizontal
        actionStack.distribution = .fillEqually
        addSubview(actionStack)
        actionStack.anchor(top: statsView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16)
        
        // assign event
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
        
        optionsButton.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selector
    @objc private func handleProfileImageTapped() {
        print("DEBUG: Go to user profile")
    }
    
    @objc private func showActionSheet() {
        print("DEBUG: Handle show action sheet.")
    }
    
    @objc private func handleCommentTapped() {
        print("DEBUG: handleCommentTapped")
    }
    
    @objc private func handleRetweetTapped() {
        print("DEBUG: handleRetweetTapped")
    }
    
    @objc private func handleLikeTapped() {
        print("DEBUG: handleLikeTapped")
    }
    
    @objc private func handleShareTapped() {
        print("DEBUG: handleShareTapped")
    }
    
    // MARK: - Helpers
    func configure() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        fullnameLabel.text = tweet.user.fullname
        usernameLabel.text = viewModel.usernameText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        dateLabel.text = viewModel.headerTimestamp
        retweetLabel.attributedText = viewModel.retweetsAttributedString
        likesLabel.attributedText = viewModel.likesAttributedString
    }
    
    func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
}
