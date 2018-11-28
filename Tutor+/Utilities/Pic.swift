//
//  Pic.swift
//  Tutor+
//
//  Created by Wenhao Ge on 11/27/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import Foundation
import UIKit

public struct Pic {
    //var image: UIImage
    var title: String
    var course: String
    var message: String
    
    //    init(image: UIImage, title: String) {
    //        self.image = image
    //        self.title = title
    //    }
    
    init(title: String, course: String, message: String) {
        //self.image = image
        self.title = title
        self.course = course
        self.message = message
    }
}
