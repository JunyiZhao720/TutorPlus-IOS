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
    var userProvider: String? = ""
    
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
                        //ViewSwitch.moveToSearchPage()
                    } else {
                        
                    }
                }
            }
            else{
                
                self.userProvider = user!.providerData[0].providerID
            
                debugHelpPrint(type:ClassType.FirebaseUser,str:"Logged in")
                
                self.currentUser = user
                self.userId = (user?.uid)
                // LOAD DATA HERE
                
                DispatchQueue.main.asyncAfter(deadline: .now()){
                    // Do something if logged in
                    
                    
                    // Other login methods
                    //ViewSwitch.moveToSearchPage()
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
    
    func checkEmailVerified()->Bool{
        // Check if it is email login and check if it is verified
        if self.userProvider == ProviderType.password.description{
            if !self.currentUser!.isEmailVerified{
                // the email has not been verified!
                debugHelpPrint(type: ClassType.FirebaseUser, str: "Email is not verified!", id: self.userId)
                return false
            }
        }
        return true
    }
    
    func isLoggedIn() -> Bool {
        return(currentUser != nil)
    }
    
    func logOut(){
        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance()?.signOut()
    }
}
