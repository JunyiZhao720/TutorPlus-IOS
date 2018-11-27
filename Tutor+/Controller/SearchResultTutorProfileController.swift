//
//  SearchResultTutorDetailProfile.swift
//  Tutor+
//
//  Created by Bo Lan  on 10/28/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class SearchResultTutorProfileController: UIViewController {
    //schedule
    var date: Array<Character> = Array(repeating: "0", count: 28)
    @IBOutlet var dateBtn: [UIButton]!
    //btn manager
    @IBAction func dateClicked(_ sender: UIButton) {
        if dateBtn[sender.tag].backgroundColor == UIColor.gray{
            dateBtn[sender.tag].backgroundColor = UIColor.init(red: 0.20, green: 0.47, blue: 0.96, alpha: 1.0)
            date[sender.tag] = "1"
            print(("string: "), getDate())
        }else{
            dateBtn[sender.tag].backgroundColor = UIColor.gray
            date[sender.tag] = "0"
            print(("string: "), getDate())
        }
    }
    //end of schedule

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
        updateDate()
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
        }else{
            AlertHelper.showAlert(fromController: self, message: "Initialize tutor profile encounters unknown problems. Please go back and try again!", buttonTitle: "Error")
        }

    }

    // ------------------------------------------------------------------------------------
    // Button functions
    @IBAction func requestButtonOnClicked(_ sender: UIButton) {

    }
    
    
    // ------------------------------------------------------------------------------------
    // Schedule functions
    
    func getDate()-> String{
        return toString()
    }
    
    //这下面写个setter，
    //schedule getter and setter function
    func setDate(){   //<--假设你pass个string下来叫 dateDownloade
        let dateDownloade = "0010100010111101010010010101"
        let update = Array(dateDownloade)
        for i in 0...27{
            date[i] = update[i]
        }
    }
    func updateDate (){
        //这里call setter
        setDate()
        for i in 0...27{
            if date[i] == "1"{dateBtn[i].backgroundColor = UIColor.init(red: 0.20, green: 0.47, blue: 0.96, alpha: 1.0)}
            else{dateBtn[i].backgroundColor = UIColor.gray}
        }
    }
    //tostring
    func toString()-> String{
        let stringDate = String(date)
        return stringDate
    }
    //end of schedule
}
