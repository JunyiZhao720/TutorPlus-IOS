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
        initializeNav()

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
        if let image = FirebaseUser.shared.image{ theImage.image = image }
        else { theImage.image = UIImage(named: "landscape") }
       
    }
    
    private func initializeNav(){
        self.navigationItem.title = "Profile"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonOnClicked))
    }
    

    @objc func logoutButtonOnClicked(_ sender: UIBarButtonItem) {
        FirebaseUser.shared.logOut()
    }
    
}
