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
    
    @IBOutlet weak var tutorTableView: UITableView!
    var pics: [Pic] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tutorTableView.delegate = self
        tutorTableView.dataSource = self
        pics = createArray()
        
        tutorTableView.reloadData()
        tutorTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //self.roundedLabel(newMess)
    }
    func createArray() -> [Pic] {
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
        
        return tempPics
    }
    
    func roundedLabel(_ object: AnyObject) {
        object.layer?.cornerRadius = object.frame.size.width/2
        object.layer?.masksToBounds = true
    }
}

extension FriendListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pic = pics[indexPath.row] // indexPath.row is dynamic
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorListTableViewCell", for: indexPath) as? FriendListTableViewCell
        
        cell?.setPic(pic: pic)
        debugHelpPrint(type: .AppDelegate, str: "\(pic)")
        return cell!
    }
}
