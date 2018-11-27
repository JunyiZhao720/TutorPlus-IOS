//
//  userProfilePageViewController.swift
//  Tutor+_Profile
//
//  Created by Bo Lan  on 10/16/18.
//  Copyright © 2018 Bo_Lan_try. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var genderView: UILabel!
    @IBOutlet weak var majorView: UILabel!
    @IBOutlet weak var universityView: UILabel!
    // TODO : need to be desided in one text or split into two
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeProfile()
        initializeImage()
        
        // set up navigation bar title
        self.navigationItem.title = "Profile"
    }
    
    // ------------------------------------------------------------------------------------
    // FirebaseUser Profile
    
    private func initializeProfile(){
        // initialize data
        self.nameView.text = FirebaseUser.shared.name
        self.genderView.text = FirebaseUser.shared.gender
        self.majorView.text = FirebaseUser.shared.major
        self.universityView.text = FirebaseUser.shared.university
    }
    
    private func initializeImage(){
        //set image to circle
        theImage.layer.cornerRadius = theImage.frame.size.width/2
        theImage.clipsToBounds = true
        theImage.layer.borderColor = UIColor.white.cgColor
        theImage.image = FirebaseUser.shared.imageProfile
    }
}
