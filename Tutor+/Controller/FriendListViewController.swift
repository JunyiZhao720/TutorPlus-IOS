//
//  TutorListViewController.swift
//  Tutor+
//
//  Created by Wenhao Ge on 11/27/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class FriendListViewController: UIViewController {

    @IBOutlet weak var `switch`: UISegmentedControl!
    @IBOutlet weak var friendListScrollView: UIScrollView!
    
    @IBOutlet weak var friendListSearchBar: UISearchBar!
    @IBOutlet weak var tutorTableView: UITableView!
    
    var pics: [Pic] = []
    var curPics: [Pic] = []
//    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tutorTableView.delegate = self
        tutorTableView.dataSource = self
        createArray()
        
        tutorTableView.reloadData()
        tutorTableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    func createArray(){
        var tempPics: [Pic] = []
        
        //        let pic1 = Pic(image: landscape, title: "vash wang")
        //        let pic2 = Pic(image:    , title: "aaron ge")
        //        let pic3 = Pic(image: , title: "Gua", )
        
        let pic1 = Pic(title: "Vash Wang")
        let pic2 = Pic(title: "Aaron Ge")
        let pic3 = Pic(title: "Gua Zhao")
        let pic4 = Pic(title: "Veronica Wuuuu")
        
        tempPics.append(pic1)
        tempPics.append(pic2)
        tempPics.append(pic3)
        tempPics.append(pic4)
        
        curPics = tempPics
        pics = tempPics
        
    }
    
    func setUpSearchbar() {
        friendListSearchBar.delegate = self
    }
}

extension FriendListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curPics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let pic = pics[indexPath.row] // indexPath.row is dynamic
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorListTableViewCell", for: indexPath) as? FriendListTableViewCell
        
        
        cell?.tutorName.text = curPics[indexPath.row].title
//        debugHelpPrint(type: .AppDelegate, str: "\(pic)")
        
        return cell!
    }
}

extension FriendListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            curPics = pics
            tutorTableView.reloadData()
            return
        }
        curPics = pics.filter({element -> Bool in element.title.lowercased().contains(searchText.lowercased())})
        tutorTableView.reloadData()
        print("searched")
    }

//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searching = false
//        searchBar.text = ""
//        tutorTableView.reloadData()
//
//    }
}
