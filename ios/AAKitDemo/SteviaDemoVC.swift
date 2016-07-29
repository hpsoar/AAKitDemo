//
//  SteviaDemoVC.swift
//  AAKitDemo
//
//  Created by HuangPeng on 7/29/16.
//  Copyright © 2016 Beacon. All rights reserved.
//

import UIKit

class SteviaDemoVC: UIViewController {
    override func loadView() { view = LoginViewStevia() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Here we want to reload the view after injection
        // this is only needed for live reload
        on("INJECTION_BUNDLE_NOTIFICATION") {
            self.view = LoginViewStevia()
        }
    }
}
