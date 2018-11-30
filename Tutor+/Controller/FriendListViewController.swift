//
//  TutorListViewController.swift
//  Tutor+
//
//  Created by Wenhao Ge on 11/27/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController, listenerUpdateProtocol {

    

    @IBOutlet weak var selector: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var contactTableView: UITableView!
    
    var isStudentSelected = true
    
    var tutorList : [FirebaseUser.firendNode] = []
    var studentList : [FirebaseUser.firendNode] = []
    
    var currentTutorList : [FirebaseUser.firendNode] = []
    var currentStudentList : [FirebaseUser.firendNode] = []
    
    let studentListListenerName = "studentList"
    let tutorListListenerName = "tutorList"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contactTableView.delegate = self
        contactTableView.dataSource = self
        searchBar.delegate = self
        
        initializeListeners()
        listenerUpdate()
        
        contactTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    @IBAction func switchBarValueChanged(_ sender: Any) {
        if selector.selectedSegmentIndex == 0{
            isStudentSelected = true
        }else{
            isStudentSelected = false
        }
        contactTableView.reloadData()
    }
    
    func initializeListeners(){
        FirebaseUser.shared.addStudentListListenerAndCache(listenerId: studentListListenerName, updateDelegate: self)
        FirebaseUser.shared.addStudentListListenerAndCache(listenerId: tutorListListenerName, updateDelegate: self)
    }
    
    func listenerUpdate() {
        
        // incase the user is doing searching
        searchBar.text = ""
        
        // update data
        tutorList = FirebaseUser.dictToList(theDict: FirebaseUser.shared.tutorList) as! [FirebaseUser.firendNode]
        studentList = FirebaseUser.dictToList(theDict: FirebaseUser.shared.studentList) as! [FirebaseUser.firendNode]
        currentTutorList = tutorList
        currentStudentList = studentList
        
        //debugHelpPrint(type: .FriendListViewController, str: "tutor: \(currentTutorList.description)")
        //debugHelpPrint(type: .FriendListViewController, str: "student: \(currentStudentList)")
        //debugHelpPrint(type: .FriendListViewController, str: "user-all: \(FirebaseUser.shared.contactList.description)")
        //debugHelpPrint(type: .FriendListViewController, str: "user-tutor: \(FirebaseUser.shared.studentList.description)")
        //debugHelpPrint(type: .FriendListViewController, str: "user-stuent: \(FirebaseUser.shared.tutorList.description)")
        contactTableView.reloadData()
    }
    
}

extension FriendListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isStudentSelected{
            return currentStudentList.count
        }else{
            return currentTutorList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorListTableViewCell", for: indexPath) as! FriendListTableViewCell
        
        if isStudentSelected{
            if let id = currentStudentList[indexPath.row].id{
                cell.tutorName.text = FirebaseUser.shared.contactList[id]?.name
                cell.tutorImage.image = currentStudentList[indexPath.row].image
                cell.showbuttonsByPending(pending: currentStudentList[indexPath.row].status)
            }
        }else{
            if let id = currentTutorList[indexPath.row].id{
                cell.tutorName.text = FirebaseUser.shared.contactList[id]?.name
                cell.tutorImage.image = currentTutorList[indexPath.row].image
                cell.showbuttonsByPending(pending: currentTutorList[indexPath.row].status)
            }
        }
        
        return cell
    }
}

extension FriendListViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        guard !searchText.isEmpty else {
//            curPics = pics
//            contactTableView.reloadData()
//            return
//        }
//        curPics = pics.filter({element -> Bool in element.title.lowercased().contains(searchText.lowercased())})
//        contactTableView.reloadData()
//        print("searched")
//    }

}
