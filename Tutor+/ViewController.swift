//
//  ViewController.swift
//  Tutor+
//
//  Created by MacOS-1.14 on 10/10/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UITableViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }


}

