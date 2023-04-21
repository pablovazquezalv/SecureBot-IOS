//
//  Sensor.swift
//  SecureBot
//
//  Created by imac on 20/04/23.
//

import UIKit

class Sensor: NSObject {
    var nombre = ""
    


    init(nombre: String)
    {
        self.nombre = nombre
    }

    override var description: String {
        return String(format: "Nombre:", nombre)
    }
    
}
