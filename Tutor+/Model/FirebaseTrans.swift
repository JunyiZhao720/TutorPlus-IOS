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
    
    func createDoc(collection: String, id: String){
        
        db.collection(USER_COLLECTIONS).document(id).setData([
            "name": "wo",
            "age": 15,
            "time":Date()
        ]){ err in
            if let error = err{
                debugHelpPrint(type: ClassType.FirebaseTrans, str: error.localizedDescription, id: id)
            } else {
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Creating a new document", id: id)
            }

        }
    }
}
