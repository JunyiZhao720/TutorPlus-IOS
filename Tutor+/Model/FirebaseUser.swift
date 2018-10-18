//
//  FirebaseUser.swift
//  Tutor+
//
//  Created by jzhao33 on 10/16/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

class FirebaseUser{
    
    static let shared = FirebaseUser()
    
    var currentUser: User?
    var userId: String? = ""
    
    private var listenHandler: AuthStateDidChangeListenerHandle?
    
    private init(){}
    
    func addUserListener(loggedIn: Bool){
        debugHelpPrint(type: ClassType.AppDelegate, str: "Add listener")
        listenHandler = Auth.auth().addStateDidChangeListener{(auth,user) in
            if user == nil{
                // This means we are logged out
                debugHelpPrint(type:ClassType.FirebaseUser,str:"Logged Out")
                self.currentUser = nil
                self.userId = ""
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    if loggedIn{
                        ViewSwitch.moveToSearchPage()
                    } else {
                        
                    }
                }
            }
            else{
                let provider = user!.providerData[0].providerID
                
                debugHelpPrint(type:ClassType.FirebaseUser,str:"Logged in by \(String(describing: provider))")
                
                self.currentUser = user
                self.userId = (user?.uid)
                // LOAD DATA HERE
            
                
                DispatchQueue.main.asyncAfter(deadline: .now()){
                    // Do something if logged in
                    
                    // Check if it is email login and check if it is verified
                    if provider == ProviderType.password.description{
                        if !user!.isEmailVerified{
                            // do something to indicate the email has not been verified
                            debugHelpPrint(type: ClassType.FirebaseUser, str: "Email is not verified!")
                            self.logOut()
                            return
                        }
                    }
                    ViewSwitch.moveToSearchPage()
                }
            }
        }
    }
    
    func removeUserListener(){
        guard listenHandler != nil else{
            return
        }
        Auth.auth().removeStateDidChangeListener(listenHandler!)
    }
    
    func isLoggedIn() -> Bool {
        return(currentUser != nil)
    }
    
    func logOut(){
        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance()?.signOut()
    }
}
