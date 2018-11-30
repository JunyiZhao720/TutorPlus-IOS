//
//  Constants.swift
//  Tutor+
//
//  Created by jzhao33 on 10/17/18.
//  Copyright © 2018 JunyiZhao. All rights reserved.
//

import Foundation

public let ProdcutName = "Tutor+"

public enum ClassType{
    case AppDelegate
    
    case LoginViewController
    case SearchViewController
    case SignUpViewController
    case UserProfileEditController
    case SearchResultController
    case SearchResultTutorProfileController
    case FriendListViewController
    
    case SearchViewTableViewCell
    case FriendListTableViewCell
    
    case FirebaseUser
    case FirebaseTrans
}

public enum ProviderType{
    case google
    case password
    
    var description : String {
        switch self {
            // Use Internationalization, as appropriate.
            case .google: return "google.com"
            case .password: return "password"
        }
    }
    
}
