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
    
    let USER_COLLECTIONS = "users"
    
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
        let theDoc = db.collection(USER_COLLECTIONS).document(id)
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
    
    /***
        query transmission functions-----------------------
     ***/
    
    
    // general query functions
    
    // para1: collection
    // para2: keywords you want to query by
    // para3: normal element fields, which are types like string, int, bool
    // para4 (optional): array element fields, which contains array elements such as [string], [int]

    
    /**
        For each keyword, there must be two possibilities
            1. it is a singleton field
            2. it is an array field
     
     Method 1:
        Make courses and schools independent collections
            treat each search as both singleton and array fields
            check singleton field
                return all results
            check array fields
                return all results
            Merge two results
                return results
     
            -school                         -> good -all information about the school
            -course                         -> good -all related information
            -feature                        -> good -all related information
            -school course ... other        -> bad  -how to merge?
     
     
     Method 2:
        Make courses based on schools
            check from school collections
                if it is there, return the collection
                if not there linearly search every course in every schoool
                    return all relavant information
                - school course -good
                - course - ok
                - course school - problem
                - school course feature - problem
     
     Method 3:
        restrict input
        school course feature
     
     */
    
    func query(collection:String, words:[String], normalFields:[String], arrayFields:[String] = [], completion:@escaping(Dictionary<String, Any>?)->Void){
        let collectionRef = db.collection(collection)
        var theDic = Dictionary<String, Any>()
        
        if normalFields.count > 0{
            queryNormalFields(collectionRef: collectionRef, words: words, normalElementField: normalFields, completion: {(data) in
                
                data!.forEach(<#T##body: ((key: String, value: Any)) throws -> Void##((key: String, value: Any)) throws -> Void#>)
                
                if arrayFields.count > 0{
                    
                }
            })
        }
        
    }
    
    private func queryNormalFields(collectionRef:CollectionReference, words:String, normalElementField:[String], completion:@escaping(Dictionary<String, Any>?)->Void){
        // normal element field search
        for field in normalElementField{
            // filter
            let results = collectionRef.whereField(field, isGreaterThanOrEqualTo: words)

            
            // query data
            results.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    debugHelpPrint(type: ClassType.FirebaseTrans, str: "Error getting documents: \(err)")
                    completion(nil)
                } else {
                    var theDic = Dictionary<String,Any>()
                    for document in querySnapshot!.documents {
                        theDic[document.documentID] = document.data()
                        debugHelpPrint(type: ClassType.FirebaseTrans, str: "\(document.documentID) => \(document.data())")
                    }
                    completion(theDic)
                }
            }
        }
    }
    
    private func queryArrayFields(collectionRef:CollectionReference, words:String, arrayElementField:[String], completion:@escaping(Dictionary<String, Any>?)->Void){
        // array element field search
        for field in arrayElementField{
            // filter
            let results = collectionRef.whereField(field, arrayContains: words)
            
            // query data
            results.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    debugHelpPrint(type: ClassType.FirebaseTrans, str: "Error getting normal field documents: \(err)")
                    completion(nil)
                } else {
                    var theDic = Dictionary<String,Any>()
                    for document in querySnapshot!.documents {
                        theDic[document.documentID] = document.data()
                        // prompt
                        debugHelpPrint(type: ClassType.FirebaseTrans, str: "\(document.documentID) => \(document.data())")
                    }
                    completion(theDic)
                }
            }
        }
    }
}
