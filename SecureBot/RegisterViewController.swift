//
//  RegisterViewController.swift
//  SecureBot
//
//  Created by imac on 12/04/23.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate
{

    //inputs
    
    @IBOutlet weak var nombreTF: UITextField!
    @IBOutlet weak var apTF: UITextField!
    @IBOutlet weak var amTF: UITextField!
    @IBOutlet weak var telefonoTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmpasswordTF: UITextField!
    
    //ERRORS LABELS
    @IBOutlet weak var nombreError: UILabel!
    @IBOutlet weak var apError: UILabel!
    @IBOutlet weak var amError: UILabel!
    @IBOutlet weak var telError: UILabel!
    @IBOutlet weak var emailError: UILabel!

    @IBOutlet weak var passwordError: UILabel!
  
    @IBOutlet weak var confirmPasswordError: UILabel!
    
    
    
    @IBOutlet weak var btnRegister: UIButton!
    
    

    
    
    
    
    override func viewDidLoad()
    {
        nombreTF.delegate = self
        apTF.delegate = self
        amTF.delegate = self
        telefonoTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        super.viewDidLoad()
        
        
    }
    
   
 
    //NOMBRE
    @IBAction func nameChanged(_ sender: Any)
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
    
    //APELLIDO PATERNO
    
    @IBAction func apChanged(_ sender: Any)
    {
        if let email = apTF.text
        {
            if let errorMessage = invalidName(email)
            {
                apError.text = errorMessage
                apError.isHidden = false
            }
            else
            {
                apError.isHidden = true
            }
        }
        
    }
    
   
    //APELLIDO MATERNO
    @IBAction func amChanged(_ sender: Any)
    {
        if let email = amTF.text
        {
            if let errorMessage = invalidName(email)
            {
                amError.text = errorMessage
                amError.isHidden = false
            }
            else
            {
                amError.isHidden = true
            }
        }
        
    }
    
    //TEL
    @IBAction func telChanged(_ sender: Any)
    {
        if let tel = telefonoTF.text
        {
            if let errorMessage = invalidNumber(tel)
            {
                telError.text = errorMessage
                telError.isHidden = false
            }
            else
            {
                telError.isHidden = true
            }
        }
    }
    
    //CORREO
    @IBAction func emailChanged(_ sender: Any)
    {
        if let tel = emailTF.text
        {
            if let errorMessage = invalidEmail(tel)
            {
                emailError.text = errorMessage
                emailError.isHidden = false
            }
            else
            {
                emailError.isHidden = true
            }
        }
    }
    
    
    
    //PASSWORD
    @IBAction func paswordChanged(_ sender: Any)
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
    }
    
    
    
    @IBAction func confirmPassword(_ sender: Any)
    {
        
     
    }
    
  
    func invalidName(_ value: String)-> String?
    {
        let expresionRegular = "^[A-Za-z]+(?:\\s[A-Za-z]+)*$"

        let predicate = NSPredicate(format: "SELF MATCHES %@", expresionRegular)

        if !predicate.evaluate(with: value)
        {
            return "Debe contener solo letras"
        }

        return nil
    }
    
    func invalidNumber(_ value: String)-> String?
    {
        let expresionRegular = "^[0-9]+$"

        let predicate = NSPredicate(format: "SELF MATCHES %@", expresionRegular)

        if !predicate.evaluate(with: value)
        {
            return "Debe contener solo numeros"
        }

        return nil
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
        
        if containsUpperCase(value)
        {
            return "Debe tener al menos una mayuscula"
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
    
    
    
    @IBAction func submitRegister(_ sender: Any)
    {
        postApi()
    }
    
    func postApi()
    {

        let url = URL(string: "https://securebot.ninja/api/v1/register")!
        
        guard url != nil else
        {
            print("error")
            return
        }

        var request = URLRequest(url: url,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10)
        request.httpMethod = "POST"
        
        let nombre = nombreTF.text ?? ""
           let apellidoPaterno = apTF.text ?? ""
           let apellidoMaterno = amTF.text ?? ""
           let telefono = telefonoTF.text ?? ""
           let email = emailTF.text ?? ""
           let password = passwordTF.text ?? ""
          

           let requestBody: [String: Any] = [
               "name": nombre,
               "ap_paterno": apellidoPaterno,
               "ap_materno": apellidoMaterno,
               "phone_number": telefono,
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
    
    @IBAction func regresar()
    {
        self.dismiss(animated: true)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nombreTF
        {
            apTF.becomeFirstResponder()
        }
        else if textField == apTF
        {
            apTF.resignFirstResponder()
        }
        
        if textField == apTF
        {
            amTF.becomeFirstResponder()
        }
        else if textField == amTF
        {
            amTF.resignFirstResponder()
        }
        
        if textField == amTF
        {
            telefonoTF.becomeFirstResponder()
        }
        else if textField == telefonoTF
        {
            telefonoTF.resignFirstResponder()
        }
        
        if textField == telefonoTF
        {
            emailTF.becomeFirstResponder()
        }
        else if textField == emailTF
        {
            emailTF.resignFirstResponder()
        }
       
        if textField == emailTF
        {
            passwordTF.becomeFirstResponder()
        }
        else if textField == passwordTF
        {
            passwordTF.becomeFirstResponder()
        }
        
        if textField == passwordTF
        {
            confirmpasswordTF.becomeFirstResponder()
        }
        else if textField == confirmpasswordTF
        {
            confirmpasswordTF.becomeFirstResponder()
        }
        
      
        
        
        return true
    }
 
}
