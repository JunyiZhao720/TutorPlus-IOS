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
    
// create doc to tutor_id's student, set the state to pending
    func request(collection: String, id: String, dict: Dictionary<String, Any>, state: String){
//================================================================================================
// this is set documents to some new data
//        let studentDocInTutor: [String: Any] = [
//            "Name": uname,
//            "id": id,
//            "state": "pending"
//        ]
//
//                db.collection("student").document("your_student").setData(studentDocInTutor){
//        err in
//        if let err = err {
//            debugHelpPrint(type: ClassType.FirebaseTrans, str: "Request fails.Error writing document: \(err)", id: id)
//        } else {
//            debugHelpPrint(type: ClassType.FirebaseTrans, str: "Request has been sent.Document successfully written!", id: id)
//        }
//    }
//================================================================================================
            
// this is add a new document
//================================================================================================
        var ref: DocumentReference? = nil
        ref = db.collection("student").addDocument(data: [
            "name": uname,
            "country": id,
            state: "pending"
        ]) {err in
                if let err = err {
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Request fails.Error writing document: \(err)", id: id)
            } else {
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Request has been sent.Document successfully written!", id: id)
            }
        }
    }
//================================================================================================
    
    
    // delete student_id within tutor's student
    // collection is student
    func reject(collection: String, id:String, dict: Dictionary<String, Any>){
        db.collection("student").document("your_student").delete() { err in
            if let err = err {
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Error removing document: \(err)", id: id)
            } else {
                //print("Document successfully removed!")
                debugHelpPrint(type: ClassType.FirebaseTrans, str: "Reject has been processde. Document successfully removed!", id: id)
            }
        }
    }
    

    
    // This can be used in tableView. It implements update and delete
    // https://www.youtube.com/watch?v=Q5s0dvVM3HE
    //    defining firebase reference var
    //    var refStudents: FIRDatabaseReference!
    //    var someList = [AritistModel]()
    //
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        let student = someList[indexPath.row]
    //
    //        let alertController = UIAlertController(title: "Example", message: "example", preferredStyle: .alert)
    //
    //        let updateAction = UIAlertAction(title: "Update", style: .default){(_) in
    //            let id = student.id
    //            let name = alertController.textFields?[0].text
    //            let xxx = alertController.textFields?[1].text
    //
    //            self.update(id: id!, name: name!, xxx: xxx!)
    //
    //        }
    //        let deleteAction = UIAlertAction(title: "Delete", style: .default){(_) in
    //            self.delete(id: student.id!)
    //        }
    //
    //        alertController.addTextField{(textField) in
    //            textField.text = student.name
    //        }
    //        alertController.addTextField{(textField) in
    //            textField.text = student.xxx
    //        }
    //
    //        alertController.addAction(updateAction)
    //        alertController.addAction(deleteAction)
    //
    //        present(alertController, animated:true, completion: nil)
    //    }
    //
    //    // update student'id ,name, and something else
    //    func update(id: String, name: String, xxx: String){
    //        let student = [
    //            "id": id,
    //            "studentName": name,
    //            "studentXXX": xxx
    //        ]
    //        refStudents.child(id).setValue(student)
    //        labelMessage.text = "Student updated"
    //    }
    //
    //    func delete(id:String){
    //        refStudents.child(id).setValue(nil)
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
    
    // general collection documents downloader
    // para1: collections
    //      collection.documentid.collection....
    public func downloadAllDocuments(collections:[String], completion:@escaping([node]?)->Void){
        
        
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
    
    public func downloadSelectedUserDocuments(school:String, course:String, completion:@escaping([FirebaseUser.UserStructure]?)->Void){
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
