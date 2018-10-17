//
//  GlobalFunctions.swift
//  Tutor+
//
//  Created by jzhao33 on 10/16/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

func moeveToSearchPage(){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
//    appDelegate.window?.backgroundColor = UIColor.white
//    appDelegate.window?.makeKeyAndVisible()
//
//    let loginVC = SearchViewController()
//    let navController = UINavigationController(rootViewController: loginVC)

    //appDelegate.window?.rootViewController = navController
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    appDelegate.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController")
    
}
