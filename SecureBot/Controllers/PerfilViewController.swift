//
//  PerfilViewController.swift
//  SecureBot
//
//  Created by imac on 13/04/23.
//

import UIKit

class PerfilViewController: UIViewController, UITextFieldDelegate {
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
    var emailUser = ""
    var phoneUser = ""
    var maxLenghts = [UITextField: Int]()
    
    @IBOutlet weak var btncontraseña: UIButton!
    override func viewDidLoad() {
        getUser()
        getCompany()
        diseño()
        
        TFcorreo.delegate = self
        TFtelefono.delegate = self
        btncambiarCorreo.isEnabled = false
        btncambiarTelefono.isEnabled = false
        maxLenghts[TFtelefono] = 10
        
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func diseño() {
        salir.layer.cornerRadius = 7.0
        btncambiarNombre.layer.cornerRadius = 7.0
        btncambiarCorreo.layer.cornerRadius = 7.0
        btncambiarTelefono.layer.cornerRadius = 7.0
        btncontraseña.layer.cornerRadius = 7.0
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
                            self.emailUser = email
                            self.phoneUser = phone_number
                        }
                    }
                } catch {
                    print("Error al convertir la respuesta a JSON: \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    func getCompany() {
        let url = URL(string: "https://securebot.ninja/api/v1/company/user")!
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
                       let name = dataDict["name"] as? String {
                        DispatchQueue.main.async {
                            self.TFempresa.text = name
                        }
                    }
                } catch {
                    print("Error al convertir la respuesta a JSON: \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    //FUNCION Validar nombre
    func invalidName2(_ value: String)-> Bool? {
        if value.count == 0 {
            return true
        }
        
        let expresionRegular = "^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\\s]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", expresionRegular)
        
        if !predicate.evaluate(with: value) {
            return true
        }
        
        return nil
    }
    
    
    func invalidLastName(_ value: String)-> Bool? {
        if value.count == 0 {
            return true
        }
        
        let expresionRegular = "^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", expresionRegular)
        
        if !predicate.evaluate(with: value) {
            return true
        }
        
        return nil
    }
    
    func invalidEmail(_ value: String)-> Bool? {
        if value.count == 0 {
            return true
        }
        
        let expresionRegular = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", expresionRegular)
        
        if !predicate.evaluate(with: value) {
            return true
        }
        
        return nil
    }
    
    func invalidNumber(_ value: String)-> Bool? {
        if value.count == 0 {
            return true
        }
        
        if value.count < 10 {
            return true
        }
        
        return nil
    }
    
    func invalidPassword(_ value: String)-> Bool? {
        if value.count == 0 {
            return true
        }
        
        if value.count < 8 {
            return true
        }
        
        if containsDigit(value) {
            return true
        }
        
        if containsLowerCase(value) {
            return true
        }
        
        if containsUpperCase(value) {
            return true
        }
        
        if containsSpecialCharacter(value)
        {
            return true
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
    
    
    
    @IBAction func changeEmail(_ sender: Any){
        if let email = TFcorreo.text {
            if  emailUser == email {
                btncambiarCorreo.isEnabled = false
            } else {
                btncambiarCorreo.isEnabled = true
            }
        }
    }
    
    @IBAction func changeTel(_ sender: Any) {
        if let phone = TFtelefono.text {
            if  phoneUser == phone {
                btncambiarTelefono.isEnabled = false
            } else {
                btncambiarTelefono.isEnabled = true
            }
        }
    }
    
    @IBAction func changeCorreo(_ sender: Any) {
        let alerta = UIAlertController(title: "Cambiar correo", message: "¿Estás seguro de que quieres cambiar tu correo? Si lo haces, no podrás cambiar tu cuenta hasta que verifiques tu nuevo correo.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Cambiar", style: .destructive) { [ weak self ] _ in
            guard let self = self else { return }
            updateEmail()
            self.viewDidLoad()
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alerta.addAction(cancel)
        alerta.addAction(ok)
        self.present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func changePhone(_ sender: Any) {
        let alerta = UIAlertController(title: "Cambiar teléfono", message: "¿Estás seguro de que quieres cambiar tu teléfono? Si lo haces, no podrás cambiar tu cuenta hasta que verifiques tu nuevo teléfono.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Cambiar", style: .destructive) { [ weak self ] _ in
            guard let self = self else { return }
            updatePhone()
            self.viewDidLoad()
        }
        
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alerta.addAction(cancel)
        alerta.addAction(ok)
        self.present(alerta, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLenght = maxLenghts[textField] ?? Int.max
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
    
        return newString.length <= maxLenght
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
        
        let  contras = invalidPassword(newPassowrd)
      
        if contras == nil {
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
    }
    
    //CAMBIAR NOMBRE
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
        
        let nombre = invalidName2(name)
        let apellidopaterno = invalidLastName(ap_paterno)
        let apellidomaterno = invalidLastName(ap_materno)
        
        if nombre == nil && apellidomaterno == nil && apellidopaterno == nil {
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
                        }
                        catch {
                            print("Error al convertir la respuesta a JSON: \(error)")
                        }
                    }
                    else {
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
        } else {
            let error = UIAlertController(title: "Error", message: "Alguno de tus campos es inválido. Recuerda que estos sólo pueden contener letras.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Aceptar", style: .default)
            error.addAction(ok)
            self.present(error, animated: true)
            invalido = true
        }
    }
    
    func updateEmail() {
        let url = URL(string: "https://securebot.ninja/api/v1/user/email")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "PUT"
        var null = false
        var invalido = false
        
        if let correo = TFcorreo.text {
            if correo.count == 0 {
                let error = UIAlertController(title: "Error", message: "No has proporcionado ningún email", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Aceptar", style: .default)
                error.addAction(ok)
                self.present(error, animated: true)
                null = true
            }
        }
        
        let email = invalidEmail(TFcorreo.text!)
        
        if email == nil {
            let correo = TFcorreo.text!
              
            let requestBody: [String: Any] = [
                "email": correo
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
                                self.userData.token = ""
                                self.userData.rememberMe = false
                                self.performSegue(withIdentifier: "sgLogout", sender: self)
                            }
                        }
                        catch {
                            print("Error al convertir la respuesta a JSON: \(error)")
                        }
                    }
                    else {
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
                            } else {
                                DispatchQueue.main.async {
                                    let error = UIAlertController(title: "Error", message: "El correo electrónico ya está en uso", preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "Aceptar", style: .default)
                                    error.addAction(ok)
                                    self.present(error, animated: true)
                                    self.viewDidLoad()
                                }
                            }
                        } catch {
                            print("Error al convertir la respuesta a JSON: \(error)")
                        }
                    }
                }
            }
            
            task.resume()
        } else {
            let error = UIAlertController(title: "Error", message: "Correo electrónico inválido.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Aceptar", style: .default)
            error.addAction(ok)
            self.present(error, animated: true)
            invalido = true
            self.viewDidLoad()
        }
    }
    
    func updatePhone() {
        let url = URL(string: "https://securebot.ninja/api/v1/user/phone")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "PUT"
        var null = false
        var invalido = false
        
        if let phone = TFtelefono.text {
            if phone.count == 0 {
                let error = UIAlertController(title: "Error", message: "No has proporcionado ningún teléfono", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Aceptar", style: .default)
                error.addAction(ok)
                self.present(error, animated: true)
                null = true
                self.viewDidLoad()
            }
        }
        
        let telefono = invalidNumber(TFtelefono.text!)
        
        if telefono == nil {
            let phone = TFtelefono.text!
              
            let requestBody: [String: Any] = [
                "phone_number": phone
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
                            
                            if let jsonDict = responseJSON as? [String: Any],
                               let signedRoute = jsonDict["url"] as? String {
                                DispatchQueue.main.async {
                                    self.userData.token = ""
                                    self.userData.rememberMe = false
                                    self.userData.signedRoute = signedRoute
                                    self.performSegue(withIdentifier: "sgCode", sender: self)
                                }
                            }
                        }
                        catch {
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
        } else {
            let error = UIAlertController(title: "Error", message: "Teléfono inválido. Recuerda que debe contener 10 dígitos.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Aceptar", style: .default)
            error.addAction(ok)
            self.present(error, animated: true)
            invalido = true
            self.viewDidLoad()
        }
    }
}
