//
//  CarrosViewController.swift
//  SecureBot
//
//  Created by imac on 20/04/23.
//

import UIKit

class CarrosViewController: UIViewController {
    @IBOutlet weak var srcCarros: UIScrollView!
    var carros: [Carro] = [Carro(name: "Almacen", descripcion: "Ver rutas"),Carro(name: "Linea 5", descripcion: "Ver maquinas")]
    let userData = UserData.sharedData()

    override func viewDidLoad() {
        super.viewDidLoad()
        dibujarPersonajes()
        hasEnterprise()
        isInProcess()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userData.hasEnterprise == false || userData.isInProcess == true {
            performSegue(withIdentifier: "sgNoEnterprise", sender: self)
        }
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
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let boton =  sender as! UIButton
        let vc = segue.destination as! SensoresViewController
        
        vc.sensores = carros[boton.tag].sensores
    }*/
    
    func consultarServicio()
    {
    
        
    }
    

    func dibujarPersonajes()
    {
           var y = 10
           for i in 0..<carros.count {
               let vista = UIView(frame: CGRect(x: 10, y: y, width: Int(srcCarros.frame.width - 20), height: 80))
               vista.backgroundColor = .white
               
               let imagen = UIImageView(frame: CGRect(x: 5, y: 25, width: 76.6, height: 45))
               imagen.image = UIImage(named: "carsrc-PhotoRoom.png-PhotoRoom.png")
              
               
               let lblNombre = UILabel(frame: CGRect(x: 100, y: 5, width: Int(vista.frame.width - 105), height: 30))
               lblNombre.text = carros[i].name
               lblNombre.font = .boldSystemFont(ofSize: 22)
               lblNombre.minimumScaleFactor = 0.5
               lblNombre.adjustsFontSizeToFitWidth = true
               
               let lblDescripcion = UILabel(frame: CGRect(x: 100, y: 37, width: Int(vista.frame.width - 105), height: 28))
               lblDescripcion.text = carros[i].descripcion
               lblDescripcion.font = .systemFont(ofSize: 17)
               
        
               
               let boton = UIButton(frame: CGRect(x: 0, y: 0, width: vista.frame.width, height: vista.frame.height))
               boton.tag = i
               boton.addTarget(self, action: #selector(seleccionarPersonaje(sender:)), for: .touchDown)
               
               vista.addSubview(imagen)
               vista.addSubview(lblNombre)
               vista.addSubview(lblDescripcion)
             
               vista.addSubview(boton)
               srcCarros.addSubview(vista)
               y += 90
           }
           srcCarros.contentSize = CGSize(width: 0, height: y)
       }
    @objc func seleccionarPersonaje(sender: UIButton)
    {
        print(carros[sender.tag].sensores)
        self.performSegue(withIdentifier: "sgSensores", sender: sender)
    }
}
