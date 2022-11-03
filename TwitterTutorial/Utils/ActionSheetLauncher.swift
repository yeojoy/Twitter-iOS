//
//  ActionSheetLauncher.swift
//  TwitterTutorial
//
//  Created by Yeojong Kim on 2022-11-03.
//

import UIKit

private let reuseIdentifier = "ActionSheetCell"
private let footerIdentifier = "ActionSheetFooter"

protocol ActionSheetLauncherDelegate: AnyObject {
    func didSelect(option: ActionSheetOptions)
}

class ActionSheetLauncher: NSObject {

    // MARK: - Properties

    private let user: TwitterUser
    private let tableView = UITableView()
    private var window: UIWindow?
    
    private lazy var viewModel = ActionSheetViewModel(user: user)
    private lazy var actionSheetHeight = CGFloat(viewModel.options.count * 60) + 100
    
    weak var delegate: ActionSheetLauncherDelegate?
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 1
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tab = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tab)
        // view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12)
        cancelButton.centerY(inView: view)
        cancelButton.layer.cornerRadius = 50 / 2
        
        return view
    }()
    
    // MARK: - Lifecycler
    
    init(user: TwitterUser) {
        self.user = user
        super.init()
        
        configureTableView()
    }
    
    // MARK: - Helpers
    func show() {
        // tricky??
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first(where: { $0.isKeyWindow}) else { return }
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: actionSheetHeight)
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.tableView.frame.origin.y -= self.actionSheetHeight
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: reuseIdentifier)
//        tableView.register(footerView, forHeaderFooterViewReuseIdentifier: footerIdentifier)
    }
    
    // MARK: - Selectors
    @objc private func handleDismissal() {
        hideActionSheet(completion: nil)
    }
    
    func hideActionSheet(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += self.actionSheetHeight
            completion?()
        }
    }
}

// MARK: - UITableViewDataSource
extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.options[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ActionSheetLauncher: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    // Set footerview height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        self.hideActionSheet() {
            self.delegate?.didSelect(option: option)
        }
    }
}
