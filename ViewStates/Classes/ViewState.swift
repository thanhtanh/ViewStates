//
//  ViewState.swift
//
//  Created by t4nhpt on 20th Aug 2018.
//  Copyright © 2018 t4nhpt. All rights reserved.
//

import UIKit

fileprivate enum ViewStateOptions : UInt {
    case errorState
    case loadingState
    case noDataState
    case initialState
}

public class ViewState {
    private var stateView: ViewStateView!
    
    public var parentView: UIView! {
        didSet {
            self.stateView = ViewStateView(parentView: parentView, theme: ViewState.theme)
        }
    }
    
    private static var theme = ViewStateTheming()
    
    public init() {
        
    }
    
    public static func useCustomeTheme(_ customTheme: ViewStateTheming) {
        theme = customTheme
    }
    
    public func showLoadingState() {
        showLoadingState(loadingMessage: ViewState.theme.defaultLoadingMessage,
                         loadingGifName: ViewState.theme.defaultLoadingImageName)
    }
    
    public func showLoadingState(loadingMessage: String, loadingGifName: String? = nil) {
        stateView.loadingMessage = loadingMessage
        stateView.loadingImageName = loadingGifName
        moveToState(.loadingState)
    }
    
    public func showErrorState(_ errorMessage: String) {
        showErrorState(errorMessage, errorImage: ViewState.theme.defaultErrorImage)
    }
    
    public func showErrorState(_ errorMessage: String, errorImage: UIImage?) {
        stateView.errorMessage = errorMessage
        stateView.errorImage = errorImage
        moveToState(.errorState)
    }
    
    public func showErrorState(_ errorMessage: String, errorImage: UIImage? = nil, actionButtonTitle: String, actionHandler: @escaping (() -> Void)) {
        stateView.errorMessage = errorMessage
        stateView.errorImage = errorImage
        stateView.actionButtonTitle = actionButtonTitle
        stateView.actionHandler = actionHandler
        moveToState(.errorState)
    }
    
    public func showNoDataState(_ noDataMessage: String) {
        showNoDataState(noDataMessage, noDataImage: ViewState.theme.defaultNoDataImage, actionButtonTitle: nil, actionHandler: nil)
    }
    
    public func showNoDataState(_ noDataMessage: String, actionButtonTitle: String, actionHandler: @escaping (() -> Void)) {
        showNoDataState(noDataMessage, noDataImage: ViewState.theme.defaultNoDataImage, actionButtonTitle: actionButtonTitle, actionHandler: actionHandler)
    }
    
    public func showNoDataState(_ noDataMessage:String, noDataImage: UIImage? = nil, actionButtonTitle: String?, actionHandler: (() -> Void)?) {
        stateView.noDataMessage = noDataMessage
        stateView.noDataImage = noDataImage
        stateView.actionHandler = actionHandler
        stateView.actionButtonTitle = actionButtonTitle
        moveToState(.noDataState)
    }
    
    public func hideViewState() {
        moveToState(.initialState)
    }
    
    private func moveToState(_ state: ViewStateOptions) {
        stateView.changeUIToState(state)
    }
}

public class ViewStateTheming {
    // Background color of the ViewState view
    var backgroundColor = UIColor.white
    
    // The message label style
    var messageTextColor = UIColor.darkText
    var messageTextAlignment = NSTextAlignment.center
    var messageTextFont = UIFont.systemFont(ofSize: 15)
    
    // The action button style
    var actionButtonBackgroundColor = UIColor.white
    var actionButtonTitleColor = UIColor.blue
    var actionButtonFont = UIFont.boldSystemFont(ofSize: 15)
    var actionButtonInset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    var actionButtonCornerRadius: CGFloat = 5
    
    // If there is no GIF image, the iOS UIActivityIndicatorView will be used
    var defaultLoadingSpinnerColor = UIColor.gray
    
    // Default image and loading text. This can be set when changing state for a special view
    var defaultLoadingMessage = ""
    var defaultLoadingImageName: String?
    var defaultErrorImage: UIImage?
    var defaultNoDataImage: UIImage?
}

fileprivate class ViewStateView: UIView {
    lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.textColor = theme.messageTextColor
        view.textAlignment = theme.messageTextAlignment
        view.font = theme.messageTextFont
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var actionButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(theme.actionButtonTitleColor, for: .normal)
        view.titleLabel?.font = theme.actionButtonFont
        view.backgroundColor = theme.actionButtonBackgroundColor
        view.contentEdgeInsets = theme.actionButtonInset
        view.layer.cornerRadius = theme.actionButtonCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    lazy var stateImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = theme.defaultLoadingSpinnerColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        return view
    }()
    
    let parentView: UIView
    let theme: ViewStateTheming
    var loadingMessage = ""
    var errorMessage = ""
    var noDataMessage = ""
    var errorImage: UIImage?
    var noDataImage: UIImage?
    var loadingImageName: String?
    var actionButtonTitle: String?
    var actionHandler: (() -> Void)?
    
    init(parentView: UIView, theme: ViewStateTheming) {
        self.parentView = parentView
        self.theme = theme
        
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = theme.backgroundColor
        
        self.actionButton.addTarget(self, action: #selector(executeAction), for: .touchUpInside)
        
        borderView.addSubview(messageLabel)
        borderView.addSubview(actionButton)
        borderView.addSubview(stateImageView)
        borderView.addSubview(loadingIndicatorView)
        self.addSubview(borderView)
        parentView.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            self.topAnchor.constraint(equalTo: parentView.topAnchor),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
            
            borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            borderView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            borderView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100),
            
            
            stateImageView.topAnchor.constraint(equalTo: borderView.topAnchor),
            stateImageView.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            stateImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            stateImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            
            messageLabel.topAnchor.constraint(equalTo: stateImageView.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -16),
            
            loadingIndicatorView.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            loadingIndicatorView.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            loadingIndicatorView.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicatorView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            actionButton.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: borderView.bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func executeAction() {
        self.actionHandler?()
    }
    
    func changeUIToState(_ state: ViewStateOptions) {
        hideAll()
        self.isHidden = false
        
        switch(state) {
        case .errorState:
            messageLabel.text = errorMessage
            messageLabel.isHidden = false
            stateImageView.image = errorImage
            stateImageView.isHidden = false
            if actionHandler != nil {
                actionButton.setTitle(actionButtonTitle, for: .normal)
                actionButton.isHidden = false
            } else {
                actionButton.isHidden = true
            }
            
            if let scroll = parentView as? UIScrollView {
                scroll.isScrollEnabled = false
            }
        case .loadingState:
            messageLabel.text = self.loadingMessage
            messageLabel.isHidden = false
            if let loading = loadingImageName {
                stateImageView.loadGif(asset: loading)
                stateImageView.isHidden = false
                loadingIndicatorView.isHidden = true
                loadingIndicatorView.stopAnimating()
            } else {
                loadingIndicatorView.isHidden = false
                stateImageView.isHidden = true
            }
            
            if let table = parentView as? UITableView {
                table.isScrollEnabled = false
            }
        case .noDataState:
            messageLabel.text = self.noDataMessage
            messageLabel.isHidden = false
            stateImageView.image = noDataImage
            stateImageView.isHidden = false
            
            if actionHandler != nil {
                actionButton.setTitle(actionButtonTitle, for: .normal)
                actionButton.isHidden = false
            } else {
                actionButton.isHidden = true
            }
            
            if let table = parentView as? UITableView {
                table.isScrollEnabled = false
            }
        case .initialState:
            self.isHidden = true
            if let table = parentView as? UITableView {
                table.isScrollEnabled = true
            }
        }
    }
    
    private func hideAll() {
        messageLabel.isHidden = true
        actionButton.isHidden = true
        stateImageView.isHidden = true
        loadingIndicatorView.isHidden = true
    }
}
