//
//  Empresa.swift
//  SecureBot
//
//  Created by imac on 20/04/23.
//

import UIKit

class Empresa: NSObject {
    var id = 0
    var name = "Sin empresa"
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
