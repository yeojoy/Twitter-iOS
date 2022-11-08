//
//  ProfileViewController.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-10-11.
//

import UIKit

private let reuseIdentifier = "ProfileView"
private let headerIdentifier = "Header"

class ProfileViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var user: TwitterUser
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    init(user: TwitterUser) {
        self.user = user
        // If we need to use custom parameter, first we have to call super.init with UICollectionViewFlowLayout
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Change status bar text color for example, time
        navigationController?.navigationBar.barStyle = .black
        // Hide default navigation bar
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchTweets()
        checkIfUserIsFollowed()
        fetchUserStats()
    }
    
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweetsByUser(forUser: user) { tweets in
            self.tweets = tweets
        }
    }
    
    func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // This assigns fixed size. However we need dynamic height.
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Need to change height with contents
        return CGSize(width: view.frame.width, height: 380)
    }
    
}

// MARK: - UICollectionViewDelegate
extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
}


// MARK: - ProfileHeaderDelegateProtocol
extension ProfileViewController: ProfileHeaderDelegate {
    func handleBackButton() {
        print("DEBUG: click BackButton")
        navigationController?.popViewController(animated: true)
    }
    
    func handleEditProfileButton(_ profileHeader: ProfileHeader) {
        
    }
    
    func handleFollowButton(_ profileHeader: ProfileHeader) {
        guard let user = profileHeader.user else { return }
        
        if (user.isCurrentUser) { return }
            
        let uid = user.uid
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: uid) { err, ref in
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            UserService.shared.followUser(uid: uid) { err, ref in
                self.user.isFollowed = true
                self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotification(type: .follow, user: user)
            }
        }
    }
}

// MARK: - TweetCellDelegateProtocol
extension ProfileViewController: TweetCellDelegate {
    func handleProfileImageTapped(cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        let controller = ProfileViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleReplyTapped(cell: TweetCell) {
        guard let username = cell.tweet?.user.username else { return }
        print("DEBUG: - handleCommentTapped() \(username)")
    }
    
    func handleRetweetTapped(cell: TweetCell) {
        guard let username = cell.tweet?.user.username else { return }
        print("DEBUG: - handleRetweetTapped() \(username)")
    }
    
    func handleLikeTapped(cell: TweetCell) {
        guard let username = cell.tweet?.user.username else { return }
        print("DEBUG: - handleLikeTapped() \(username)")
    }
    
    func handleShareTapped(cell: TweetCell) {
        guard let username = cell.tweet?.user.username else { return }
        print("DEBUG: - handleShareTapped() \(username)")
    }
    
    func onFollowingTapped() {
        print("DEBUG: - onFollowingTapped")
    }
    
    func onFollowersTapped() {
        print("DEBUG: - onFollowersTapped")
    }
}
