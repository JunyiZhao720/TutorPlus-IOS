//
//  TutorProfileEdit.swift
//  Tutor+
//
//  Created by 孙可天  on 10/20/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class TutorProfileEdit: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var className = [String]()
    
    
    @IBAction func addingClass(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Class", message: nil, preferredStyle: .alert)
        alert.addTextField{ (dessertTF) in dessertTF.placeholder = "Enter Class Name"
        }
        let action = UIAlertAction(title: "Add", style: .default){ (_) in guard let tempclass = alert.textFields?.first?.text else{return}
            print(tempclass)
            //self.className.append(tempclass)
            //self.tableView.reloadData()
            self.add(tempclass)
        }
        alert.addAction(action)
        present(alert,animated: true)
    }
    
    func add(_ classs: String){
        let index = 0
        className.insert(classs, at: index)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)
        
    }
    
}

extension TutorProfileEdit: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return className.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let classes = className[indexPath.row]
        cell.textLabel?.text = classes
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        className.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
