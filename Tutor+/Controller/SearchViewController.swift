//
//  SearchViewController.swift
//  Tutor+
//
//  Created by jzhao33 on 10/16/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {


    @IBOutlet weak var schoolSearchBar: UISearchBar!
    @IBOutlet weak var courseSearchBar: UISearchBar!
    @IBOutlet weak var resultTableView: UITableView!
    
    // Main data source for search Table
    var suggestionTableArray = [FirebaseTrans.node]()
    var currentSuggestionTableArray = [FirebaseTrans.node]()
    var isLastEditedBoxSchool = false
    
    // school and course stores
    var currentSchoolName: String?
    var currentCourseName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTableView.dataSource = self
        resultTableView.delegate = self
        schoolSearchBar.delegate = self
        courseSearchBar.delegate = self
        
        downloadCollectionInfo()
    }
    
    
    // Firebase Transmission and overall array manipulation
    
    
    func downloadCollectionInfo(collectionId: String?  = nil){
        var theId = [FirebaseTrans.SCHOOL_COLLECTION]
        
        // if it is to download course collection
        if let id = collectionId{
            theId.append(id)
            theId.append(FirebaseTrans.COURSE_COLLECTION)
        }
        
        // clean current array
        suggestionTableArray = [FirebaseTrans.node]()
        updateSuggestionArray()
        
        FirebaseTrans.shared.downloadAllDocuments(collections: theId, completion: {(data)in
            if let data = data{
                self.suggestionTableArray = data
                self.updateSuggestionArray()
            }
        })
    }
    
    
    private func updateSuggestionArray(){
        currentSuggestionTableArray = suggestionTableArray
        resultTableView.reloadData()
    }
    
    // ------------------------------------------------------------------------------------
    // Suggestion Table View
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSuggestionTableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SearchViewTableViewCell else {
            debugHelpPrint(type: .SearchViewController, str: "Empty")
            return UITableViewCell()
        }
        cell.suggestionLabel.text = currentSuggestionTableArray[indexPath.row].name
        debugHelpPrint(type: .SearchViewController, str: "\(String(describing: cell.suggestionLabel.text))")
        return cell
    }
    
    // user click the item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath) as? SearchViewTableViewCell
        debugHelpPrint(type: .SearchViewController, str: "\(String(describing: currentCell?.suggestionLabel.text))")
        
        
        if isLastEditedBoxSchool{
            // are we choosing school?
            
            schoolSearchBar.text = currentCell?.suggestionLabel.text
            // setup datastore
            currentSchoolName = currentCell?.suggestionLabel.text
            currentCourseName = nil
            downloadCollectionInfo(collectionId: String(currentSuggestionTableArray[indexPath.row].id))
            debugHelpPrint(type: .SearchViewController, str: "Selected school:\(currentSchoolName ?? "null")")
            
        } else {
            // are we choosing course?
            
            courseSearchBar.text = currentCell?.suggestionLabel.text
            currentCourseName = currentCell?.suggestionLabel.text
            debugHelpPrint(type: .SearchViewController, str: "Selected course:\(currentCourseName ?? "null")")
            
            // data for transfer
            var data = Dictionary<String, String>()
            data["school"] = currentSchoolName
            data["course"] = currentCourseName
            
            // here we got both school name and course name
            self.performSegue(withIdentifier: "SearchToResult", sender: data)
        }
        
        resultTableView.isHidden = true
    }
    
    // ------------------------------------------------------------------------------------
    // Search Bars
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard !searchText.isEmpty else {
            if (searchBar == schoolSearchBar){downloadCollectionInfo()}
            
            resultTableView.isHidden = true
            currentSuggestionTableArray = suggestionTableArray
            return
        }
        
        isLastEditedBoxSchool = searchBar == schoolSearchBar ? true : false
        
        resultTableView.isHidden = false
        currentSuggestionTableArray = suggestionTableArray.filter({ suggestion -> Bool in
            suggestion.name.lowercased().contains(searchText.lowercased())
        })
        resultTableView.reloadData()
    }
    
    // ------------------------------------------------------------------------------------
    // Other
    
    // override segue to pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SearchToResult"){
            let nav = segue.destination as! UINavigationController
            let dest = nav.viewControllers.first as! SearchResultController
            let schoolCourse = sender as! [String:String]
            dest.schoolCourse = schoolCourse
        }
    }
}
