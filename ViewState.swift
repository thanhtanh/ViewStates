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

class ViewState {
    private var stateView: ViewStateView!
    
    var parentView: UIView! {
        didSet {
            self.stateView = ViewStateView(parentView: parentView)
        }
    }
    
    func showLoadingState(loadingMessage: String = "", loadingGifName: String? = nil) {
        stateView.loadingMessage = loadingMessage
        stateView.loadingImageName = loadingGifName
        moveToState(.loadingState)
    }
    
    func showErrorState(_ errorMessage: String, errorImage: UIImage?) {
        stateView.errorMessage = errorMessage
        stateView.errorImage = errorImage
        moveToState(.errorState)
    }
    
    func showErrorState(_ errorMessage: String, errorImage: UIImage?, actionButtonTitle: String, actionHandler: @escaping (() -> Void)) {
        stateView.errorMessage = errorMessage
        stateView.errorImage = errorImage
        stateView.actionButtonTitle = actionButtonTitle
        stateView.actionHandler = actionHandler
        moveToState(.errorState)
    }
    
    func showNoDataState(_ noDataMessage:String, noDataImage: UIImage? = nil, actionButtonText: String?, actionHandler: (() -> Void)? = nil) {
        stateView.noDataMessage = noDataMessage
        stateView.noDataImage = noDataImage
        stateView.actionHandler = actionHandler
        moveToState(.noDataState)
    }
    
    func hideViewState() {
        moveToState(.initialState)
    }
    
    private func moveToState(_ state: ViewStateOptions) {
        stateView.changeUIToState(state)
    }
}

fileprivate class ViewStateView: UIView {
    lazy var borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var actionButton: UIButton = {
        let view = UIButton()
        view.setTitle("RETRY", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var stateImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        return view
    }()
    
    init(parentView: UIView) {
        self.parentView = parentView
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    let parentView: UIView
    var loadingMessage = ""
    var errorMessage = ""
    var noDataMessage = ""
    var errorImage: UIImage?
    var noDataImage: UIImage?
    var loadingImageName: String?
    var actionButtonTitle: String?
    var actionHandler: (() -> Void)?
    
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
