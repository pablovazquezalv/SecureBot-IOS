//
//  ViewController.swift
//  SecureBot
//
//  Created by imac on 12/04/23.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var viewHijo: UIView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var passwordError: UILabel!

    @IBOutlet weak var btnLogin: UIButton!

    var maxLenghts = [UITextField: Int]()
    let userData = UserData.sharedData()
    var hasErrors = true
    
    override func viewDidLoad()
    {
        btnLogin.layer.cornerRadius = 7.0
        emailTF.delegate = self
        passwordTF.delegate = self
        emailError.font = UIFont.systemFont(ofSize: 11)
        passwordError.font = UIFont.systemFont(ofSize: 11)
        btnLogin.isEnabled = false
 

        maxLenghts[passwordTF] = 20
        
        super.viewDidLoad()
    }
    
    //CORREO
    @IBAction func emailChanged(_ sender: Any) {
        if let email = emailTF.text {
            if let errorMessage = invalidEmail(email) {
                emailError.text = errorMessage
                emailError.isHidden = false
                checkForm()
            } else {
                emailError.isHidden = true
                checkForm()
            }
        }
    }
    
    //PASSWORD
    @IBAction func passwordChanged(_ sender: Any) {
        if let password = passwordTF.text {
            if let errorMessage = invalidPassword(password) {
                passwordError.text = errorMessage
                passwordError.isHidden = false
                checkForm()
            } else {
                passwordError.isHidden = true
                checkForm()
            }
        }
    }
    
    func invalidEmail(_ value: String)-> String? {
        if value.count == 0 {
            return "Este campo es requerido"
        }
        
        let expresionRegular = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", expresionRegular)

        if !predicate.evaluate(with: value) {
            return "Correo electrónico inválido"
        }
                
        return nil
    }
    
    func invalidPassword(_ value: String)-> String? {
        if value.count == 0 {
            return "Este campo es requerido"
        }
        
        if value.count < 8 {
            return  "Este campo debe tener al menos 8 caracteres"
        }
                
        return nil
    }
    
    //Boton login
    @IBAction func loginAction(_ sender: Any) {
        login()
    }
    
    func login() {
        let url = URL(string: "https://securebot.ninja/api/v1/login")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        
        let email = emailTF.text!
        let password = passwordTF.text!
          
        let requestBody: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            print("Error al convertir el cuerpo del request a JSON: \(error)")
            return
        }
          
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error en el request: \(error)")
                return
            }
            
            guard let data = data else {
                print("No se recibió data en la respuesta")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Respuesta: \(responseJSON)")
                    
                    if let jsonDict = responseJSON as? [String: Any],
                       let token = jsonDict["token"] as? String {
                        DispatchQueue.main.async {
                            self.hasErrors = false
                            self.userData.token = token
                        }
                    }
                } catch {
                    print("Error al convertir la respuesta a JSON: \(error)")
                }
            } else {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Respuesta: \(responseJSON)")
                    
                    if let jsonDict = responseJSON as? [String: Any],
                       let message = jsonDict["message"] as? String {
                        DispatchQueue.main.async {
                            let error = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "Aceptar", style: .default)
                            error.addAction(ok)
                            self.present(error, animated: true)
                        }
                    }
                } catch {
                    print("Error al convertir la respuesta a JSON: \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "sgLogin" {
            if !hasErrors {
                return true
            }
            
            return false
        }
            
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            passwordTF.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLenght = maxLenghts[textField] ?? Int.max
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
    
        return newString.length <= maxLenght
    }

    func checkForm()
    {
        if emailError.isHidden && passwordError.isHidden {
            btnLogin.isEnabled = true
        
        } else {
            btnLogin.isEnabled = false
         

        }
    }
    
    
    @IBAction func checked(_ sender: UIButton)
    {
        if sender.isSelected
        {
            sender.isSelected = false
        }
        else
        {
            sender.isSelected = true
        }
    }
    
    
    @IBAction func olvideMiContraseña(_ sender: UIButton)
    {
        let alerta = UIAlertController(title: "Recuperar contraseña", message: "Escribe tu correo:", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Cambiar", style: .destructive, handler: nil)
        
        

        alerta.addTextField { textField in
                textField.placeholder = "Ingresa tu correo electronico"
          
        }
        
        alerta.addAction(ok)
        self.present(alerta, animated: true, completion: nil)
    }
    
}

