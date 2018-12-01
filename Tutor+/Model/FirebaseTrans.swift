//
//  FirebaseTrans.swift
//  Tutor+
//
//  Created by MacOS-1.14 on 10/19/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit
import Firebase

class FirebaseTrans: NSObject {
    
    static let shared = FirebaseTrans()
    
    static let USER_COLLECTION = "users"
    static let SCHOOL_COLLECTION = "schools"
    static let COURSE_COLLECTION = "courses"
    static let STUDENT_COLLECTION = "students"
    static let TUTOR_COLLECTION = "tutors"
    static let UNREAD_COLLECTION = "unread"
    static let CHAT_COLLECTION = "chats"
    static let CHANNEL_COLLECTION = "channel"
    
    static let IMAGE_FOLDER = "images/"
    
    static let IMAGE_EXTENSION = ".png"
    
    static let NAME_FIELD = "name"
    static let COURSE_FIELD = "course"
    static let UNIVERSITY_FIELD = "university"
    static let TAG_FIELD = "tag"
    static let COUNT_FIELD = "count"
    
    public let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    private let imageCache = NSCache<NSString, UIImage>()
    
    public var searchCache : [String: String]?
    
    private override init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    // ------------------------------------------------------------------------------------
    // Helper methods
    
    public func parseCollection(collections:[String])->CollectionReference?{
        // check parameters
        if(collections.count <= 0 || collections.count % 3 == 2) {
            
            return nil
        }
        
        // initialize collections
        var theCollection = db.collection(collections[0])
        var i = 1
        
        while(i < collections.count){
            theCollection = theCollection.document(collections[i]).collection(collections[i+1])
            i += 2
        }
        return theCollection
    }
    
    
    // ------------------------------------------------------------------------------------
    // Single document downloading methods
    
    
    
    // general create, override, and upload method
    
    // para1: collection id
    // para2: document id
    // para3: data
    
    func createDoc(collection: [String], id: String?, dict: Dictionary<String, Any>){
        if let collection = parseCollection(collections: collection) {
            var docRef: DocumentReference
            
            if let id=id { docRef = collection.document(id) }
            else { docRef = collection.document() }
            
            docRef.setData(dict){ err in
                if let error = err{
                    debugHelpPrint(type: ClassType.FirebaseTrans, str: error.localizedDescription, id: id)
                } else {
                    debugHelpPrint(type: ClassType.FirebaseTrans, str: "Creating a new document", id: id)
                }
            }
            
        }else{
            debugHelpPrint(type: .FirebaseTrans, str: "createDoc(): input parameters have problems")
        }

    }
    
    func deleteDoc(collection: [String], id: String){
        if let collection = parseCollection(collections: collection) {
            collection.document(id).delete() { err in
                if let err = err {
                    debugHelpPrint(type: ClassType.FirebaseTrans, str: "deleteDoc() Error removing document: \(err)", id: id)
                } else {
                    debugHelpPrint(type: ClassType.FirebaseTrans, str: "deleteDoc() Document successfully removed!", id: id)
                }
            }
            
        }else{
            debugHelpPrint(type: .FirebaseTrans, str: "createDoc(): input parameters have problems")
        }
    }
//    func isDocExists(collection: [String], id: String)->Bool?{
//        if let collection = parseCollection(collections: collection) {
//            return collection.document(id)
//        }else{
//            debugHelpPrint(type: .FirebaseTrans, str: "isDocExists(): input parameters have problems")
//            return nil
//        }
//    }
    
    
    
    // general download functions
    
    // para1: collection
    // para2: document Id
    // para3: completion handler -> anonymous class
        //    FirebaseTrans.shared.downloadDoc(collection: collection_name, id: id, completion: { (data) in
        //        if let data = data{
        //        /... do your stuff
        //        }
        //    })
    
    func downloadDoc(collections:[String], id:String, completion:@escaping(Dictionary<String, Any>?)->Void){
        
        if let theCollection = parseCollection(collections: collections) {
            let theDoc = theCollection.document(id)
            theDoc.getDocument{(document, error) in
                if let err = error{
                    debugHelpPrint(type: ClassType.FirebaseTrans, str: err.localizedDescription, id:id)
                    completion(nil)
                }
                
                if let document = document, document.exists{
                    debugHelpPrint(type: ClassType.FirebaseTrans, str: "Successfully download the document!", id:id);
                    var data = document.data()
                    data?["id"] = document.documentID
                    completion(data)
                }else{
                    debugHelpPrint(type: ClassType.FirebaseTrans, str: "Trying to download a nonexistent document", id:id)
                    completion(nil)
                }
            }
        }else{
            debugHelpPrint(type: .FirebaseTrans, str: "downloadDoc(): input parameters have problems")
        }
    }
    
    func downloadDoc(documentRef: DocumentReference, completion:@escaping(Dictionary<String, Any>?)->Void){

        documentRef.getDocument{(document, error) in
            if let err = error{
                debugHelpPrint(type: ClassType.FirebaseTrans, str: err.localizedDescription)
                completion(nil)
            }
            
            if let document = document, document.exists{
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Successfully download the document!");
                var data = document.data()
                data?["id"] = document.documentID
                completion(data)
            }else{
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Trying to download a nonexistent document")
                completion(nil)
            }
        }
    }
    
    
    
    // ------------------------------------------------------------------------------------
    // Collection downloading methods
    
    
    // general collection documents downloader
    // para1: collections
    //      collection.documentid.collection....
    public func downloadAllDocumentIdByCollection(collections:[String], completion:@escaping([String]?)->Void){
        
        if let theCollection = parseCollection(collections: collections) {
            // download data
            theCollection.getDocuments{(querySnapshot, err)in
                if let err = err{
                    debugHelpPrint(type: .FirebaseTrans, str: "\(err.localizedDescription)")
                    completion(nil)
                } else {
                    var back = [String]()
                    for document in querySnapshot!.documents{
                        back.append(document.documentID)
                    }
                    debugHelpPrint(type: .FirebaseTrans, str: "downloadAllDocuments: done downloading collection documents")
                    completion(back)
                }
            }
        }else{
            debugHelpPrint(type: .FirebaseTrans, str: "downloadAllDocumentsByCollection(): input parameters have problems")
        }
    }
    
    public func downloadAllDocumentsByCollection(collections:[String], completion:@escaping([[String: Any]]?)->Void){
        if let theCollection = parseCollection(collections: collections) {
            // download data
            theCollection.getDocuments{(querySnapshot, err)in
                if let err = err{
                    debugHelpPrint(type: .FirebaseTrans, str: "\(err.localizedDescription)")
                    completion(nil)
                } else {
                    var back = [[String: Any]]()
                    for document in querySnapshot!.documents{
                        var data = document.data()
                        data["id"] = document.documentID
                        back.append(data)
                    }
                    debugHelpPrint(type: .FirebaseTrans, str: "downloadAllDocumentsByCollection(): done downloading collection documents")
                    completion(back)
                }
            }
        }else{
            debugHelpPrint(type: .FirebaseTrans, str: "downloadAllDocumentsByCollection(): input parameters have problems")
        }
    }
    
    public func downloadAllDocumentsBySchoolAndCourse(school:String, course:String, avoid:String, completion:@escaping([FirebaseUser.ProfileStruct]?)->Void){
        
        let query = db.collection(FirebaseTrans.USER_COLLECTION).whereField(FirebaseTrans.UNIVERSITY_FIELD, isEqualTo: school).whereField(FirebaseTrans.TAG_FIELD, arrayContains: course)
        
        debugHelpPrint(type: .FirebaseTrans, str: "downloadAllDocumentsBySchoolAndCourse(): \(school,course)")

        query.getDocuments{(querySnapshot, err) in
            if let err = err{
                debugHelpPrint(type: .FirebaseTrans, str: "\(err.localizedDescription)")
                completion(nil)
            } else {
                var back = [FirebaseUser.ProfileStruct]()
                
                for document in querySnapshot!.documents{
                    var data = document.data()
                    debugHelpPrint(type: .FirebaseTrans, str: "\(data.description)")
                    if document.documentID == avoid { continue }
                    data["id"] = document.documentID
                    back.append(FirebaseUser.parseData(data: data))
                }
                debugHelpPrint(type: .FirebaseTrans, str: "downloadAllDocumentsBySchoolAndCourse: done downloading selected user documents")
                completion(back)
            }
        }
    }
    
    public func downloadWholeProfileByLimitAndOrder(collections:[String], field:String, limit:Int, descend:Bool, completion:@escaping([FirebaseUser.ProfileStruct]?)->Void){
        
        if let theCollection = parseCollection(collections: collections) {
            // download data
            theCollection.order(by: field, descending: descend).limit(to: limit).getDocuments{(querySnapshot, err)in
                if let err = err{
                    debugHelpPrint(type: .FirebaseTrans, str: "\(err.localizedDescription)")
                    completion(nil)
                } else {
                    var back = [FirebaseUser.ProfileStruct]()
                    // download normal profile
                    for document in querySnapshot!.documents{
                        var data = document.data()
                        data["id"] = document.documentID
                        let processed = FirebaseUser.parseData(data: data)
                        back.append(processed)
                    }
                    // download image file
                    for i in 0..<back.count{
                        let profile = back[i]
                        if let url = profile.imageURL{
                            self.downloadImageAndCache(url: url, completion: {(image) in
                                back[i].image = image
                            })
                        }
                    }
                    debugHelpPrint(type: .FirebaseTrans, str: "downloadWholeProfileByLimitAndOrder(): done downloading collection documents")
                    completion(back)
                }
            }
        }else{
            debugHelpPrint(type: .FirebaseTrans, str: "downloadWholeProfileByLimitAndOrder(): input parameters have problems")
        }
    }
  
    
    // ------------------------------------------------------------------------------------
    // File methods
    
    public func uploadFile(folder: String, id: String, fileExtension: String, data: Data, completion: @escaping(String?)->Void){
        let path = folder + id + fileExtension
        debugHelpPrint(type: .FirebaseTrans, str: "uploadFile(): \(path)")
        
        let fileRef = storageRef.child(path)
        
        // Upload the file
        fileRef.putData(data, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                debugHelpPrint(type: .FirebaseTrans, str: "uploadFile(): \(error.debugDescription)")
                completion(nil)
                return
            }
            // Metadata contains file metadata such as size, content-type.
            //let size = metadata.size
            // You can also access to download URL after upload.
            fileRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    debugHelpPrint(type: .FirebaseTrans, str: "uploadFile(): \(error.debugDescription)")
                    completion(nil)
                    return
                }
                completion(downloadURL.absoluteString)
                return
            }
        }
    }
    
   public func downloadImageAndCache(url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            completion(cachedImage)
        } else {
            // Create a reference to the file you want to download
            let httpsReference = Storage.storage().reference(forURL: url)
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            httpsReference.getData(maxSize: 15 * 1024 * 1024) { data, error in
                if let error = error {
                    debugHelpPrint(type: .FirebaseTrans, str: "downloadFileAndCach():\(error)")
                    completion(nil)
                } else {
                    let image = UIImage(data: data!)
                    self.imageCache.setObject(image!, forKey: url as NSString)
                    completion(image)
                }
            }
        }
    }
    
}
