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
    
    func createDoc(collection: String, id: String, dict: Dictionary<String, Any>){
        
        db.collection(collection).document(id).setData(dict){ err in
            if let error = err{
                debugHelpPrint(type: ClassType.FirebaseTrans, str: error.localizedDescription, id: id)
            } else {
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Creating a new document", id: id)
            }
            
        }
    }
    
    func uploadDoc(collection: String, id:String, dict: Dictionary<String, Any>){
        let theDoc = db.collection(collection).document(id)
        
        theDoc.updateData(dict){ err in
            if let err = err{
                debugHelpPrint(type: ClassType.FirebaseTrans, str: err.localizedDescription, id: id)
            }else{
                debugHelpPrint(type: ClassType.FirebaseTrans, str:"Successfully upload the doc!", id: id)
            }
        }
    }
    
    // general download functions
    // para1: completion handler
    // para2: collection
    // para3: document Id
    func downloadDoc(completion:@escaping(Dictionary<String, Any>?)->Void, collection: String, id:String){
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
    
}
