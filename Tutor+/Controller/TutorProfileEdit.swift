//
//  TutorProfileEdit.swift
//  Tutor+
//
//  Created by Bo Lan  on 10/20/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class TutorProfileEdit: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var classGradeTableView: UITableView!
    var className = [String]()
    var classGrade = [String]()
    
    @IBAction func addingClass(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Class", message: nil, preferredStyle: .alert)
        alert.addTextField{ (dessertTF) in dessertTF.placeholder = "Enter Class Name"
        }
        let action = UIAlertAction(title: "Add", style: .default){ (_) in guard let tempclass = alert.textFields?.first?.text else{return}
            print(tempclass)
            self.addClassFunc(tempclass)
        }
        alert.addAction(action)
        present(alert,animated: true)
    }
    
    @IBAction func btn_addingGrades(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Grade", message: nil, preferredStyle: .alert)
        alert.addTextField{ (dessertTF) in dessertTF.placeholder = "Enter Grade"
        }
        let action = UIAlertAction(title: "Add", style: .default){ (_) in guard let tempgrade = alert.textFields?.first?.text else{return}
            print(tempgrade)
            self.addClassGradeFunc(tempgrade)
        }
        alert.addAction(action)
        present(alert,animated: true)
    }
    
    func addClassFunc(_ classs: String){
        let index = 0
        className.insert(classs, at: index)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)
        
    }
    
    func addClassGradeFunc(_ classs: String){
        let index = 0
        classGrade.insert(classs, at: index)
        let indexPath = IndexPath(row: index, section: 0)
        classGradeTableView.insertRows(at: [indexPath], with: .fade)
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
        if(tableView == classGradeTableView){
            //let cell = UITableViewCell()
            let grades = classGrade[indexPath.row]
            cell.textLabel?.text = grades
        }else{
            // let cell = UITableViewCell()
            let classes = className[indexPath.row]
            cell.textLabel?.text = classes
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(tableView == classGradeTableView){
            guard editingStyle == .delete else {return}
            classGrade.remove(at: indexPath.row)
            classGradeTableView.deleteRows(at: [indexPath], with: .automatic)
        }else{
        guard editingStyle == .delete else {return}
        className.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
