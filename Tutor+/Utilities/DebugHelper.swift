//
//  DebugHelper.swift
//  Tutor+
//
//  Created by jzhao33 on 10/17/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import Foundation

// debug print function
// parameters: ClassType, string for the messages, id for the user
func debugHelpPrint(type: ClassType, str: String, id: String? = ""){
    print("DebugInfo-\(type)-\(id ?? ""): \(str)")
}
