//
//  ViewController.swift
//  Tutor+
//
//  Created by MacOS-1.14 on 10/15/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        // GIDSignIn.sharedInstance().signIn()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }
    
}
