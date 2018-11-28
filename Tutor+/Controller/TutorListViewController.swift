//
//  TutorListViewController.swift
//  Tutor+
//
//  Created by Wenhao Ge on 11/27/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class TutorListViewController: UIViewController {

    
    @IBOutlet weak var `switch`: UISegmentedControl!
    @IBOutlet weak var friendListScrollView: UIScrollView!
    
    @IBOutlet weak var tutorTableView: UITableView!
    var pics: [Pic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tutorTableView.delegate = self
        tutorTableView.dataSource = self
        pics = createArray()
        
        tutorTableView.reloadData()
        //tutorTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    func createArray() -> [Pic] {
        var tempPics: [Pic] = []
        
        //        let pic1 = Pic(image: landscape, title: "vash wang")
        //        let pic2 = Pic(image:    , title: "aaron ge")
        //        let pic3 = Pic(image: , title: "Gua", )
        
        let pic1 = Pic(title: "vash", course: "cs101", message: "hello")
        let pic2 = Pic(title: "aaron", course: "cs110", message: "hello")
        let pic3 = Pic(title: "gua", course: "ce12", message: "hello")
        
        tempPics.append(pic1)
        tempPics.append(pic2)
        tempPics.append(pic3)
        
        return tempPics
    }
}

extension TutorListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pic = pics[indexPath.row] // indexPath.row is dynamic
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorListTableViewCell", for: indexPath) as? TutorListTableViewCell
        
        cell?.setPic(pic: pic)
        debugHelpPrint(type: .AppDelegate, str: "\(pic)")
        return cell!
    }
}
