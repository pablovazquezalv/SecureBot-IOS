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
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
    }
    
   
    
    
    
    
    
    @IBAction func regresar()
    {
        self.dismiss(animated: true)

    }
    
}
