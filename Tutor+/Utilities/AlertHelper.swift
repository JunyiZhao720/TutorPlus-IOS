//
//  MessageDisplay.swift
//  Tutor+
//
//  Created by jzhao33 on 10/18/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class AlertHelper {
    static func showAlert(message: String, buttonTitle: String) {
        

        
        let appDelegate = UIApplication.shared.inputViewController//UIApplication.shared.delegate as! AppDelegate
        let alert = UIAlertController(title: ProdcutName, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: nil))
        appDelegate?.present(alert, animated: true, completion: nil)//.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
