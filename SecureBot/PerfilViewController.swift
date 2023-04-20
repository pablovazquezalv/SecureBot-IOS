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
    
    @IBOutlet weak var TFnombre: UITextField!
    @IBOutlet weak var TFempresa: UITextField!
    @IBOutlet weak var TFcorreo: UITextField!
    @IBOutlet weak var TFtelefono: UITextField!
    @IBOutlet weak var lblNombre: UILabel!
    
    let userData = UserData.sharedData()
    var user: User = User(id: 0, name: "", ap_paterno: "", ap_materno: "", email: "", phone_number: "", rol_id: 4)
    var userName = ""
    var apUser = ""
    var amUser = ""
    
    @IBOutlet weak var btncontraseña: UIButton!
    override func viewDidLoad() {
        getUser()
        diseño()
        
        super.viewDidLoad()
    }
    
    func getUser() {
        let url = URL(string: "https://securebot.ninja/api/v1/user")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        
        let token = userData.token
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
                       let dataDict = jsonDict["data"] as? [String: Any],
                       let name = dataDict["name"] as? String, let ap_paterno = dataDict["ap_paterno"] as? String, let ap_materno = dataDict["ap_materno"] as? String, let email = dataDict["email"] as? String, let phone_number = dataDict["phone_number"] as? String {
                        DispatchQueue.main.async {
                            self.lblNombre.text = name + " " + ap_paterno + " " + ap_materno
                            self.TFnombre.text = name + " " + ap_paterno + " " + ap_materno
                            self.TFcorreo.text = email
                            self.TFtelefono.text = phone_number
                            self.userName = name
                            self.apUser = ap_paterno
                            self.amUser = ap_materno
                        }
                    }
                } catch {
                    print("Error al convertir la respuesta a JSON: \(error)")
                }
            }
        }
        
        task.resume()
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
    
    @IBAction func changed(_ sender: UIButton) {
        let alerta = UIAlertController(title: "Cambiar password", message: "Escribe tu contraseña:", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Cambiar", style: .destructive) { [ weak self ] _ in
            guard let self = self else { return }
            if let password = alerta.textFields?.first?.text,
               let new_password = alerta.textFields?[1].text,
               let confirm_password = alerta.textFields?[2].text {
                if new_password != confirm_password {
                    let error = UIAlertController(title: "Error", message: "Las contraseñas no coinciden", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "Aceptar", style: .default)
                    error.addAction(ok)
                    self.present(error, animated: true)
                } else {
                    changePassword(password: password, newPassowrd: new_password)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alerta.addTextField { textField in
            textField.placeholder = "Ingresa tu contraseña actual"
            textField.isSecureTextEntry = true
        }
        
        alerta.addTextField { textField in
            textField.placeholder = "Ingresa tu nueva contraseña"
            textField.isSecureTextEntry = true
        }
        
        alerta.addTextField { textField in
            textField.placeholder = "Reingresa la contraseña"
            textField.isSecureTextEntry = true
        }
        
        alerta.addAction(cancel)
        alerta.addAction(ok)
        self.present(alerta, animated: true, completion: nil)
    }
    
    
    @IBAction func changeName(_ sender: UIButton) {
        let alerta = UIAlertController(title: "Cambiar nombre", message: "Llena los campos:", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Actualizar", style: .destructive) { [ weak self ] _ in
            guard let self = self else { return }
            if let name = alerta.textFields?.first?.text,
               let ap_paterno = alerta.textFields?[1].text,
               let ap_materno = alerta.textFields?[2].text {
                changeNames(name: name, ap_paterno: ap_paterno, ap_materno: ap_materno)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alerta.addTextField { textField in
            textField.placeholder = "Ingresa tu nombre"
            textField.text = self.userName
        }
        
        alerta.addTextField { textField in
            textField.placeholder = "Ingresa tu apellido paterno"
            textField.text = self.apUser
        }
        
        alerta.addTextField { textField in
            textField.placeholder = "Reingresa tu apellido materno"
            textField.text = self.amUser
        }
        
        alerta.addAction(cancel)
        alerta.addAction(ok)
        self.present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func changeEmail(_ sender: Any)
    {
    }
    
    @IBAction func changeTel(_ sender: Any) {
    }
    
    func diseño() {
        salir.layer.cornerRadius = 7.0
        btncambiarNombre.layer.cornerRadius = 7.0
        btncambiarCorreo.layer.cornerRadius = 7.0
        btncambiarTelefono.layer.cornerRadius = 7.0
        btncontraseña.layer.cornerRadius = 7.0
    }
    
    @IBAction func changeCorreo(_ sender: Any) {
    }
    
    @IBAction func changePhone(_ sender: Any) {
    }
    
    @IBAction func logout(_ sender: Any) {
        let url = URL(string: "https://securebot.ninja/api/v1/logout")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        
        let token = userData.token
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
                    
                    DispatchQueue.main.async {
                        self.userData.token = ""
                        self.userData.rememberMe = false
                        self.performSegue(withIdentifier: "sgLogout", sender: self)
                    }
                } catch {
                    print("Error al convertir la respuesta a JSON: \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    func changePassword(password: String = "", newPassowrd: String = "") {
        let url = URL(string: "https://securebot.ninja/api/v1/user/password")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "PUT"
        var null = false
        var invalido = false
        
        if password == "" || newPassowrd == "" {
            let error = UIAlertController(title: "Error", message: "Debes rellenar todos los campos", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Aceptar", style: .default)
            error.addAction(ok)
            self.present(error, animated: true)
            null = true
        }
        
        
        if let invalid = invalidPassword(newPassowrd) {
            let error = UIAlertController(title: "Error", message: "Contraseña inválida. Recuerda que por motivos de seguridad todas las contraseñas deben incluir por lo menos un dígito, una letra mayúscula y un caracter especial (!@#$%^&()-+), además de ser mayores a 8 caracteres.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Aceptar", style: .default)
            error.addAction(ok)
            self.present(error, animated: true)
            invalido = true
        }
        
        let contraseña = password
        let nuevo_password = newPassowrd
          
        let requestBody: [String: Any] = [
            "password": contraseña,
            "new_password": nuevo_password
        ]
        
        do {
            let token = userData.token
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
            
            if !invalido || !null {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Respuesta: \(responseJSON)")
                        
                        DispatchQueue.main.async {
                            let alerta = UIAlertController(title: "Contraseña cambiada", message: "Tu contraseña ha sido actualizada satisfactoriamente.", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "Aceptar", style: .default)
                            alerta.addAction(ok)
                            self.present(alerta, animated: true)
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
        }
        
        task.resume()
    }
    
    func changeNames(name: String = "", ap_paterno: String = "", ap_materno: String = "") {
        let url = URL(string: "https://securebot.ninja/api/v1/user/names")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "PUT"
        var null = false
        var invalido = false
        
        if name == "" || ap_paterno == "" || ap_materno == "" {
            let error = UIAlertController(title: "Error", message: "Debes rellenar todos los campos", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Aceptar", style: .default)
            error.addAction(ok)
            self.present(error, animated: true)
            null = true
        }
        
        if let invalidN = invalidName(name),
           let invalidP = invalidLastName(ap_paterno), let invalidM = invalidLastName(ap_materno) {
            let error = UIAlertController(title: "Error", message: "Alguno de tus campos es inválido. Recuerda que estos sólo pueden contener letras.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Aceptar", style: .default)
            error.addAction(ok)
            self.present(error, animated: true)
            invalido = true
        }
        
        let nombre = name
        let apPaterno = ap_paterno
        let apMaterno = ap_materno
          
        let requestBody: [String: Any] = [
            "name": nombre,
            "ap_paterno": apPaterno,
            "ap_materno": apMaterno
        ]
        
        do {
            let token = userData.token
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
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
            
            if !invalido || !null {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Respuesta: \(responseJSON)")
                        
                        DispatchQueue.main.async {
                            let alerta = UIAlertController(title: "Nombre cambiado", message: "Tu nombre ha sido actualizado satisfactoriamente.", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "Aceptar", style: .default)
                            alerta.addAction(ok)
                            self.present(alerta, animated: true)
                            self.viewDidLoad()
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
        }
        
        task.resume()
    }
}
