//
//  GlobalFunctions.swift
//  Tutor+
//
//  Created by jzhao33 on 10/16/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

func moveToSearchPage(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    appDelegate.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController")
}

func moveToLoginPage(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    appDelegate.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
}
