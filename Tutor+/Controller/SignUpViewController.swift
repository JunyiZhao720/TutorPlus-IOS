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
            // start to create a user
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in

                guard (authResult?.user) != nil else {
                    debugHelpPrint(type: ClassType.SignUpViewController, str: error.debugDescription)
                    AlertHelper.showAlert(fromController: self, message: error.debugDescription, buttonTitle: "OK")
                    
                    return
                }
                
                // Sign up in datastore
                //FirebaseTrans.shared.createDoc(collection: "need to change", id: (Auth.auth().currentUser?.uid)!)
                
                // Send email verification
                Auth.auth().currentUser?.sendEmailVerification { (error) in

                    if error != nil{
                        debugHelpPrint(type: ClassType.FirebaseUser, str: error.debugDescription)
                        AlertHelper.showAlert(fromController: self, message: error.debugDescription, buttonTitle: "OK")
                    
                    }else{
                        // logout before doing anything
                        FirebaseUser.shared.logOut()
                        
                        // switch back to login
                        self.performSegue(withIdentifier: "SignUpToSignIn", sender: self)
                    
                    }
                    
                    return
                }
                
                
            }
        }
        
    }
}
