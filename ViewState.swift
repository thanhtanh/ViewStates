//
//  ViewState.swift
//
//  Created by t4nhpt on 20th Aug 2018.
//  Copyright © 2018 t4nhpt. All rights reserved.
//

import UIKit

enum ViewStateOptions : UInt {
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

class ViewStateView: UIView {
    lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
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
        
        self.addSubview(messageLabel)
        self.addSubview(actionButton)
        self.addSubview(stateImageView)
        self.addSubview(loadingIndicatorView)
        parentView.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -20),
            self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: -100),
            
            stateImageView.topAnchor.constraint(equalTo: self.topAnchor),
            stateImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stateImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            stateImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            
            messageLabel.topAnchor.constraint(equalTo: stateImageView.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            loadingIndicatorView.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            loadingIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicatorView.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicatorView.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            actionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
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
        
        switch(state) {
        case .errorState:
            messageLabel.text = errorMessage
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
            hideAll()
            
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
