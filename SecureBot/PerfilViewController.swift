//
//  PerfilViewController.swift
//  SecureBot
//
//  Created by imac on 13/04/23.
//

import UIKit

class PerfilViewController: UIViewController {

    
    
   
    @IBOutlet weak var btncambiarNombre: UIButton!
    @IBOutlet weak var salir: UIButton!
    @IBOutlet weak var btncambiarCorreo: UIButton!
    @IBOutlet weak var btncambiarTelefono: UIButton!
    
    @IBOutlet weak var btncontraseña: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        diseño()
    }
    

 
    
    
   
    @IBAction func changed(_ sender: UIButton)
    {
        let alerta = UIAlertController(title: "Cambiar Password", message: "Escribe tu contraseña:", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Cambiar", style: .destructive, handler: nil)
        alerta.addTextField { textField in
                textField.placeholder = "Ingresa tu contraseña"
            
        }
        

        alerta.addTextField { textField in
                textField.placeholder = "Ingresa tu nueva contraseña"
          
        }
        alerta.addTextField { textField in
                textField.placeholder = "Rescribe la contraseña"
          
        }
        alerta.addAction(ok)
        self.present(alerta, animated: true, completion: nil)
    }
    
   
    
    @IBAction func changeName(_ sender: UIButton)
    {
        let alerta = UIAlertController(title: "Cambiar nombre", message: "Llena los campos:", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Actualizar", style: .destructive, handler: nil)
        alerta.addTextField { textField in
                textField.placeholder = "Ingresa tu nombre"
            
        }
        

        alerta.addTextField { textField in
                textField.placeholder = "Ingresa tu apellido paterno"
          
        }
        alerta.addTextField { textField in
                textField.placeholder = "Rescribe tu apellido materno"
          
        }
        alerta.addAction(ok)
        self.present(alerta, animated: true, completion: nil)
    }

    func diseño()
    {
        salir.layer.cornerRadius = 7.0
        btncambiarNombre.layer.cornerRadius = 7.0
        btncambiarCorreo.layer.cornerRadius = 7.0
        btncambiarTelefono.layer.cornerRadius = 7.0
        btncontraseña.layer.cornerRadius = 7.0
    }
}
