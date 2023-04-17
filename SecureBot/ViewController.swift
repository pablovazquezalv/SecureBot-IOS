//
//  ViewController.swift
//  SecureBot
//
//  Created by imac on 12/04/23.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var viewHijo: UIView!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    
    @IBOutlet weak var emailError: UILabel!
    
    
    @IBOutlet weak var passwordError: UILabel!
    
    
    @IBOutlet weak var btnLogin: UIButton!
    
    
    @IBOutlet weak var btnCrearCuenta: UIButton!
    
    override func viewDidLoad()
    {
       
        btnLogin.layer.cornerRadius = 7.0
        emailTF.delegate = self
        passwordTF.delegate = self
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF
        {
            passwordTF.becomeFirstResponder()
        }
        else if textField == passwordTF
        {
            passwordTF.resignFirstResponder()
        }
        return true
    }
 
    func limpiarForm()
    {
        btnLogin.isEnabled = false
        emailError.isHidden = false
        passwordError.isHidden = false
        
        emailError.text = "Requerido"
        passwordError.text = "Requerido"
    }

    
   //CORREO
    @IBAction func emailChanged(_ sender: Any)
    {
        
        if let email = emailTF.text
        {
            if let errorMessage = invalidEmail(email)
            {
                emailError.text = errorMessage
                emailError.isHidden = false
            }
            else
            {
                emailError.isHidden = true
            }
        }
        checkForm()
    }
    
    func invalidEmail(_ value: String)-> String?
    {
      let expresionRegular = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", expresionRegular)

        if !predicate.evaluate(with: value)
                {
                    return "Correo invalido"
                }
                
                return nil
    }
    
    
    
    
    @IBAction func passwordChanged(_ sender: Any)
    {
        if let email = passwordTF.text
        {
            if let errorMessage = invalidPassword(email)
                        {
                            passwordError.text = errorMessage
                            passwordError.isHidden = false
                        }
                        else
                        {
                            passwordError.isHidden = true
                        }
        }
        checkForm()
    }
    
    
    func invalidPassword(_ value: String)-> String?
    {
        
        if value.count < 8
        {
            return  "debe ser al menos de 8 caracteres"
        }
        if containsDigit(value)
        {
            return "Debe tener al menos un digito"
        }
        if containsLowerCase(value)
        {
            return "Debe tener al menos una minuscula"
        }
     
                
                return nil
    }
    
    func containsDigit(_ value: String) -> Bool
    {
            let reqularExpression = ".*[0-9]+.*"
            let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
            return !predicate.evaluate(with: value)
    }
    
    func containsLowerCase(_ value: String) -> Bool
        {
            let reqularExpression = ".*[a-z]+.*"
            let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
            return !predicate.evaluate(with: value)
        }
    func containsUpperCase(_ value: String) -> Bool
        {
            let reqularExpression = ".*[A-Z]+.*"
            let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
            return !predicate.evaluate(with: value)
        }
    
    func checkForm()
    {
        
        if emailError.isHidden && passwordError.isHidden
        {
            btnLogin.isEnabled = true
        }
        else{
            btnLogin.isEnabled = false
        }
    }
    
    func postApi()
    {

       
    }
    //Boton login
    @IBAction func loginAction(_ sender: Any)
    {
        let url = URL(string: "https://securebot.ninja/api/v1/login")!
        
        guard url != nil else
        {
            print("error")
            return
        }

        var request = URLRequest(url: url,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10)
        request.httpMethod = "POST"
        
     
           let email = emailTF.text ?? ""
           let password = passwordTF.text ?? ""
          

           let requestBody: [String: Any] = [
               "email": email,
               "password": password
           ]
        
        do {
              let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
              request.httpBody = jsonData
              request.addValue("application/json", forHTTPHeaderField: "Content-Type")
          } catch {
              print("Error converting request body to JSON data: \(error)")
              return
          }
          
          let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
              if let error = error {
                  print("Error posting request: \(error)")
                  return
              }
              
              guard let data = data else {
                  print("No data received in response")
                  return
              }
              
              do {
                  let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                  print("Response: \(responseJSON)")
              } catch {
                  print("Error parsing response JSON: \(error)")
              }
          }
          
          task.resume()
        
    }
    
    

  
   
   
    
}

