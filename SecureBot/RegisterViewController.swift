//
//  RegisterViewController.swift
//  SecureBot
//
//  Created by imac on 12/04/23.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
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
    var maxLenghts = [UITextField: Int]()
    let userData = UserData.sharedData()
    var hasErrors = true
    
    override func viewDidLoad() {
        nombreTF.delegate = self
        apTF.delegate = self
        amTF.delegate = self
        telefonoTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        confirmpasswordTF.delegate = self
        btnRegister.isEnabled = false
        btnRegister.layer.cornerRadius = 7.0
        
        nombreError.font = UIFont.systemFont(ofSize: 11)
        apError.font = UIFont.systemFont(ofSize: 11)
        amError.font = UIFont.systemFont(ofSize: 11)
        telError.font = UIFont.systemFont(ofSize: 11)
        emailError.font = UIFont.systemFont(ofSize: 11)
        passwordError.font = UIFont.systemFont(ofSize: 11)
        confirmPasswordError.font = UIFont.systemFont(ofSize: 11)
        
        maxLenghts[nombreTF] = 40
        maxLenghts[apTF] = 20
        maxLenghts[amTF] = 20
        maxLenghts[telefonoTF] = 10
        maxLenghts[passwordTF] = 20
        maxLenghts[confirmpasswordTF] = 20

        super.viewDidLoad()
    }
    
    //NOMBRE
    @IBAction func nameChanged(_ sender: Any) {
        if let nombre = nombreTF.text {
            if let errorMessage = invalidName(nombre) {
                nombreError.text = errorMessage
                nombreError.isHidden = false
                checkForm()
             
            } else {
                nombreError.isHidden = true
                checkForm()
            }
        }
    }
    
    //APELLIDO PATERNO
    @IBAction func apChanged(_ sender: Any) {
        if let ap_paterno = apTF.text {
            if let errorMessage = invalidLastName(ap_paterno) {
                apError.text = errorMessage
                apError.isHidden = false
                checkForm()
            } else {
                apError.isHidden = true
                checkForm()
            }
        }
    }
    
    //APELLIDO MATERNO
    @IBAction func amChanged(_ sender: Any) {
        if let ap_materno = amTF.text {
            if let errorMessage = invalidLastName(ap_materno) {
                amError.text = errorMessage
                amError.isHidden = false
                checkForm()
            } else {
                amError.isHidden = true
                checkForm()
            }
        }
    }
    
    //TEL
    @IBAction func telChanged(_ sender: Any) {
        if let tel = telefonoTF.text {
            if let errorMessage = invalidNumber(tel) {
                telError.text = errorMessage
                telError.isHidden = false
                checkForm()
            } else {
                telError.isHidden = true
                checkForm()
            }
        }
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
    @IBAction func paswordChanged(_ sender: Any) {
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
    
    
    @IBAction func confirmPassword(_ sender: Any) {
        if let password = confirmpasswordTF.text {
            if let errorMessage = invalidPasswordConfirmation(password) {
                confirmPasswordError.text = errorMessage
                confirmPasswordError.isHidden = false
                checkForm()
            } else {
                confirmPasswordError.isHidden = true
                checkForm()
            }
        }
    }
    
    func invalidName(_ value: String)-> String? {
        if value.count == 0 {
            return "Este campo es requerido"
        }
        
        let expresionRegular = "^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\\s]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", expresionRegular)

        if !predicate.evaluate(with: value) {
            return "Este campo sólo acepta letras"
        }

        return nil
    }
    
    func invalidLastName(_ value: String)-> String? {
        if value.count == 0 {
            return "Este campo es requerido"
        }
        
        let expresionRegular = "^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", expresionRegular)

        if !predicate.evaluate(with: value) {
            return "Este campo sólo acepta letras"
        }

        return nil
    }
    
    func invalidNumber(_ value: String)-> String? {
        if value.count == 0 {
            return "Este campo es requerido"
        }
        
        if value.count < 10 {
            return "Este campo debe tener al menos 10 caracteres"
        }

        return nil
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
        
        if containsDigit(value) {
            return "Este campo debe contener al menos un dígito"
        }
        
        if containsLowerCase(value) {
            return "Este campo debe contener al menos una minúscula"
        }
        
        if containsUpperCase(value) {
            return "Este campo debe contener al menos una mayúscula"
        }
        
        if containsSpecialCharacter(value) {
            return "Este campo debe contener al menos un caracter especial (!@#$%^&()-+)"
        }
                
        return nil
    }
    
    func invalidPasswordConfirmation(_ value: String)-> String? {
        if value.count == 0 {
            return "Este campo es requerido"
        }
        
        if self.passwordTF.text! != value {
            return "Las contraseñas no coinciden"
        }
 
        return nil
    }
    
    func containsDigit(_ value: String) -> Bool {
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsLowerCase(_ value: String) -> Bool {
        let reqularExpression = ".*[a-z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsUpperCase(_ value: String) -> Bool {
        let reqularExpression = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsSpecialCharacter(_ value: String) -> Bool {
        let reqularExpression = ".*[!@#$%^&()-+]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    
    @IBAction func submitRegister(_ sender: Any) {
        register()
    }
    
    func register() {
        let url = URL(string: "https://securebot.ninja/api/v1/register")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        
        let nombre = nombreTF.text!
        let apellidoPaterno = apTF.text!
        let apellidoMaterno = amTF.text!
        let telefono = telefonoTF.text!
        let email = emailTF.text!
        let password = passwordTF.text!
          
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
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Respuesta: \(responseJSON)")
                    
                    DispatchQueue.main.async {
                        self.hasErrors = false
                        
                        self.userData.name = nombre
                        self.userData.ap_paterno = apellidoPaterno
                        self.userData.ap_materno = apellidoMaterno
                        self.userData.phone_number = telefono
                        self.userData.email = email
                    }
                    
                } catch {
                    print("Error al convertir la respuesta a JSON: \(error)")
                }
            } else {
                DispatchQueue.main.async {
                    let error = UIAlertController(title: "Error", message: "El correo electrónico ya está en uso", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Aceptar", style: .default)
                    error.addAction(ok)
                    self.present(error, animated: true)
                }
            }
        }
        
        task.resume()
    }
    
    @IBAction func regresar() {
        self.dismiss(animated: true)

    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "sgRegister" {
            if !hasErrors {
                return true
            }
            
            return false
        }
            
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nombreTF {
            apTF.becomeFirstResponder()
        } else if textField == apTF {
            apTF.resignFirstResponder()
        }
        
        if textField == apTF {
            amTF.becomeFirstResponder()
        } else if textField == amTF {
            amTF.resignFirstResponder()
        }
        
        if textField == amTF {
            telefonoTF.becomeFirstResponder()
        } else if textField == telefonoTF {
            telefonoTF.resignFirstResponder()
        }
        
        if textField == telefonoTF {
            emailTF.becomeFirstResponder()
        } else if textField == emailTF {
            emailTF.resignFirstResponder()
        }
       
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            passwordTF.becomeFirstResponder()
        }
        
        if textField == passwordTF {
            confirmpasswordTF.becomeFirstResponder()
        } else if textField == confirmpasswordTF {
            confirmpasswordTF.becomeFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLenght = maxLenghts[textField] ?? Int.max
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
    
        return newString.length <= maxLenght
    }
 
    func checkForm() {
        if nombreError.isHidden && apError.isHidden && amError.isHidden && telError.isHidden && emailError.isHidden && passwordError.isHidden && confirmPasswordError.isHidden {
            btnRegister.isEnabled = true
        
        } else {
            btnRegister.isEnabled = false
            

        }
    }
}
