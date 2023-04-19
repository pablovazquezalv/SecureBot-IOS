//
//  User.swift
//  SecureBot
//
//  Created by imac on 19/04/23.
//

import UIKit

class User: NSObject {
    var id = 0
    var name = ""
    var ap_paterno = ""
    var ap_materno = ""
    var email = ""
    var phone_number = ""
    var rol_id = 4
    
    init(id: Int, name: String, ap_paterno: String, ap_materno: String, email: String, phone_number: String, rol_id: Int) {
        self.id = id
        self.name = name
        self.ap_paterno = ap_paterno
        self.ap_materno = ap_materno
        self.email = email
        self.phone_number = phone_number
        self.rol_id = rol_id
    }
}
