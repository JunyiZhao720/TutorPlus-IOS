//
//  SearchResultTutorDetailProfile.swift
//  Tutor+
//
//  Created by Bo Lan  on 10/28/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class SearchResultTutorProfileController: UIViewController {


    @IBOutlet weak var tutorName: UILabel!
    @IBOutlet weak var tutorPs: UITextView!
    @IBOutlet weak var tutorCourse: UITextView!
    @IBOutlet weak var tutorIcon: UIImageView!
    @IBOutlet weak var tutorMajor: UILabel!
    @IBOutlet weak var toolbarRequestButton: UIButton!
    
    
    var dataCache: FirebaseUser.ProfileStruct?
    var imageCache: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeItems()
    }
    
    // ------------------------------------------------------------------------------------
    // Initialize functions
    
    private func initializeItems(){
        tutorIcon.layer.cornerRadius = 5.0
        tutorIcon.layer.masksToBounds = true
        toolbarRequestButton.layer.cornerRadius = 5.0
        toolbarRequestButton.layer.masksToBounds = true
        
        if let dataCache = self.dataCache{
            tutorName.text = dataCache.name
            tutorPs.text = dataCache.ps
            tutorMajor.text = dataCache.major
            tutorIcon.image = imageCache
            
            var courses = ""
            if let tag = dataCache.tag{
                for course in tag{
                    courses.append(course + "\n")
                }
            }
            tutorCourse.text = courses
            
            updateSchedule(schedule: dataCache.schedule)
        }else{
            AlertHelper.showAlert(fromController: self, message: "Initialize tutor profile encounters unknown problems. Please go back and try again!", buttonTitle: "Error")
        }

    }

    // ------------------------------------------------------------------------------------
    // Button functions
    @IBAction func requestButtonOnClicked(_ sender: UIButton) {
        //FirebaseUser.shared.downloadAllTutorList()
//        debugHelpPrint(type: .SearchResultController, str: "\(FirebaseUser.shared.tutorList.debugDescription)")
//        debugHelpPrint(type: .SearchResultController, str: "\(FirebaseUser.shared.contactList.debugDescription)")
        
        //FirebaseUser.shared.addStudentListListenerAndCache(listenerId: "123", updateDelegate: self)
//        debugHelpPrint(type: .SearchResultController, str: "\(FirebaseUser.shared.studentList.debugDescription)")
//        debugHelpPrint(type: .SearchResultController, str: "\(FirebaseUser.shared.contactList.debugDescription)")
    }
    
    @IBAction func backButtonOnClicked(_ sender: Any) {
        var targetVC = UIViewController()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        targetVC = storyboard.instantiateViewController(withIdentifier: "SearchResultTutorProfileController") as! SearchResultController
        let navController = UINavigationController(rootViewController: targetVC)
        
        
        self.present(navController, animated: true, completion: nil)
    }
    
    // ------------------------------------------------------------------------------------
    // Schedule functions
    
    var scheduleData: Array<Character> = Array(repeating: "0", count: 28)
    @IBOutlet var scheduleBtn: [UIButton]!
    //btn manager
    
    func updateSchedule (schedule: String?){
        if let schedule = schedule{
            let scheduleData = Array(schedule)
            for i in 0...27{
                if scheduleData[i] == "1"{scheduleBtn[i].backgroundColor = UIColor.init(red: 0.20, green: 0.47, blue: 0.96, alpha: 1.0)}
                else{scheduleBtn[i].backgroundColor = UIColor.gray}
            }
        }
    }
    
    //tostring
    func scheduleToString()-> String{
        let stringDate = String(scheduleData)
        return stringDate
    }
}
