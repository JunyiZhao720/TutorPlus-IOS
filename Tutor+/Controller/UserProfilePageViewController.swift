//
//  userProfilePageViewController.swift
//  Tutor+_Profile
//
//  Created by Bo Lan  on 10/16/18.
//  Copyright © 2018 Bo_Lan_try. All rights reserved.
//

import UIKit

class UserProfilePageViewController: UIViewController {

    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var emailView: UILabel!
    @IBOutlet weak var genderView: UILabel!
    @IBOutlet weak var majorView: UILabel!
    @IBOutlet weak var universityView: UILabel!
    // TODO : need to be desided in one text or split into two
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Download user data
        FirebaseUser.shared.downloadDoc(completion: {(success) in
            self.nameView.text = FirebaseUser.shared.name
            self.emailView.text = FirebaseUser.shared.email
            self.genderView.text = FirebaseUser.shared.gender
            self.majorView.text = FirebaseUser.shared.major
            self.universityView.text = FirebaseUser.shared.university
        })
        
        
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
