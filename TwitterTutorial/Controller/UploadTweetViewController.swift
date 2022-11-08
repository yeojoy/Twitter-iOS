//
//  UploadTweetViewController.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-10-05.
//

import UIKit

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

class UploadTweetViewController: UIViewController {
    
    // MARK: - Properties
    
    private let user: TwitterUser
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        return iv
    }()
    
    private lazy var replyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "replying to @spiderman"
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        label.textColor = .lightGray
        return label
    }()
    
    private let captionTextView = CaptionTextView()
    
    // MARK: - Lifecycler
    
    init(user: TwitterUser, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        switch config {
            case .tweet:
                print("DEBUG: Config is tweet")
            case .reply(let tweet):
                print("Debug: Config is tweet to \(tweet.caption)")
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 12
        // This is solution for assigning caption view's height
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        captionTextView.placeHolderLabel.text = viewModel.placeholderText
        replyLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
     
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
        actionButton.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
    }
    
    // MARK: - API
    
    // MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleUploadTweet() {
        guard let caption = captionTextView.text else { return }
        switch config {
            case .tweet:
                TweetService.shared.uploadTweet(caption: caption) { error, ref in
                    if let error = error {
                        print("DEBUG: Failed to upload tweet with error \(error.localizedDescription)")
                        return
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                }
            case .reply(let tweet):
                TweetService.shared.uploadReply(caption: caption, tweetId: tweet.tweetId) { error, ref in
                    if let error = error {
                        print("DEBUG: Failed to upload tweet with error \(error.localizedDescription)")
                        return
                    }
                    
                    if case .reply(_) = self.config {
                        NotificationService.shared.uploadNotification(type: .reply, tweet: tweet)
                    }
                    
                    self.dismiss(animated: true, completion: nil)
                }
        }
    }
}
