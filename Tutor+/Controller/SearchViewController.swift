//
//  SearchViewController.swift
//  Tutor+
//
//  Created by jzhao33 on 10/16/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var table: UITableView!
    
    // Main data source for search Table
    var suggestionTableArray = [String]()
    var currentSuggestionTableArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        
        
        setUpSearchBar()
        setUpTableView()
        table.reloadData()
    }
    
    
    // Buttons
    
    
    @IBAction func searchButtonOnClicked(_ sender: Any) {
//        let theList = searchBar.text?.split(separator: " ")
//        var theStrList:[String] = [String]()
//
//        theList?.forEach{(item) in
//            theStrList.append(String(item))
//        }
//
//        if let theList = theList, theList.count != 0{
//            FirebaseTrans.shared.queryField(collection: "users", words: theStrList, field: "tag", completion: {(data) in
//
//            })
//        }
        debugHelpPrint(type: .SearchViewController, str: suggestionTableArray.description)
        table.reloadData()
        
    }
    
    @IBAction func logOutButtonOnClicked(_ sender: Any) {
        FirebaseUser.shared.logOut()
        ViewSwitch.moveToLoginPage()
    }
    
    
    // Suggestion Table View

    
    private func setUpTableView(){
        suggestionTableArray.append("test")
        suggestionTableArray.append("test2")
        
        currentSuggestionTableArray = suggestionTableArray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSuggestionTableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SearchViewTableViewCell else {
            debugHelpPrint(type: .SearchViewController, str: "Empty")
            return UITableViewCell()
        }
        cell.suggestionLabel.text = currentSuggestionTableArray[indexPath.row]
        debugHelpPrint(type: .SearchViewController, str: "\(String(describing: cell.suggestionLabel.text))")
        return cell
    }
    
    
    // Search boxes
    
   
    private func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard !searchText.isEmpty else {
            table.isHidden = true
            currentSuggestionTableArray = suggestionTableArray
            return
        }
        
        table.isHidden = false
        currentSuggestionTableArray = suggestionTableArray.filter({ suggestion -> Bool in
            suggestion.lowercased().contains(searchText.lowercased())
        })
        table.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){}
}
