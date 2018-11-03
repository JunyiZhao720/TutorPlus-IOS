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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTableView.dataSource = self
        resultTableView.delegate = self
        schoolSearchBar.delegate = self
        courseSearchBar.delegate = self
        
        downloadSchoolInfo()
    }
    
    
    // Firebase Transmission and overral array manipulation
    
    
    func downloadSchoolInfo(){
        FirebaseTrans.shared.downloadAllDocuments(collection: FirebaseTrans.SCHOOL_COLLECTION, completion: {(data)in
            if let data = data{
                self.suggestionTableArray = data
                self.updateSuggestionArray()
            }
        })
    }
    
    func downloadCourseInfo(){
        
    }
    
    private func updateSuggestionArray(){
        currentSuggestionTableArray = suggestionTableArray
        resultTableView.reloadData()
    }
    
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentCell = tableView.cellForRow(at: indexPath) as? SearchViewTableViewCell
        debugHelpPrint(type: .SearchViewController, str: "\(String(describing: currentCell?.suggestionLabel.text))")
        
        if isLastEditedBoxSchool{
            schoolSearchBar.text = currentCell?.suggestionLabel.text
        } else {
            courseSearchBar.text = currentCell?.suggestionLabel.text
        }
        
        resultTableView.isHidden = true
    }
    
    
    // Search Bars
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard !searchText.isEmpty else {
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
}
