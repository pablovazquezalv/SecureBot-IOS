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
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
            self.consultarServicio()
           }
    }
    
    func consultarServicio()
        {
            let conexion = URLSession(configuration: .default)
            let url = URL(string: "https://securebot.ninja/api/v1/ultimoDato")!
            let token = userData.token
            var urlRequest = URLRequest(url: url)
            urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(token)"]
            
            conexion.dataTask(with: urlRequest) {datos, respuesta, error in
                
                do{
                    let json = try JSONSerialization.jsonObject(with: datos!,options: []) as? [Any]
                    if let resultados = json {
                        self.sensor.removeAll()
                        for carro in  resultados
                        {
                            if let datos = carro as? [String:Any]
                            {
                        
                                self.sensor.append(Sensor(nombre:  datos["tipo"] as! String, valor: datos["valores"] as! String))                            }
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
            vista.backgroundColor = .white
            
            
            let nombre = UILabel(frame: CGRect(x: 5, y: 5, width: vista.frame.width - 10, height: 25))
            nombre.text = sensor[i].nombre
            nombre.font = .boldSystemFont(ofSize: 25)
            nombre.adjustsFontSizeToFitWidth = true
            nombre.minimumScaleFactor = 0.5
            
            let fecha = UILabel(frame: CGRect(x: 5, y: 30, width: vista.frame.width - 10, height: 20))
            fecha.text = sensor[i].valor
            fecha.font = .systemFont(ofSize: 30)
            fecha.adjustsFontSizeToFitWidth = true
            fecha.minimumScaleFactor = 0.5
            
            let spinner = UIProgressView(progressViewStyle: .default)
            spinner.center = self.view.center
            spinner.progressTintColor = UIColor.red
            spinner.trackTintColor = UIColor.lightGray
            let valor = Float(sensor[i].valor) ?? 0.0
            let progress = valor / 100.0
            spinner.progress = progress
                        
            spinner.center = CGPoint(x: vista.frame.width - spinner.frame.width/2 - 5, y: vista.frame.height/2)
                        vista.addSubview(spinner)
           
            
            vista.addSubview(nombre)
            vista.addSubview(fecha)
            srcSensores.addSubview(vista)
            y += 80
        }
        
        srcSensores.contentSize = CGSize(width: 0, height: y)
    }
    

}
