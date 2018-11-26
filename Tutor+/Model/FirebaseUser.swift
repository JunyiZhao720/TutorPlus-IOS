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
    
    // ------------------------------------------------------------------------------------
    // Basic data model
    
    struct ProfileStruct{
        var name: String? = ""
        var email: String? = ""
        var gender: String? = ""
        var major: String? = ""
        var university: String? = ""
        var imageURL: String? = ""
        var tag: [String]? = []
        //var image
        
        init(){}
        init(name:String?, email:String?, gender:String?, major:String?, university:String?, imageURL:String?, tag:[String]?){
            self.name = name
            self.email = email
            self.gender = gender
            self.major = major
            self.university = university
            self.imageURL = imageURL
            self.tag = tag
        }
    }
    
    // ------------------------------------------------------------------------------------
    // FirebaseUser data fields
    
    static let shared = FirebaseUser()
    
    var currentUser: User?
    var userId: String? = ""
    var userProvider: String? = ""
    var data: ProfileStruct? = ProfileStruct()
    
    private var listenHandler: AuthStateDidChangeListenerHandle?
    private let trans = FirebaseTrans.shared
    
    

    //Profile Fields
    var name: String?{
        get{ return data?.name }
        set(value){ data?.name = value}
    }
    var email: String? {
        get{ return data?.email }
        set(value){ data?.email = value}
    }
    var gender: String? {
        get{ return data?.gender }
        set(value){ data?.gender = value}
    }
    var major: String? {
        get{ return data?.major }
        set(value){ data?.major = value}
    }
    var university: String? {
        get{ return data?.university }
        set(value){ data?.university = value}
    }
    var imageURL: String?{
        get{ return data?.imageURL}
        set(value){ data?.imageURL = value}
    }
    var tag: [String]?{
        get{ return data?.tag}
        set(value){ data?.tag = value}
    }
    
    //Extra fields
    var imageProfile: UIImage?
    
    private init(){}
    
    // ------------------------------------------------------------------------------------
    // Auth methods
    
    func addUserListener(loggedIn: Bool){
        debugHelpPrint(type: ClassType.AppDelegate, str: "Add listener")
        listenHandler = Auth.auth().addStateDidChangeListener{(auth,user) in
            if user == nil{
                // This means we are logged out
                debugHelpPrint(type:ClassType.FirebaseUser,str:"Logged Out")
                self.currentUser = nil
                self.userId = ""
                self.data = nil
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    if loggedIn{
                        //ViewSwitch.moveToSearchPage()
                    } else {
                        ViewSwitch.moveToLoginPage()
                    }
                }
            }else{
                
                self.userProvider = user!.providerData[0].providerID
                self.currentUser = user
                self.userId = (user?.uid)
                
                debugHelpPrint(type:ClassType.FirebaseUser,str:"Logged in", id: self.userId)
                
                self.downloadProfile(completion: {(success) in
                    // download image
                    self.downloadImage(completion: {
                        // move to tab page
                        DispatchQueue.main.asyncAfter(deadline: .now()){
                            if self.checkEmailVerified(){
                                //ViewSwitch.moveToTabPage()
                            }
                        }
                    })
                })
                
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
            "university" : self.university as Any,
            "imageURL" : self.imageURL as Any,
            "tag" : self.tag as Any
        ]
        return dictionary
    }
    
    // Parse data to UserStructure
    static func parseData(data:[String:Any?])->ProfileStruct{
        let back = ProfileStruct(
            name: data["name"] as? String,
            email: data["email"] as? String,
            gender: data["gender"] as? String,
            major: data["major"] as? String,
            university: data["university"] as? String,
            imageURL: data["imageURL"] as? String,
            tag: data["tag"] as? [String]
        )
        return back
    }
    
    // ------------------------------------------------------------------------------------
    // Profile methods
    
    // create or override an existing doc
    func uploadProfile(){
        if isLoggedIn(){
            trans.createDoc(collection: [FirebaseTrans.USER_COLLECTION], id: self.userId!, dict: self.makeDict())
        }else{
            debugHelpPrint(type: ClassType.FirebaseUser, str: "Trying to uploadDoc() while user is not logged in")
        }
    }
    
    // download an existing doc
    func downloadProfile(completion:@escaping(Bool)->Void){
        if isLoggedIn(){
            trans.downloadDoc(collection: FirebaseTrans.USER_COLLECTION, id: self.userId!, completion: {(data) in
                if let data=data{
                    // replace all current data with a brand new ProfileStruct
                    self.data = FirebaseUser.parseData(data: data)
                    completion(true)
                }else{
                    debugHelpPrint(type: ClassType.FirebaseUser, str: "Trying to download document with errors!", id:self.userId)
                    completion(false)
                }
            })
        }else{
            debugHelpPrint(type: ClassType.FirebaseUser, str: "Trying to downloadDoc() while user is not logged in")
        }
    }
    
    // ------------------------------------------------------------------------------------
    // FriendList methods
    
    private enum FriendState{
        case pending
        case accept
    }
    
    private func friendDictGenerator(state: FriendState)->[String: String]{
        switch state {
        case .pending:
            return ["state":"pending"]
        case .accept:
            return ["state":"accept"]
        }
    }
    
    func request(tutorId: String){
        if !isLoggedIn(){
            debugHelpPrint(type: .FirebaseUser, str: "request() not logged in")
        }
        //users->tutorId->student->new document
        var path = [String]()
        path.append(FirebaseTrans.USER_COLLECTION)
        path.append(tutorId)
        path.append(FirebaseTrans.STUDENT_COLLECTION)
        
        trans.createDoc(collection: path, id: self.userId!, dict: friendDictGenerator(state: .pending))
    }
    
    func reject(studentId: String){
        if !isLoggedIn(){
            debugHelpPrint(type: .FirebaseUser, str: "reject() not logged in")
        }
        //users->myId->student->delete
        var path = [String]()
        path.append(FirebaseTrans.USER_COLLECTION)
        path.append(userId!)
        path.append(FirebaseTrans.STUDENT_COLLECTION)
        
        trans.deleteDoc(collection: path, id: studentId)
    }
    
    func accept(studentId: String){
        if !isLoggedIn(){
            debugHelpPrint(type: .FirebaseUser, str: "accept() not logged in")
            return
        }
        // create a document under student's tutor collection
        var path = [String]()
        path.append(FirebaseTrans.USER_COLLECTION)
        path.append(studentId)
        path.append(FirebaseTrans.TUTOR_COLLECTION)
        
        trans.createDoc(collection: path, id: self.userId!, dict: friendDictGenerator(state: .accept))
        
        // change my document under student's to accept
        path.removeAll()
        path.append(FirebaseTrans.USER_COLLECTION)
        path.append(userId!)
        path.append(FirebaseTrans.STUDENT_COLLECTION)
        
        trans.createDoc(collection: path, id: studentId, dict: friendDictGenerator(state: .accept))
    }
    
    func addStudentListListener(){
        if !isLoggedIn(){
            debugHelpPrint(type: .FirebaseUser, str: "addStudentListListener() not logged in")
            return
        }
        
        var path = [String]()
        path.append(FirebaseTrans.USER_COLLECTION)
        path.append(self.userId!)
        path.append(FirebaseTrans.STUDENT_COLLECTION)
        
        FirebaseTrans.shared.addCollectionListener(collections: path)
    }
    
    // ------------------------------------------------------------------------------------
    // Image methods
    func uploadImage(data: Data,completion: @escaping (Bool) -> Void){
        if !isLoggedIn(){
            debugHelpPrint(type: .FirebaseUser, str: "uploadImage() not logged in")
            completion(false)
        }
        
        trans.uploadFile(folder: FirebaseTrans.IMAGE_FOLDER, id: userId!, fileExtension: FirebaseTrans.IMAGE_EXTENSION, data: data, completion: {(url) in
            if let url = url{
                debugHelpPrint(type: .FirebaseUser, str: "uploadImage(): url: \(url)")
                self.imageURL = url
                completion(true)
            }
        })

    }
    
    func downloadImage(completion: @escaping () -> Void){
        if !isLoggedIn(){
            debugHelpPrint(type: .FirebaseUser, str: "downloadImage(): not logged in")
            completion()
            return
        }
        if let url = imageURL{
            trans.downloadImageAndCache(url: url, completion: {(theUIImage) in
                self.imageProfile = theUIImage
                completion()
            })
        }else{
            debugHelpPrint(type: .FirebaseUser, str: "downloadImage(): \(self.userId!) doesn't have an uploaded image")
            completion()
        }
    }
}
