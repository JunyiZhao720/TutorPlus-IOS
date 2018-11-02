//
//  SearchViewController.swift
//  Tutor+
//
//  Created by jzhao33 on 10/16/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var table: UITableView!
    
    // Main data source for search Table
    var suggestionTableArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        
        setUpTexts()
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

    
    
    private func setUpTexts(){
        suggestionTableArray.append("test")
        suggestionTableArray.append("test2")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestionTableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? SearchViewTableViewCell else {
            debugHelpPrint(type: .SearchViewController, str: "Empty")
            return UITableViewCell()
        }
        cell.suggestionLabel.text = suggestionTableArray[indexPath.row]
        debugHelpPrint(type: .SearchViewController, str: "\(String(describing: cell.suggestionLabel.text))")
        return cell
    }
    
}
