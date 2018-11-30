//
//  TutorResultListView.swift
//  Tutor+
//
//  Created by Bo Lan  on 10/26/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class SearchResultController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var schoolCourse:[String:String] = [:]
    var tutorArray: [FirebaseUser.ProfileStruct] = []
    var tutorImageDict = [String: UIImage]()

    @IBOutlet weak var tutorListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeSchoolCourse()
        debugHelpPrint(type: .SearchResultController, str: "school:\(schoolCourse["school"] ?? "") course:\(schoolCourse["course"] ?? "")")
        downloadTutorData()
    }
    
    private func initializeSchoolCourse(){
        if schoolCourse["course"] == nil || schoolCourse["school"] == nil{
            if let schoolCourse = FirebaseTrans.shared.searchCache{
                self.schoolCourse = schoolCourse
            }
        }else{
            FirebaseTrans.shared.searchCache = self.schoolCourse
        }
    }
    private func downloadTutorImage(){
        for tutor in tutorArray{
            if let imageURL = tutor.imageURL{
                FirebaseTrans.shared.downloadImageAndCache(url: imageURL, completion: {(image) in
                    if let image = image{
                        self.tutorImageDict[imageURL] = image
                        self.tutorListView.reloadData()
                    }
                })
            }
            
        }
    }
    private func downloadTutorData(){
        if let school = schoolCourse["school"], let course = schoolCourse["course"]{
            FirebaseTrans.shared.downloadAllDocumentsBySchoolAndCourse(school: school, course: course, completion: {(data) in
                if let data = data{
                    self.tutorArray = data
                    self.tutorListView.reloadData()
                    
                    // Image downloading
                    debugHelpPrint(type: .SearchResultController, str: data.description)
                    self.downloadTutorImage()
                }
            })
        }else{
            AlertHelper.showAlert(fromController: self, message: "Downloading tutor data goes problems", buttonTitle: "OK")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutorArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchResultTableCell
        
        cell.tutorName.text = tutorArray[indexPath.row].name
        let courses = tutorArray[indexPath.row].tag
        var theCourse = ""
        if let courses = courses{
            for d in courses{
                theCourse  = theCourse + d + " "
            }
        }
        cell.className.text = theCourse
        cell.schoolName.text = tutorArray[indexPath.row].university
        if let url = tutorArray[indexPath.row].imageURL{
            if let image = tutorImageDict[url]{
                cell.img.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data = [String:Any?]()
        data["dataCache"] = self.tutorArray[indexPath.row]
        data["imageCache"] = self.tutorImageDict[self.tutorArray[indexPath.row].imageURL ?? ""]
        
        self.performSegue(withIdentifier: "SearchResultToTutorNav", sender: data)
    }
    
    // ------------------------------------------------------------------------------------
    // Other
    
    // override segue to pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SearchResultToTutorNav"){
            let nav = segue.destination as! UINavigationController
            let dest = nav.viewControllers.first as! SearchResultTutorProfileController
            let data = sender as! [String:Any?]
            // send data
            if let dataCache = data["dataCache"] {dest.dataCache = dataCache as? FirebaseUser.ProfileStruct}
            if let imageCache = data["imageCache"] {dest.imageCache = imageCache as? UIImage}
        }
    }
}
