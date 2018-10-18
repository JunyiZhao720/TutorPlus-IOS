//
//  SignUpViewController.swift
//  Tutor+
//
//  Created by jzhao33 on 10/17/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func SignUpButtonOnClicked(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                // ...
                guard let user = authResult?.user else {
                    debugHelpPrint(type: ClassType.SignUpViewController, str: error.debugDescription)
                    return
                }
            }
        }
        
    }
}
