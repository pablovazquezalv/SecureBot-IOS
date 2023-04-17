//
//  UserData.swift
//  SecureBot
//
//  Created by imac on 17/04/23.
//

import UIKit

class UserData: NSObject {
    var id: Int
    var name: String
    var ap_paterno: String
    var ap_materno: String
    var email: String
    var phone_number: String
    var rol_id: Int
    static var userData: UserData!
    
    override init() {
        id = 0
        name = ""
        ap_paterno = ""
        ap_materno = ""
        email = ""
        phone_number = ""
        rol_id = 4
    }
    
    static func sharedData()->UserData {
        if userData == nil {
            userData = UserData.init()
        }
        
        return userData
    }
}
