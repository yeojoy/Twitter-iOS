//
//  TweetCell.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-10-08.
//

import UIKit

protocol TweetCellDelegate: AnyObject {
    func handleProfileImageTapped(cell: TweetCell)
    func handleReplyTapped(cell: TweetCell)
    func handleRetweetTapped(cell: TweetCell)
    func handleLikeTapped(cell: TweetCell)
    func handleShareTapped(cell: TweetCell)
}

class TweetCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var tweet: Tweet? {
        didSet {
            configureTweet()
        }
    }
    
    weak var delegate: TweetCellDelegate?
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 48 / 2
        return iv
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        // this determines the number of lines to draw and what to do when sizeToFit is called. default value is 1 (single line). A value of 0 means no limit
        label.numberOfLines = 0
        label.text = "Test caption"
        return label
    }()
    
    private let infoLabel = UILabel()
    
    private lazy var replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "share"), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleReplyTapped() {
        delegate?.handleReplyTapped(cell: self)
    }
    
    @objc func handleRetweetTapped() {
        delegate?.handleRetweetTapped(cell: self)
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(cell: self)
    }
    
    @objc func handleShareTapped() {
        delegate?.handleShareTapped(cell: self)
    }
    
    @objc func handleTapImageProfile() {
        delegate?.handleProfileImageTapped(cell: self)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .white
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        let stack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 4
        infoLabel.text = "Eddie Brock @venom"
        addSubview(stack)
        stack.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 16)
        
        lazy var underlineView = UIView()
        underlineView.backgroundColor = .systemGroupedBackground
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,  height: 1)
        
        let actionStack = UIStackView(arrangedSubviews: [replyButton, retweetButton, likeButton, shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom: bottomAnchor, paddingBottom: 8)
        
        replyButton.addTarget(self, action: #selector(handleReplyTapped), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapImageProfile))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
    }
    
    private func configureTweet() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        captionLabel.text = tweet.caption
        // TO assign attributedText, please use attributedText
        infoLabel.attributedText = viewModel.userInfoText
        
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
    }
}
