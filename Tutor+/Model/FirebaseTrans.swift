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
    
    
    
    
    
    /***
     single-document transmission functions---------------------
     ***/
    
    
    
    
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
    
    /***
        query transmission functions-----------------------
     ***/
    
    
    // general query functions
    
    // para1: collection
    // para2: keywords you want to query by
    // para3: normal element fields, which are types like string, int, bool
    // para4 (optional): array element fields, which contains array elements such as [string], [int]

    
    /**
        Two Searchboxes
             SearchBox-1: scool
             SearchBox-2: couse
        steps
            1. Enter the page download all school information
                get all the information by pair <name, id>
            2. user starts typing stuff in search bar
                autocomplete based on typing
                user has to click one item
                    once clicked, download all the schools <name>
                    if not clicked, school textfield would pop up a warning prompt
            3.
     
     */
    
    public func downloadAllDocuments(collection:String, completion:@escaping([node]?)->Void){
        db.collection(collection).getDocuments{(querySnapshot, err)in
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
    
    public enum QueryType{
        case isEqualTo
        case isGreaterThanOrEqualTo
        case arrayContains
    }
    
    public func queryField(collection:String, words:[String], field:String,completion:@escaping([String:Any]?)->Void
        ){
        
        let collectionRef = db.collection(collection)
        
        // get the query
        var theQuery = collectionRef.whereField(field, arrayContains: words[0])
        for i in 1..<words.count{
            theQuery = theQuery.whereField(field, arrayContains: words[i])
        }
        
        // query data
        theQuery.getDocuments() { (querySnapshot, err) in
            if let err = err {
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Error getting documents: \(err)")
                completion(nil)
            } else {
                // no such document
                if querySnapshot?.count == 0{
                    debugHelpPrint(type: ClassType.FirebaseTrans, str: "queryField: No result was found in \(collection) - \(field)")
                    completion(nil)
                    return
                }
                
                // querySnapshot contains documents
                var back = [String:Any]()
                for document in querySnapshot!.documents {
                    
                    back[document.documentID] = document.data()
                    debugHelpPrint(type: ClassType.FirebaseTrans, str: "\(document.documentID) => \(document.data())")
                }
                completion(back)
            }
        }
        
    }
    
//    public func queryField(collection:String, word:String, field:String, type:QueryType, preDocumentRef: DocumentReference? = nil ,completion:@escaping([DocumentReference]?)->Void){
//
//        var collectionRef: CollectionReference
//
//        if let preDocumentRef = preDocumentRef{
//            collectionRef = preDocumentRef.collection(collection)
//        }else{
//            collectionRef = db.collection(collection)
//        }
//
//
//        var theQuery: Query
//        // filter
//        switch type{
//        case .isEqualTo:
//            theQuery = collectionRef.whereField(field, isEqualTo: word)
//        case .isGreaterThanOrEqualTo:
//            theQuery = collectionRef.whereField(field, isGreaterThanOrEqualTo: word)
//        case .arrayContains:
//            theQuery = collectionRef.whereField(field, arrayContains: word)
//        }
//
//        // query data
//        theQuery.getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Error getting documents: \(err)")
//                completion(nil)
//            } else {
//                // no such document
//                if querySnapshot?.count == 0{
//                    debugHelpPrint(type: ClassType.FirebaseTrans, str: "queryField: No fields contains \(word) in \(collection) - \(field)")
//                    completion(nil)
//                    return
//                }
//
//                // querySnapshot contains documents
//                var back = [DocumentReference]()
//                for document in querySnapshot!.documents {
//
//                    back.append(document.reference)
//                    debugHelpPrint(type: ClassType.FirebaseTrans, str: "\(document.documentID) => \(document.data())")
//                }
//                completion(back)
//            }
//        }
//    }
    
}
