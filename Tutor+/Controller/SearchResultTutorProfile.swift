//
//  SearchResultTutorProfile.swift
//  Tutor+
//
//  Created by Lay Guo on 2018/10/28.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class SearchResultTutorProfile: UIViewController {

    
    @IBOutlet weak var toolbarRequestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbarRequestButton.layer.cornerRadius = 5.0
        toolbarRequestButton.layer.masksToBounds = true
        
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

}
