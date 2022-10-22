//
//  CaptionTextView.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-10-05.
//

import UIKit

class CaptionTextView: UITextView {
    
    // MARK: - Properties
    
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 18)
        isScrollEnabled = true
        // The bug is I set the height with 300, but it's not assigned like that.
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleTextInputChange() {
        print("DEBUG: Hide and show placeholder")
        placeHolderLabel.isHidden = !text.isEmpty
    }
}
