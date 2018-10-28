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
    private let trans = FirebaseTrans.shared
    
    //var image: UIImage!
    var name: String? = ""
    var email: String? = ""
    var gender: String? = ""
    var major: String? = ""
    var university: String? = ""
    
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
                self.currentUser = user
                self.userId = (user?.uid)
                
                debugHelpPrint(type:ClassType.FirebaseUser,str:"Logged in", id: self.userId)
                // LOAD DATA HERE
                
                DispatchQueue.main.asyncAfter(deadline: .now()){
                    // Do something if logged in
                    if self.checkEmailVerified(){
                        ViewSwitch.moveToSearchPage()
                    }
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
    
    private func makeDict()->[String: Any]{
        let dictionary: [String: Any] = [
            // use as Any to avoid warning
            "name" :self.name as Any,
            "email" : self.email as Any,
            "gender" : self.gender as Any,
            "major" : self.major as Any,
            "university" : self.university as Any
        ]
        return dictionary
    }
    
//    private func makeInitialDict()->[String: Any]{
//        let dictionary: [String: Any] = [
//            // use as Any to avoid warning
//            "name" :"",
//            "email" : "",
//            "gender" : "",
//            "major" : "",
//            "university" : ""
//        ]
//        return dictionary
//    }

    // Create an intial empty doc for the user
//    func createDoc(){
//        if isLoggedIn(){
//            trans.createDoc(collection: trans.USER_COLLECTIONS, id: self.userId!, dict: self.makeInitialDict())
//        }else{
//            debugHelpPrint(type: ClassType.FirebaseUser, str: "Trying to createDoc() while user is not logged in")
//        }
//    }
    
    // Create or Override an existing doc
    func uploadDoc(){
        if isLoggedIn(){
            trans.createDoc(collection: trans.USER_COLLECTION, id: self.userId ?? "", dict: self.makeDict())
        }else{
            debugHelpPrint(type: ClassType.FirebaseUser, str: "Trying to uploadDoc() while user is not logged in")
        }
    }
    
    // Download an existing doc
    func downloadDoc(completion:@escaping(Bool)->Void){
        if isLoggedIn(){
            trans.downloadDoc(collection: trans.USER_COLLECTION, id: self.userId ?? "", completion: {(data) in
                if let data=data{
                    self.name = data["name"] as? String
                    self.email = data["email"] as? String
                    self.gender = data["gender"] as? String
                    self.major = data["major"] as? String
                    self.university = data["university"] as? String
                    
                    completion(true)
                }else{
                    debugHelpPrint(type: ClassType.FirebaseUser, str: "Trying to download document with errors!", id:self.userId)
                    completion(false)
                }
            })
        }
    }
    
    // doSeardh
    
    func doSearch(word:String, completion:@escaping(Dictionary<String, Any>?)->Void){
        // 
    }
}
