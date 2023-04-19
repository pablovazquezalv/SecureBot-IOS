//
//  TelefonoViewController.swift
//  SecureBot
//
//  Created by imac on 12/04/23.
//

import UIKit

class TelefonoViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var numberunoTF: UITextField!
    @IBOutlet weak var numberdosTF: UITextField!
    @IBOutlet weak var numbertresTF: UITextField!
    @IBOutlet weak var numbercuatroTF: UITextField!
    
    
    
    
    
    
    
    @IBOutlet weak var btnverificar: UIButton!
    var maxLenghts = [UITextField: Int]()
    let userData = UserData.sharedData()
    var hasErrors = true
    
    override func viewDidLoad() {
        btnverificar.layer.cornerRadius = 7.0

        numberunoTF.delegate = self
        numberdosTF.delegate = self
        numbertresTF.delegate = self
        numbercuatroTF.delegate = self
        btnverificar.isEnabled = false
        
        maxLenghts[numberunoTF] = 1
        maxLenghts[numberdosTF] = 1
        maxLenghts[numbertresTF] = 1
        maxLenghts[numbercuatroTF] = 1
        super.viewDidLoad()
    }
    
    @IBAction func verificarCuenta(_ sender: Any) {
        activarCuenta()
    }
    
    func activarCuenta() {
        let url = URL(string: userData.signedRoute)!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        
        let codigo = numberunoTF.text! + numberdosTF.text! + numbertresTF.text! + numbercuatroTF.text!
          
       let requestBody: [String: Any] = [
           "codigo": codigo,
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
                    
                    DispatchQueue.main.async {
                        self.hasErrors = false
                        self.performSegue(withIdentifier: "sgVerificar", sender: self)
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
                    } else {
                        DispatchQueue.main.async {
                            let error = UIAlertController(title: "Error", message: "Tienes que llenar cada uno de los campos", preferredStyle: .alert)
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
        if identifier == "sgVerificar" {
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
        if textField == numberunoTF {
            numberdosTF.becomeFirstResponder()
        } else if textField == numberdosTF {
            numberdosTF.resignFirstResponder()
        }
        
        if textField == numberdosTF {
            numbertresTF.becomeFirstResponder()
        } else if textField == numbertresTF {
            numbertresTF.resignFirstResponder()
        }
        
        if textField == numbertresTF {
            numbercuatroTF.becomeFirstResponder()
        } else if textField == numbercuatroTF {
            numbercuatroTF.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLenght = maxLenghts[textField] ?? Int.max
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
    
        return newString.length <= maxLenght
    }
    
    
    //TFNUMERO 1
    
    @IBAction func numerounoChange(_ sender: Any)
    {
       
    }
    
    
    @IBAction func numerodosChange(_ sender: Any)
    {
        
    }
    
    
    
    @IBAction func numerotresChange(_ sender: Any)
    {
       
    }
    
    @IBAction func numerocuatroChange(_ sender: Any) {
    }
    
    
    
}
