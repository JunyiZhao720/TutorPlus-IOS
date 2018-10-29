//
//  SearchViewController.swift
//  Tutor+
//
//  Created by jzhao33 on 10/16/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func searchButtonOnClicked(_ sender: Any) {
        let theList = searchBar.text?.split(separator: " ")
        var theStrList:[String] = [String]()
        
        theList?.forEach{(item) in
            theStrList.append(String(item))
        }
        
        if let theList = theList, theList.count != 0{
            FirebaseTrans.shared.queryField(collection: "users", words: theStrList, field: "tag", completion: {(data) in
                
            })
        }
        

        

    }
    
    @IBAction func logOutButtonOnClicked(_ sender: Any) {
        FirebaseUser.shared.logOut()
        ViewSwitch.moveToLoginPage()
    }
}
