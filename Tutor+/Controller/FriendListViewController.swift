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
    let unreadMessageListenerName = "unreadMessage"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contactTableView.delegate = self
        contactTableView.dataSource = self
        searchBar.delegate = self
        
        initializeListeners()
        contentUpdate()
        
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
        FirebaseUser.shared.addUnreadMessageListenerAndCache(listenerId: unreadMessageListenerName, updateDelegate: self)
    }
    
    func contentUpdate() {
        
        // incase the user is doing searching
        searchBar.text = ""
        
        // update data
        tutorList = FirebaseUser.dictToList(theDict: FirebaseUser.shared.tutorList) as! [FirebaseUser.firendNode]
        studentList = FirebaseUser.dictToList(theDict: FirebaseUser.shared.studentList) as! [FirebaseUser.firendNode]
        currentTutorList = tutorList
        currentStudentList = studentList
        
        
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
            let node = currentStudentList[indexPath.row]
            cell.id = node.id
            cell.tutorName.text = node.name
            cell.tutorImage.image = node.image
            //debugHelpPrint(type: .FriendListViewController, str: "\(currentStudentList[indexPath.row].state)")
            cell.showbuttonsByPending(pending: node.state)
            cell.isRedDotVisible(show: node.isRedDotted)
            debugHelpPrint(type: .FriendListViewController, str: "cell dotted: \(node.isRedDotted)")
            debugHelpPrint(type: .FriendListViewController, str: "tutor: \(currentTutorList.description)")
            debugHelpPrint(type: .FriendListViewController, str: "student: \(currentStudentList)")
            
        }else{
            let node = currentTutorList[indexPath.row]
            cell.id = node.id
            cell.tutorName.text = node.name
            cell.tutorImage.image = node.image
            //debugHelpPrint(type: .FriendListViewController, str: "\(currentTutorList[indexPath.row].state)")
            cell.showbuttonsByPending(pending: node.state)
            cell.isRedDotVisible(show: node.isRedDotted)
            debugHelpPrint(type: .FriendListViewController, str: "cell dotted: \(node.isRedDotted)")
            debugHelpPrint(type: .FriendListViewController, str: "tutor: \(currentTutorList.description)")
            debugHelpPrint(type: .FriendListViewController, str: "student: \(currentStudentList)")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath) as? FriendListTableViewCell
        debugHelpPrint(type: .FriendListViewController , str: "\(String(describing: currentCell?.tutorName))")
        
        var data: String
        if isStudentSelected{
            data = currentStudentList[indexPath.row].id
            self.performSegue(withIdentifier: "FriendListToChatting", sender: data)
        } else {
            data = currentTutorList[indexPath.row].id
            self.performSegue(withIdentifier: "FriendListToChatting", sender: data)
        }
        
    }
    // ------------------------------------------------------------------------------------
    // Other
    
    // override segue to pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "FriendListToChatting"){
            let nav = segue.destination as! UINavigationController
            let dest = nav.viewControllers.first as! ChatViewController
            let chatterId = sender as! String
            dest.chatterId = chatterId
        }
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
