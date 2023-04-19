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
    
    @IBOutlet weak var btncontraseña: UIButton!
    override func viewDidLoad() {
        getUser()
        super.viewDidLoad()
        
        diseño()
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
                        }
                    }
                } catch {
                    print("Error al convertir la respuesta a JSON: \(error)")
                }
            }
        }
        
        task.resume()
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
}
