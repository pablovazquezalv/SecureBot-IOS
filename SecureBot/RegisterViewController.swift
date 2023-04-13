//
//  RegisterViewController.swift
//  SecureBot
//
//  Created by imac on 12/04/23.
//

import UIKit

class RegisterViewController: UIViewController
{

    
    @IBOutlet weak var nombreTF: UITextField!
    @IBOutlet weak var apTF: UITextField!
    @IBOutlet weak var amTF: UITextField!
    @IBOutlet weak var telefonoTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmpasswordTF: UITextField!
    
    
    @IBOutlet weak var nombreError: UILabel!
    @IBOutlet weak var apError: UILabel!
    @IBOutlet weak var amError: UILabel!
    @IBOutlet weak var telError: UILabel!
    @IBOutlet weak var emailError: UILabel!
    
    
    @IBOutlet weak var passwordlblError: UILabel!
    
    
    @IBOutlet weak var passwordconfirmlbError: UILabel!
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
    }
    
   
    
    
    
    func invalidName(_ value: String)-> String?
    {
      let expresionRegular = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", expresionRegular)

        if !predicate.evaluate(with: value)
                {
                    return "Correo invalido"
                }
                
                return nil
    }
    
    
    @IBAction func NameAction(_ sender: Any)
    {
        if let email = nombreTF.text
        {
            if let errorMessage = invalidName(email)
                        {
                nombreError.text = errorMessage
                nombreError.isHidden = false
                        }
                        else
                        {
                            nombreError.isHidden = true
                        }
        }
        
    }
    
    
    
    @IBAction func regresar()
    {
        self.dismiss(animated: true)

    }
    
}
