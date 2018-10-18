//
//  MessageDisplay.swift
//  Tutor+
//
//  Created by jzhao33 on 10/18/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class AlertHelper {
    static func showAlert(fromController controller: UIViewController, message: String, buttonTitle: String) {
        
        let alert = UIAlertController(title: ProdcutName, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}
