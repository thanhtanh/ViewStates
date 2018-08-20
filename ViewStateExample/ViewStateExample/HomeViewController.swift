//
//  HomeViewController.swift
//  ViewStateExample
//
//  Created by Thanh Tanh on 8/20/18.
//  Copyright © 2018 Thanh Tanh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var loadingTextSwitch: UISwitch!
    @IBOutlet weak var loadingImageSwitch: UISwitch!
    @IBOutlet weak var noDataImageSwitch: UISwitch!
    @IBOutlet weak var errorImageSwitch: UISwitch!
    @IBOutlet weak var customThemingSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showNoData() {
        openLoadingPage(withType: .noData)
    }
    
    @IBAction func showSuccess() {
        openLoadingPage(withType: .success)
    }
    
    @IBAction func showError() {
        openLoadingPage(withType: .error)
    }
    
    func openLoadingPage(withType type: ViewStateType) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            vc.viewStateType = type
            vc.loadingMessage = loadingTextSwitch.isOn ? "Loading..." : ""
            vc.loadingImageAssetName = loadingImageSwitch.isOn ? "loading" : nil
            vc.noDataImage = noDataImageSwitch.isOn ? UIImage(named: "no_data") : nil
            vc.errorImage = errorImageSwitch.isOn ? UIImage(named: "error") : nil
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
