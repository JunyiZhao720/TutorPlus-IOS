//
//  NewTableViewCell.swift
//  Tutor+
//
//  Created by Wenhao Ge on 10/27/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import UIKit

protocol TableViewNew {
    func onClick(index: Int)
    
}

class UserProfileEditCourseCell: UITableViewCell {

    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    var cellDelegate: TableViewNew?
    var index: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
//    @IBAction func addCell(_ sender: Any) {
//    }

}
