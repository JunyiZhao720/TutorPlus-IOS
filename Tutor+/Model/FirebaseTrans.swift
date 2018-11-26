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
    
    static let IMAGE_FOLDER = "images/"
    
    static let IMAGE_EXTENSION = ".png"
    
    static let NAME_FIELD = "name"
    static let UNIVERSITY_FIELD = "university"
    static let TAG_FIELD = "tag"
    
    // used for search structure
    public class node{
        let name: String
        let id: String
        
        init(name: String, id:String){
            self.name = name
            self.id = id
        }
    }
    
    private let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    
    private override init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    
    
    // ------------------------------------------------------------------------------------
    // Single document downloading methods
    
    
    
    // general create, override, and upload method
    
    // para1: collection id
    // para2: document id
    // para3: data
    
    func createDoc(collection: [String], id: String, dict: Dictionary<String, Any>){
        if collection.count<=0 || collection.count % 2 == 0{
            debugHelpPrint(type: .FirebaseTrans, str: "createDoc() collection wrong parameters")
            return
        }
        var collec = db.collection(collection[0])
        // get chain result
        for i in 1..<collection.count{
            collec = collec.document(collection[i]).collection(collection[i+1])
        }
        
        collec.document(id).setData(dict){ err in
            if let error = err{
                debugHelpPrint(type: ClassType.FirebaseTrans, str: error.localizedDescription, id: id)
            } else {
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Creating a new document", id: id)
            }
            
        }
    }
    
    func deleteDoc(collection: [String], id: String){
        if collection.count<=0 || collection.count % 2 == 0{
            debugHelpPrint(type: .FirebaseTrans, str: "deleteDoc() collection wrong parameters")
            return
        }
        var collec = db.collection(collection[0])
        // get chain result
        for i in 1..<collection.count{
            collec = collec.document(collection[i]).collection(collection[i+1])
        }
        
        collec.document(id).delete() { err in
            if let err = err {
                //print("Error removing document: \(err)")
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "deleteDoc() Error removing document: \(err)", id: id)
            } else {
                //print("Document successfully removed!")
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "deleteDoc() Document successfully removed!", id: id)
            }
        }
    }
    
    
    
    // general download functions
    
    // para1: collection
    // para2: document Id
    // para3: completion handler -> anonymous class
        //    FirebaseTrans.shared.downloadDoc(collection: collection_name, id: id, completion: { (data) in
        //        if let data = data{
        //        /... do your stuff
        //        }
        //    })
    
    func downloadDoc(collection:String, id:String, completion:@escaping(Dictionary<String, Any>?)->Void){
        let theDoc = db.collection(collection).document(id)
        theDoc.getDocument{(document, error) in
            if let err = error{
                debugHelpPrint(type: ClassType.FirebaseTrans, str: err.localizedDescription, id:id)
                completion(nil)
            }
            
            if let document = document, document.exists{
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Successfully download the document!", id:id);
                completion(document.data())
            }else{
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Trying to download a nonexistent document", id:id)
                completion(nil)
            }
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
                completion(document.data())
            }else{
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Trying to download a nonexistent document")
                completion(nil)
            }
        }
    }
    
    
    
    // ------------------------------------------------------------------------------------
    // Collection downloading methods
    
    private func parseCollection(collections:[String])->CollectionReference?{
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
    
    // general collection documents downloader
    // para1: collections
    //      collection.documentid.collection....
    public func downloadAllDocumentsByCollection(collections:[String], completion:@escaping([node]?)->Void){
        
        if let theCollection = parseCollection(collections: collections) {
            // download data
            theCollection.getDocuments{(querySnapshot, err)in
                if let err = err{
                    debugHelpPrint(type: .FirebaseTrans, str: "\(err.localizedDescription)")
                    completion(nil)
                } else {
                    var back = [node]()
                    for document in querySnapshot!.documents{
                        let data = document.data()
                        back.append(node(name: data[FirebaseTrans.NAME_FIELD] as! String, id: document.documentID))
                    }
                    debugHelpPrint(type: .FirebaseTrans, str: "downloadAllDocuments: done downloading collection documents")
                    completion(back)
                }
            }
        }else{
            debugHelpPrint(type: .FirebaseTrans, str: "downloadAllDocumentsByCollection(): input parameters have problems")
        }
    }
    
    public func downloadAllDocumentsBySchoolAndCourse(school:String, course:String, completion:@escaping([FirebaseUser.ProfileStruct]?)->Void){
        let theQuery = db.collection(FirebaseTrans.USER_COLLECTION).whereField(FirebaseTrans.UNIVERSITY_FIELD, isEqualTo: school).whereField(FirebaseTrans.TAG_FIELD, arrayContains: course)
        
        theQuery.getDocuments{(querySnapshot, err) in
            if let err = err{
                debugHelpPrint(type: .FirebaseTrans, str: "\(err.localizedDescription)")
                completion(nil)
            } else {
                var back = [FirebaseUser.ProfileStruct]()
                for document in querySnapshot!.documents{
                    let data = document.data()
                    debugHelpPrint(type: .FirebaseTrans, str: "\(data.description)")
                    back.append(FirebaseUser.parseData(data: data))
                }
                debugHelpPrint(type: .FirebaseTrans, str: "downloadSelectedUserDocuments: done downloading selected user documents")
                completion(back)
            }
        }
    }
    
    
    // ------------------------------------------------------------------------------------
    // Listener methods
    
    public func collectionListener(collections: [String]){
        if let theCollection = parseCollection(collections: collections) {
            theCollection.addSnapshotListener{ querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    debugHelpPrint(type: .FirebaseTrans, str: "collectionListener(): \(error.debugDescription)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        print("New city: \(diff.document.data())")
                    }
                    if (diff.type == .modified) {
                        print("Modified city: \(diff.document.data())")
                    }
                    if (diff.type == .removed) {
                        print("Removed city: \(diff.document.data())")
                    }
                }
            }
            
        }else{
            debugHelpPrint(type: .FirebaseTrans, str: "downloadAllDocumentsByCollection(): input parameters have problems")
        }
    }
    
    // ------------------------------------------------------------------------------------
    // Image methods
    
    public func uploadFile(folder: String, id: String, fileExtension: String, data: Data, completion: @escaping(String?)->Void){
        let path = folder + id + fileExtension
        debugHelpPrint(type: .FirebaseTrans, str: "uploadFile(): \(path)")
        
        let fileRef = storageRef.child(path)
        
        // Upload the file
        fileRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                debugHelpPrint(type: .FirebaseTrans, str: "uploadFile(): \(error.debugDescription)")
                
                completion(nil)
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
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
}
