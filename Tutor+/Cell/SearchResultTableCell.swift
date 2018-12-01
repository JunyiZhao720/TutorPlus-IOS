//
//  SearchResultTutorProfileTableViewCell.swift
//  Tutor+
//
//  Created by Bo Lan  on 10/28/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

class SearchResultTableCell: UITableViewCell{

    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var tutorName: UILabel!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var schoolName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //set image to circle
        img.layer.cornerRadius = img.frame.size.width/2
        img.clipsToBounds = true
        img.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

