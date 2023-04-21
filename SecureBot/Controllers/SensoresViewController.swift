//
//  SensoresViewController.swift
//  SecureBot
//
//  Created by imac on 20/04/23.
//

import UIKit

class SensoresViewController: UIViewController {

    
    var sensor:[Sensor] = []
    let userData = UserData.sharedData()
    @IBOutlet weak var srcSensores: UIScrollView!
    var nombre:[String] = []
    var codigos:[String] = []
    var contador = 0

    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        consultarServicio()
    }
    
    func consultarServicio()
        {
            let conexion = URLSession(configuration: .default)
            let url = URL(string: "https://securebot.ninja/api/v1/verSensores/6441eb13593121c1eda9830c")!
            let token = userData.token
            var urlRequest = URLRequest(url: url)
            urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(token)"]
            
            conexion.dataTask(with: urlRequest) {datos, respuesta, error in
                
                do{
                    let json = try JSONSerialization.jsonObject(with: datos!,options: []) as? [Any]
                    if let resultados = json {
                        for carro in  resultados
                        {
                            if let datos = carro as? [String:Any]
                            {
                                self.sensor.append(Sensor(nombre: datos["nombre"] as! String))
                            }
                        }
                        DispatchQueue.main.async {
                            self.dibujarEpisodios()
                        }
                        
                    }
                }catch
                {
                    print("errores")
                }
            }.resume()
        }
    func hasEnterprise() {
        let url = URL(string: "https://securebot.ninja/api/v1/user/company")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        
        let token = userData.token
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error al realizar la solicitud")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)!
            if responseString == "true" {
                self.userData.hasEnterprise = true
                print("Si \(self.userData.hasEnterprise)")
            } else {
                self.userData.hasEnterprise = false
                print("No \(self.userData.hasEnterprise)")
            }
        }
        
        task.resume()
    }
    
    func isInProcess() {
        let url = URL(string: "https://securebot.ninja/api/v1/user/request")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        
        let token = userData.token
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error al realizar la solicitud")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)!
            if responseString == "true" {
                self.userData.isInProcess = true
                print("Si \(self.userData.isInProcess)")
            } else {
                self.userData.isInProcess = false
                print("No \(self.userData.isInProcess)")
            }
        }
        
        task.resume()
    }
        func dibujarEpisodios()
    {
        var y = 10
        for i in 0..<sensor.count
        {
            let vista = UIView(frame: CGRect(x: 10, y: y, width: Int(srcSensores.frame.width) - 20, height: 70))
            vista.backgroundColor = .brown
            
            
            let nombre = UILabel(frame: CGRect(x: 5, y: 5, width: vista.frame.width - 10, height: 25))
            nombre.text = sensor[i].nombre
            nombre.font = .boldSystemFont(ofSize: 25)
            nombre.adjustsFontSizeToFitWidth = true
            nombre.minimumScaleFactor = 0.5
            
            let fecha = UILabel(frame: CGRect(x: 5, y: 30, width: vista.frame.width - 10, height: 20))
            fecha.text = "20"
            fecha.font = .systemFont(ofSize: 30)
            fecha.adjustsFontSizeToFitWidth = true
            fecha.minimumScaleFactor = 0.5
            
           
            
            vista.addSubview(nombre)
            vista.addSubview(fecha)
            srcSensores.addSubview(vista)
            y += 80
        }
        
        srcSensores.contentSize = CGSize(width: 0, height: y)
    }
    

}
