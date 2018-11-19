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
    
    func createDoc(collection: String, id: String, dict: Dictionary<String, Any>){
        
        db.collection(collection).document(id).setData(dict){ err in
            if let error = err{
                debugHelpPrint(type: ClassType.FirebaseTrans, str: error.localizedDescription, id: id)
            } else {
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Creating a new document", id: id)
            }
            
        }
    }
    
    func deleteDoc(collection: String, id: String, dict: Dictionary<String, Any>){
        db.collection(collection).document(id).delete() { err in
            if let err = err {
                //print("Error removing document: \(err)")
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Error removing document: \(err)", id: id)
            } else {
                //print("Document successfully removed!")
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Document successfully removed!", id: id)
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
    
    
    
    // general collection documents downloader
    // para1: collections
    //      collection.documentid.collection....
    public func downloadAllDocumentsByCollection(collections:[String], completion:@escaping([node]?)->Void){
        
        // check parameters
        if(collections.count <= 0 || collections.count % 3 == 2) {
            debugHelpPrint(type: .FirebaseTrans, str: "Input collections parameters are not with format collection-documentid-collection")
            completion(nil)
            return
        }
        
        // initialize collections
        var theCollection = db.collection(collections[0])
        var i = 1
        
        while(i < collections.count){
            theCollection = theCollection.document(collections[i]).collection(collections[i+1])
            i += 2
        }
        
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
    }
    
    public func downloadAllDocumentsBySchoolAndCourse(school:String, course:String, completion:@escaping([FirebaseUser.UserStructure]?)->Void){
        let theQuery = db.collection(FirebaseTrans.USER_COLLECTION).whereField(FirebaseTrans.UNIVERSITY_FIELD, isEqualTo: school).whereField(FirebaseTrans.TAG_FIELD, arrayContains: course)
        
        theQuery.getDocuments{(querySnapshot, err) in
            if let err = err{
                debugHelpPrint(type: .FirebaseTrans, str: "\(err.localizedDescription)")
                completion(nil)
            } else {
                var back = [FirebaseUser.UserStructure]()
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
    // Image methods
    
    
}
