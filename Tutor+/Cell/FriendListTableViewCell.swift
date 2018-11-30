//
//  TutorListTableViewCell.swift
//  Tutor+
//
//  Created by Wenhao Ge on 11/27/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {

    @IBOutlet weak var redSpot: UILabel!
    @IBOutlet weak var tutorImage: UIImageView!
    @IBOutlet weak var tutorName: UILabel!
   
    
    @IBOutlet weak var outletAccept: UIButton!
    @IBOutlet weak var outletDecline: UIButton!
    
    
    @IBAction func actionAccept(_ sender: UIButton) {
        //AlertHelper.showAlert(fromController: self, message: "\(tutorName.text)", buttonTitle: "123")
    }
    
    @IBAction func actionDecline(_ sender: UIButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        redSpot.layer.cornerRadius = redSpot.frame.size.width/2
        redSpot.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func showbuttonsByPending(pending: String?){
        if pending == "pending"{
            outletAccept.isHidden = false
            outletDecline.isHidden = false
        }else{
            outletAccept.isHidden = true
            outletDecline.isHidden = true
        }
        
    }
    
    public func showRedDot(show: Bool){
        redSpot.isHidden = show
    }
}
