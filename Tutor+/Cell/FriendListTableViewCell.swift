//
//  TutorListTableViewCell.swift
//  Tutor+
//
//  Created by Wenhao Ge on 11/27/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {

    @IBOutlet weak var tutorImage: UIImageView!
    @IBOutlet weak var tutorName: UILabel!
   
    
    @IBOutlet weak var outletAccept: UIButton!
    @IBOutlet weak var outletDecline: UIButton!
    
    
    @IBAction func actionAccept(_ sender: UIButton) {
        //AlertHelper.showAlert(fromController: self, message: "\(tutorName.text)", buttonTitle: "123")
        print("11102 \(tutorName.text)")
    }
    
    @IBAction func actionDecline(_ sender: UIButton) {
        
    }
    
    func setPic(pic: Pic) {
        //img.image = pic.image// that label name
        tutorName.text = pic.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
