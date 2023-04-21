//
//  Sensor.swift
//  SecureBot
//
//  Created by imac on 20/04/23.
//

import UIKit

class Sensor: NSObject {
    var nombre = ""
    var valor = ""
    


    init(nombre: String,valor:String)
    {
        self.nombre = nombre
        self.valor = valor
    }

    override var description: String {
        return String(format: "Nombre:", nombre)
    }
    
}
