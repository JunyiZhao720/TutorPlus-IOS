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
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var image1 = UIImage()
    var tName = ""
    var cName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tutorName.text = tName
        className.text = cName
        img.image = image1
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
}
