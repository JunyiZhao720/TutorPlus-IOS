//
//  FirebaseUser.swift
//  Tutor+
//
//  Created by jzhao33 on 10/16/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUser{
    
    static let shared = FirebaseUser()
    
    var currentUser: User?
    var userId: String? = ""
    
    private var listenHandler: AuthStateDidChangeListenerHandle?
    
    private init(){}
    
    func addUserListener(loggedIn: Bool){
        print("Add listener")
        listenHandler = Auth.auth().addStateDidChangeListener{(auth,user) in
            if user == nil{
                // This means we are logged out
                print("Logged Out")
                self.currentUser = nil
                self.userId = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if loggedIn{
                        
                    } else {
                        
                    }
                }
            }
            else{
                print("Logged In")
                
                self.currentUser = user
                self.userId = (user?.uid)
                // LOAD DATA HERE
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    // Do something if logged in
                }
            }
        }
    }
}
