//
//  UserSingletion.swift
//  SnapchatClone
//
//  Created by Fırat AKBULUT on 26.10.2023.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init(){
        
    }
}
