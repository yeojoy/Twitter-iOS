//
//  FeeViewController.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-09-27.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "TweetCell"

class FeedViewController: UICollectionViewController {

    // MARK: - Properties
    
    var user: TwitterUser? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycler
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: viewDidLoad()")
        configureUI()
        fetchTweets()
        configureNavibar()
        configureLeftBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func configureNavibar() {
        // Top center image
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
    }
    
    func configureLeftBarButton() {
        // Top left bar button
        guard let user = user else { return }
        guard let profileImageUrl = user.profileImageUrl else { return }
        
        let profileImageView = UIImageView()

        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.sd_setImage(with: profileImageUrl)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLeftBarButton))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
    }
    
    // MARK: - API
    func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets
        }
    }

    @objc func handleLeftBarButton() {
        guard let user = user else { return }
        let controller = ProfileViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegate / DataSource
extension FeedViewController {
    
    // number of total items
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    // asign item view
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.delegate = self
        cell.tweet = self.tweets[indexPath.row]
        return cell
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // This assigns fixed size. However we need dynamic height. 
        return CGSize(width: view.frame.width, height: 100)
    }
}


// MARK: - TweetCellDelegateProtocol
extension FeedViewController: TweetCellDelegate {
    func handleProfileImageTapped(cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        let controller = ProfileViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleCommentTapped(cell: TweetCell) {
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
}
