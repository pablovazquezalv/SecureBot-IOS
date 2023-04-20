//
//  Carro.swift
//  SecureBot
//
//  Created by imac on 20/04/23.
//

import UIKit

class Carro: NSObject
{
    var name = ""
    var descripcion = ""
    var sensores:[String] = []
    

    init(name: String, descripcion: String)
    {
        self.name = name
        self.descripcion = descripcion
    
    }
    
    override var description: String {
        return String(format: "Nombre: %@\nDescripcion: ", name, descripcion)
    }

}
