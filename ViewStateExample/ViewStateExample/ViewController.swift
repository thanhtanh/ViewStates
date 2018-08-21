//
//  ViewController.swift
//  ViewStateExample
//
//  Created by Thanh Tanh on 8/20/18.
//  Copyright © 2018 Thanh Tanh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let viewState = ViewState()
    
    var viewStateType: ViewStateType = .success
    var loadingMessage = ""
    var loadingImageAssetName: String?
    var errorImage: UIImage?
    var noDataImage: UIImage?
    
    private let best = [
        "TÌNH ĐƠN PHƯƠNG ACOUSTIC COVER - Edward Duong Nguyen Ft Tùng Acoustic",
        "Mưa Trên Cuộc Tình | Edward Dương Nguyễn | Acoustic Cover",
        "https://www.youtube.com/watch?v=-4QBZmgXGRk"
    ]
    
    private var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        viewState.parentView = tableView
        loadData()
    }

    func loadData() {
        viewState.showLoadingState(loadingMessage: loadingMessage, loadingGifName: loadingImageAssetName)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            switch self.viewStateType {
            case .success:
                self.viewState.hideViewState()
                self.data = self.best
                self.tableView.reloadData()
            case .noData:
                self.viewState.showNoDataState("There is nothing to display", noDataImage: self.noDataImage, actionButtonTitle: "CREATE ONE", actionHandler: {
                    // create one
                })
            case .error:
                self.viewState.showErrorState("Oops! Something went wrong...", errorImage: self.errorImage, actionButtonTitle: "RETRY", actionHandler: {
                    self.loadData()
                })
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

enum ViewStateType {
    case noData
    case error
    case success
}
