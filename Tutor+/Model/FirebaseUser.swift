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

protocol listenerUpdateProtocol: class {
    func contentUpdate()
}

class FirebaseUser{
    
    // ------------------------------------------------------------------------------------
    // Basic data model
    
    struct ProfileStruct{
        var id: String? = ""
        var name: String? = ""
        var gender: String? = ""
        var major: String? = ""
        var university: String? = ""
        var imageURL: String? = ""
        var tag: [String]? = []
        var schedule: String? = ""
        var ps: String? = ""
        var count: Int? = 0
        var image: UIImage?
        
        init(){}
        init(id: String?, name:String?, gender:String?, major:String?, university:String?, imageURL:String?, tag:[String]?, schedule: String?, ps: String?, count: Int?){
            self.id = id
            self.name = name
            self.gender = gender
            self.major = major
            self.university = university
            self.imageURL = imageURL
            self.tag = tag
            self.schedule = schedule
            self.ps = ps
            self.count = count
        }
        func toDict()->[String:Any]{
            let dictionary: [String: Any] = [
                // use as Any to avoid warning
                "id" : self.id as Any,
                "name" :self.name as Any,
                "gender" : self.gender as Any,
                "major" : self.major as Any,
                "university" : self.university as Any,
                "imageURL" : self.imageURL as Any,
                "tag" : self.tag as Any,
                "schedule" : self.schedule as Any,
                "ps" : self.ps as Any,
                "count" : self.count as Any
            ]
            return dictionary
        }
    }
    
    // ------------------------------------------------------------------------------------
    // FirebaseUser data fields
    
    static let shared = FirebaseUser()
    
    var currentUser: User?

    var userProvider: String? = ""
    var data: ProfileStruct = ProfileStruct()
    
    private var listenHandler: AuthStateDidChangeListenerHandle?
    private let trans = FirebaseTrans.shared
    
    

    //Profile Fields
    var id: String?{
        get{ return data.id }
        set(value){ data.id = value }
    }
    
    var name: String?{
        get{ return data.name }
        set(value){ data.name = value}
    }
    var gender: String? {
        get{ return data.gender }
        set(value){ data.gender = value}
    }
    var major: String? {
        get{ return data.major }
        set(value){ data.major = value}
    }
    var university: String? {
        get{ return data.university }
        set(value){ data.university = value}
    }
    var imageURL: String?{
        get{ return data.imageURL}
        set(value){ data.imageURL = value}
    }
    var tag: [String]?{
        get{ return data.tag}
        set(value){ data.tag = value}
    }
    var schedule: String?{
        get{ return data.schedule}
        set(value){ data.schedule = value}
    }
    var ps: String?{
        get{ return data.ps}
        set(value){ data.ps = value}
    }
    var count: Int?{
        get{ return data.count }
        set(value){ data.count = value }
    }
    var image: UIImage?{
        get{ return data.image }
        set(value){ data.image = value }
    }
    
    
    // user edit course grade
    var classData = [String]()
    var gradeData = [String]()
    // friendlist
    struct firendNode {
        var id: String = ""
        var state: String? = ""
        var name: String? = ""
        var isRedDotted: Bool = false
        var image: UIImage?
        
        init(id: String, state: String?){
            self.id = id
            self.state = state
        }
    }
    
    var contactList = [String: ProfileStruct]()
    var tutorList = [String: firendNode]()
    var studentList = [String: firendNode]()
    
    var cachedListener = [String: ListenerRegistration]()

    var messageList = [String: [JSQMessage]]()
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
                self.data = ProfileStruct()
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    if loggedIn{
                    } else {
                        ViewSwitch.moveToLoginPage()
                    }
                }
            }else{
                
                self.userProvider = user!.providerData[0].providerID
                self.currentUser = user
                self.id = (user?.uid)
                
                debugHelpPrint(type:ClassType.FirebaseUser,str:"Logged in", id: self.id)
                if !self.checkEmailVerified(){ return }
                self.downloadProfile(completion: {(success) in
                    // download image
                    self.downloadImage(completion: {
                        // move to tab page
                        DispatchQueue.main.asyncAfter(deadline: .now()){
                                ViewSwitch.moveToTabPage()
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
                debugHelpPrint(type: ClassType.FirebaseUser, str: "Email is not verified!", id: self.id)
                return false
            }
        }
        return true
    }
    
    private func cleanCachedListener(){
        for data in cachedListener{
            data.value.remove()
        }
        cachedListener = [String: ListenerRegistration]()
    }
    
    func isLoggedIn() -> Bool {
        return(currentUser != nil)
    }
    
    func logOut(){
        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance()?.signOut()
        self.contactList = [String: ProfileStruct]()
        self.studentList = [String: FirebaseUser.firendNode]()
        self.tutorList = [String: FirebaseUser.firendNode]()
        cleanCachedListener()
    }
    
    private func makeDict()->[String: Any]{
        let dictionary: [String: Any] = [
            // use as Any to avoid warning
            "id" : self.id as Any,
            "name" :self.name as Any,
            "gender" : self.gender as Any,
            "major" : self.major as Any,
            "university" : self.university as Any,
            "imageURL" : self.imageURL as Any,
            "tag" : self.tag as Any,
            "schedule" : self.schedule as Any,
            "ps" : self.ps as Any,
            "count" : self.count as Any
        ]
        return dictionary
    }
    
    // Parse data to UserStructure
    static func parseData(data:[String:Any?])->ProfileStruct{
        let schedule = data["schedule"] == nil ? "0000000000000000000000000000" : data["schedule"] as? String
        let back = ProfileStruct(
            id: data["id"] as? String,
            name: data["name"] as? String,
            gender: data["gender"] as? String,
            major: data["major"] as? String,
            university: data["university"] as? String,
            imageURL: data["imageURL"] as? String,
            tag: data["tag"] as? [String],
            schedule: schedule,
            ps: data["ps"] as? String,
            count: data["count"] as? Int ?? 0
        )
        return back
    }
    
    // ------------------------------------------------------------------------------------
    // Profile methods
    
    // create or override an existing doc
    func uploadProfile(){
        if isLoggedIn(){
            trans.createDoc(collection: [FirebaseTrans.USER_COLLECTION], id: self.id!, dict: self.makeDict())
        }else{
            debugHelpPrint(type: ClassType.FirebaseUser, str: "Trying to uploadDoc() while user is not logged in")
        }
    }
    
    // download an existing doc
    func downloadProfile(completion:@escaping(Bool)->Void){
        if isLoggedIn(){
            trans.downloadDoc(collections: [FirebaseTrans.USER_COLLECTION], id: self.id!, completion: {(data) in
                if let data=data{
                    // replace all current data with a brand new ProfileStruct
                    self.data = FirebaseUser.parseData(data: data)
                    self.downloadTutorCourses(completion: {done in
                        if done{
                            completion(true)
                        }else{
                            debugHelpPrint(type: ClassType.FirebaseUser, str: "Trying to download tutor grades with errors!", id:self.id)
                            completion(false)
                        }
                    })
                    
                }else{
                    debugHelpPrint(type: ClassType.FirebaseUser, str: "Trying to download profile with errors!", id:self.id)
                    completion(false)
                }
            })
        }else{
            debugHelpPrint(type: ClassType.FirebaseUser, str: "Trying to downloadDoc() while user is not logged in")
        }
    }
    
    func deleteTutorCourses(courseList: [String]){
        if isLoggedIn() || self.university == nil{
            var path = [FirebaseTrans.USER_COLLECTION]
            path.append(self.id!)
            path.append(FirebaseTrans.COURSE_COLLECTION)
            
            var path_school = [FirebaseTrans.SCHOOL_COLLECTION]
            path_school.append(self.university!)
            path_school.append(FirebaseTrans.COURSE_COLLECTION)
            
            let school = self.university ?? ""
            
            for i in 0..<courseList.count{
                let mergedId = school + "-" + courseList[i]
                debugHelpPrint(type: .FirebaseTrans, str: "deleteTutorCourses(): mergedId:\(mergedId)")
                
                FirebaseTrans.shared.deleteDoc(collection: path, id: mergedId)
                
                var path_course = path_school
                path_course.append(courseList[i])
                path_course.append(FirebaseTrans.TUTOR_COLLECTION)
                FirebaseTrans.shared.deleteDoc(collection: path_course, id: self.id!)
            }
        }else{
            debugHelpPrint(type: ClassType.FirebaseUser, str: "Trying to deleteTutorCourses() while user is not logged in")
        }
        
    }
    
    func uploadTutorCourses(courseList: [String], gradeList: [String]){
        if isLoggedIn() || self.university == nil{
            var path = [FirebaseTrans.USER_COLLECTION]
            path.append(self.id!)
            path.append(FirebaseTrans.COURSE_COLLECTION)
            
            let school = self.university ?? ""
            
            var path_school = [FirebaseTrans.SCHOOL_COLLECTION]
            path_school.append(school)
            path_school.append(FirebaseTrans.COURSE_COLLECTION)
            
            
            for i in 0..<courseList.count{
                let currentName = school + "-" + courseList[i]
                
                FirebaseTrans.shared.createDoc(collection: path, id: currentName, dict: [
                    "course" : courseList[i],
                    "grade":gradeList[i]
                    ])
                var course_path = path_school
                course_path.append(courseList[i])
                course_path.append(FirebaseTrans.TUTOR_COLLECTION)
                debugHelpPrint(type: .FirebaseUser, str: "uploadTutorCourses(): path: \(course_path) \(self.id)")
                
                FirebaseTrans.shared.createDoc(collection: course_path, id: self.id!, dict: [
                    "id": self.id as Any
                    ])
            }
        }else{
            debugHelpPrint(type: ClassType.FirebaseUser, str: "Trying to uploadTutorCourses() while user is not logged in")
        }
        
    }
    
    func downloadTutorCourses(completion:@escaping(Bool)->Void){
        if isLoggedIn(){
            var path = [FirebaseTrans.USER_COLLECTION]
            path.append(self.id!)
            path.append(FirebaseTrans.COURSE_COLLECTION)
            
            FirebaseTrans.shared.downloadAllDocumentsByCollection(collections: path, completion: {(data) in
                if let data = data{
                    var courseData = [String]()
                    var gradeData = [String]()
                    
                    for d in data{
                        if let course = d["course"] as? String {courseData.append(course)}
                        if let grade = d["grade"] as? String {gradeData.append(grade)}
                    }
                    
                    self.classData = courseData
                    self.gradeData = gradeData
                }
                debugHelpPrint(type: .FirebaseUser, str: "class:\(self.classData.debugDescription)\n grade:\(self.gradeData.debugDescription)")
                completion(true)
            })
        }else{
            debugHelpPrint(type: ClassType.FirebaseUser, str: "Trying to downloadTutorCourses() while user is not logged in")
            completion(false)
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
    
    static func dictToList(theDict: [String:Any]) -> [Any]{
        var theList = [Any]()
        for data in theDict{
            theList.append(data.value)
        }
        return theList
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
        
        trans.createDoc(collection: path, id: self.id!, dict: friendDictGenerator(state: .pending))
    }
    
    func reject(studentId: String){
        if !isLoggedIn(){
            debugHelpPrint(type: .FirebaseUser, str: "reject() not logged in")
        }
        //users->myId->student->delete
        var path = [String]()
        path.append(FirebaseTrans.USER_COLLECTION)
        path.append(id!)
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
        
        trans.createDoc(collection: path, id: self.id!, dict: friendDictGenerator(state: .accept))
        
        // change my document under student's to accept
        path.removeAll()
        path.append(FirebaseTrans.USER_COLLECTION)
        path.append(id!)
        path.append(FirebaseTrans.STUDENT_COLLECTION)
        
        trans.createDoc(collection: path, id: studentId, dict: friendDictGenerator(state: .accept))
    }
    
    func isMyTutor(tutorId: String)->Bool{
        return FirebaseUser.shared.tutorList[tutorId] != nil
    }
    
    func addStudentListListenerAndCache(listenerId:String, updateDelegate: listenerUpdateProtocol){
        if !isLoggedIn(){
            debugHelpPrint(type: .FirebaseUser, str: "addStudentListListenerAndCache() not logged in")
            return
        }
        
        if self.cachedListener[listenerId] != nil{
            self.cachedListener[listenerId]?.remove()
            debugHelpPrint(type: .FirebaseUser, str: "addStudentListListenerAndCache() has been updated!")
        }
        
        var path = [String]()
        path.append(FirebaseTrans.USER_COLLECTION)
        path.append(self.id!)
        path.append(FirebaseTrans.STUDENT_COLLECTION)
        
        // get the listener
        if let theCollection = self.trans.parseCollection(collections: path) {
           let theListener = theCollection.addSnapshotListener{ querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    debugHelpPrint(type: .FirebaseTrans, str: "addStudentListListenerAndCache(): \(error.debugDescription)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    let data = diff.document.data()
                    let id = diff.document.documentID
                    
                    if (diff.type == .added || diff.type == .modified) {
                        // student list
                        self.studentList[id] = FirebaseUser.firendNode(id: id, state: data["state"] as? String)
                        // download profile
                        self.trans.downloadDoc(collections: [FirebaseTrans.USER_COLLECTION], id: id, completion: {(data) in
                            if let data = data{
                                self.contactList[id] = FirebaseUser.parseData(data: data)
                                self.studentList[id]?.name = self.contactList[id]?.name
                                // download image
                                if let url = self.contactList[id]?.imageURL, url != ""{
                                    self.trans.downloadImageAndCache(url: url, completion: {(image) in
                                        self.studentList[id]?.image = image
                                        updateDelegate.contentUpdate()
                                    })
                                }else{
                                    updateDelegate.contentUpdate()
                                }
                            }
                        })
                    }else{
                        self.studentList[id] = nil
                        self.contactList[id] = nil
                        updateDelegate.contentUpdate()
                    }
                }
            }
            
            // cache the listener
            self.cachedListener[listenerId] = theListener

            
        }else{
            debugHelpPrint(type: .FirebaseTrans, str: "addStudentListListener(): input parameters have problems")
        }
    }
    
    func addTutorListListenerAndCache(listenerId:String, updateDelegate: listenerUpdateProtocol){
        if !isLoggedIn(){
            debugHelpPrint(type: .FirebaseUser, str: "addTutorListListenerAndCache() not logged in")
            return
        }
        
        if self.cachedListener[listenerId] != nil{
            self.cachedListener[listenerId]?.remove()
            debugHelpPrint(type: .FirebaseUser, str: "addTutorListListenerAndCache() has been updated!")
        }
        
        var path = [String]()
        path.append(FirebaseTrans.USER_COLLECTION)
        path.append(self.id!)
        path.append(FirebaseTrans.TUTOR_COLLECTION)
        
        // get the listener
        if let theCollection = self.trans.parseCollection(collections: path) {
            let theListener = theCollection.addSnapshotListener{ querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    debugHelpPrint(type: .FirebaseTrans, str: "addTutorListListenerAndCache(): \(error.debugDescription)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    let data = diff.document.data()
                    let id = diff.document.documentID
                    
                    if (diff.type == .added || diff.type == .modified) {
                        // tutor list
                        self.tutorList[id] = FirebaseUser.firendNode(id: id, state: data["state"] as? String)
                        // download profile
                        self.trans.downloadDoc(collections: [FirebaseTrans.USER_COLLECTION], id: id, completion: {(data) in
                            if let data = data{
                                self.contactList[id] = FirebaseUser.parseData(data: data)
                                self.tutorList[id]?.name = self.contactList[id]?.name
                                // download image
                                if let url = self.contactList[id]?.imageURL, url != ""{
                                    self.trans.downloadImageAndCache(url: url, completion: {(image) in
                                        self.tutorList[id]?.image = image
                                        debugHelpPrint(type: .FirebaseUser, str: "\(id) download tutor image complete")
                                        updateDelegate.contentUpdate()
                                    })
                                }else{
                                    debugHelpPrint(type: .FirebaseUser, str: "\(id) doesn't have an image")
                                    updateDelegate.contentUpdate()
                                }
                            }
                        })
                    }else{
                        self.tutorList[id] = nil
                        self.contactList[id] = nil
                        updateDelegate.contentUpdate()
                    }
                }
            }
            
            // cache the listener
            self.cachedListener[listenerId] = theListener
            
        }else{
            debugHelpPrint(type: .FirebaseTrans, str: "addTutorListListenerAndCache(): input parameters have problems")
        }
    }
    
    func changeRedDotState(id: String, state: Bool){
        if !isLoggedIn(){
            debugHelpPrint(type: .FirebaseUser, str: "changeRedDotState() not logged in")
            return
        }
        if self.tutorList[id] != nil { self.tutorList[id]?.isRedDotted = state }
        else if self.studentList[id] != nil { self.studentList[id]?.isRedDotted = state }
        else { debugHelpPrint(type: .FirebaseUser, str: "changeRedDotState(): \(id) doesn't exist in both student and tutor lists") }
    }
    
    func addUnreadMessageListenerAndCache(listenerId:String, updateDelegate: listenerUpdateProtocol){
        if !isLoggedIn(){
            debugHelpPrint(type: .FirebaseUser, str: "addUnreadMessageListenerAndCache() not logged in")
            return
        }
        
        if self.cachedListener[listenerId] != nil{
            self.cachedListener[listenerId]?.remove()
            debugHelpPrint(type: .FirebaseUser, str: "addUnreadMessageListenerAndCache() has been updated!")
        }
        
        var path = [String]()
        path.append(FirebaseTrans.USER_COLLECTION)
        path.append(self.id!)
        path.append(FirebaseTrans.UNREAD_COLLECTION)
        
        // get the listener
        if let theCollection = self.trans.parseCollection(collections: path) {
            let theListener = theCollection.addSnapshotListener{ querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    debugHelpPrint(type: .FirebaseTrans, str: "addUnreadMessageListenerAndCache(): \(error.debugDescription)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    let id = diff.document.documentID
                    
                    if (diff.type == .added || diff.type == .modified) {
                        self.changeRedDotState(id: id, state: true)
                        debugHelpPrint(type: .FirebaseTrans, str: "addUnreadMessageListenerAndCache(): a new unread message")
                    }else{
                        self.changeRedDotState(id: id, state: false)
                        debugHelpPrint(type: .FirebaseTrans, str: "addUnreadMessageListenerAndCache(): a deleted unread message")
                    }
                    updateDelegate.contentUpdate()
                }
            }
            
            // cache the listener
            self.cachedListener[listenerId] = theListener
            
        }else{
            debugHelpPrint(type: .FirebaseTrans, str: "addUnreadMessageListenerAndCache(): input parameters have problems")
        }
    }
    
    // ------------------------------------------------------------------------------------
    // Chatting methods
    
    
    func tryToDeleteUnreadMessage(targetId: String){
        var path = [String]()
        path.append(FirebaseTrans.USER_COLLECTION)
        path.append(self.id!)
        path.append(FirebaseTrans.UNREAD_COLLECTION)
        
        self.trans.deleteDoc(collection: path, id: targetId)
    }
    
    private func addUnreadMessage(targetId: String){
        var path = [String]()
        path.append(FirebaseTrans.USER_COLLECTION)
        path.append(targetId)
        path.append(FirebaseTrans.UNREAD_COLLECTION)
        
        self.trans.createDoc(collection: path, id: self.id!, dict: ["info": "You have an unread message"])
    }
    
    private func mergeIds(targeId: String)->String{
        if id! > targeId{ return id! + "-" + targeId }
        else { return targeId + "-" + id! }
    }
    
    func getMessageList(targetId:String)->[JSQMessage]?{
        return messageList[mergeIds(targeId: targetId)]
    }
    
    func sendMessage(targetId: String, message: String){
        if !isLoggedIn(){
            debugHelpPrint(type: .FirebaseUser, str: "sendMessage() not logged in")
            return
        }
        // create unread message notification
        addUnreadMessage(targetId: targetId)
        
        // create a new messagea
        let roomId = mergeIds(targeId: targetId)
        var path = [String]()
        path.append(FirebaseTrans.CHAT_COLLECTION)
        path.append(roomId)
        path.append(FirebaseTrans.CHANNEL_COLLECTION)
        
        trans.createDoc(collection: path, id: nil, dict: [
            "senderId": id ?? "",
            "displayName": name ?? "",
            "message": message,
            "time": NSDate().timeIntervalSince1970
            ])
    }
    func addChannelListenerAndCache(targetId:String, targetName:String, updateDelegate: listenerUpdateProtocol){
        if !isLoggedIn(){
            debugHelpPrint(type: .FirebaseUser, str: "addChannelListenerAndCache() not logged in")
            return
        }
        
        let channelId = mergeIds(targeId: targetId)
        
        
        if self.cachedListener[channelId] != nil{
            self.cachedListener[channelId]?.remove()
            debugHelpPrint(type: .FirebaseUser, str: "addChannelListenerAndCache() has been updated!")
        }
        
        messageList[channelId] = [JSQMessage]()
        
        
        var path = [String]()
        path.append(FirebaseTrans.CHAT_COLLECTION)
        path.append(channelId)
        path.append(FirebaseTrans.CHANNEL_COLLECTION)
        
        // get the listener
        if let theCollection = self.trans.parseCollection(collections: path) {
            let theListener = theCollection.order(by: "time", descending: false).limit(to: 50).addSnapshotListener{ querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    debugHelpPrint(type: .FirebaseTrans, str: "addChannelListenerAndCache(): \(error.debugDescription)")
                    return
                }
                
                snapshot.documentChanges.forEach { diff in
                    let data = diff.document.data()
                    
                    if (diff.type == .added || diff.type == .modified) {
                        self.messageList[channelId]?.append(JSQMessage(senderId: data["senderId"] as? String, displayName: data["displayName"] as? String, text: data["message"] as? String))
                    }
                    updateDelegate.contentUpdate()
                }
            }
            
            // cache the listener
            self.cachedListener[channelId] = theListener
            
        }else{
            debugHelpPrint(type: .FirebaseTrans, str: "addChannelListenerAndCache(): input parameters have problems")
        }
    }
    
    
    // ------------------------------------------------------------------------------------
    // Image methods
    func uploadImage(data: Data,completion: @escaping (Bool) -> Void){
        if !isLoggedIn(){
            debugHelpPrint(type: .FirebaseUser, str: "uploadImage() not logged in")
            completion(false)
        }
        
        trans.uploadFile(folder: FirebaseTrans.IMAGE_FOLDER, id: id!, fileExtension: FirebaseTrans.IMAGE_EXTENSION, data: data, completion: {(url) in
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
        if let url = imageURL, url != ""{
            trans.downloadImageAndCache(url: url, completion: {(theUIImage) in
                self.image = theUIImage
                completion()
            })
        }else{
            debugHelpPrint(type: .FirebaseUser, str: "downloadImage(): \(self.id!) doesn't have an uploaded image")
            completion()
        }
    }
}
