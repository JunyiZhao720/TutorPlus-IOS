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
    
    var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        redSpot.layer.cornerRadius = redSpot.frame.size.width/2
        redSpot.clipsToBounds = true
    }
    
    @IBAction func actionAccept(_ sender: UIButton) {
        if let id = id{
            FirebaseUser.shared.accept(studentId: id)
        }else{
            debugHelpPrint(type: .FriendListTableViewCell, str: "actionAccept(): Error \(tutorName.text ?? "") doesn't have an id")
        }
        outletAccept.isHidden = true
        outletDecline.isHidden = true
    }
    
    @IBAction func actionDecline(_ sender: UIButton) {
        if let id = id{
            FirebaseUser.shared.reject(studentId: id)
        }else{
            debugHelpPrint(type: .FriendListTableViewCell, str: "actionDecline(): Error \(tutorName.text ?? "") doesn't have an id")
        }
        outletAccept.isHidden = true
        outletDecline.isHidden = true
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
