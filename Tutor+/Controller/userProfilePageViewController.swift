//
//  userProfilePageViewController.swift
//  Tutor+_Profile
//
//  Created by Bo Lan  on 10/16/18.
//  Copyright © 2018 Bo_Lan_try. All rights reserved.
//

import UIKit

class userProfilePageViewController: UIViewController {

    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var emailView: UILabel!
    @IBOutlet weak var genderView: UILabel!
    @IBOutlet weak var majorView: UILabel!
    @IBOutlet weak var universityVIew: UILabel!
    // TODO : need to be desided in one text or split into two
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //set image to circle
        theImage.layer.cornerRadius = theImage.frame.size.width/2
        theImage.clipsToBounds = true
        theImage.layer.borderColor = UIColor.white.cgColor
        
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
