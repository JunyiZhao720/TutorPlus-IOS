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
        FirebaseUser.shared.addTutorListListenerAndCache(listenerId: tutorListListenerName, updateDelegate: self)
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
            cell.id = currentStudentList[indexPath.row].id
            cell.tutorName.text = currentStudentList[indexPath.row].name
            cell.tutorImage.image = currentStudentList[indexPath.row].image
            debugHelpPrint(type: .FriendListViewController, str: "\(currentStudentList[indexPath.row].state)")
            cell.showbuttonsByPending(pending: currentStudentList[indexPath.row].state)
            
        }else{
            cell.id = currentTutorList[indexPath.row].id
            cell.tutorName.text = currentStudentList[indexPath.row].name
            cell.tutorImage.image = currentTutorList[indexPath.row].image
            debugHelpPrint(type: .FriendListViewController, str: "\(currentStudentList[indexPath.row].state)")
            cell.showbuttonsByPending(pending: currentTutorList[indexPath.row].state)
        }
        
        return cell
    }
}

extension FriendListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentStudentList = studentList
            currentTutorList = tutorList
            contactTableView.reloadData()
            return
        }
        if isStudentSelected{
            currentStudentList = studentList.filter({element -> Bool in element.name?.lowercased().contains(searchText.lowercased()) ?? false})
        }else{
            currentTutorList = tutorList.filter({element -> Bool in element.name?.lowercased().contains(searchText.lowercased()) ?? false})
        }
        contactTableView.reloadData()
        print("searched")
    }

}
