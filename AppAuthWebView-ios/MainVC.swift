//
//  ViewController.swift
//  AppAuthWebView-ios
//
//  Created by Hadi Dbouk on 10/5/17.
//  Copyright © 2017 Hadi Dbouk. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func onAuthorizeClicked(_ sender: Any) {
        performSegue(withIdentifier: "WebViewSegue", sender: nil)
    }
}

