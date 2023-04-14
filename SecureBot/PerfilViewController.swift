//
//  PerfilViewController.swift
//  SecureBot
//
//  Created by imac on 13/04/23.
//

import UIKit

class PerfilViewController: UIViewController {

    
    
    @IBOutlet weak var password: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
    }
    

 
    
    
   
    @IBAction func changed(_ sender: UIButton)
    {
        let alerta = UIAlertController(title: "Cambiar Password", message: "Escribe tu contraseña:", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Cambiar", style: .default, handler: nil)
        alerta.addTextField { textField in
                textField.placeholder = "Ingresa tu contraseña"
           
        }
        

        alerta.addTextField { textField in
                textField.placeholder = "Ingresa tu nueva contraseña"
          
        }
        alerta.addTextField { textField in
                textField.placeholder = "Rescribe la contraseña"
          
        }
      
        self.present(alerta, animated: true, completion: nil)
    }
    
   
    
   
    
   

}
