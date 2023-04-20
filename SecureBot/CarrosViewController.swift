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


    override func viewDidLoad()
    {
        super.viewDidLoad()
        dibujarPersonajes()
        
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let boton =  sender as! UIButton
        let vc = segue.destination as! SensoresViewController
        
        vc.sensores = carros[boton.tag].sensores
    }
    
    func consultarServicio()
    {
    
        
    }
    

    func dibujarPersonajes()
    {
           var y = 10
           for i in 0..<carros.count {
               let vista = UIView(frame: CGRect(x: 10, y: y, width: Int(srcCarros.frame.width - 20), height: 100))
               vista.backgroundColor = .white
               
               let imagen = UIImageView(frame: CGRect(x: 5, y: 5, width: 90, height: 66))
               imagen.image = UIImage(named: "carsrc-PhotoRoom.png-PhotoRoom.png")
              
               
               let lblNombre = UILabel(frame: CGRect(x: 100, y: 5, width: Int(vista.frame.width - 105), height: 30))
               lblNombre.text = carros[i].name
               lblNombre.font = .boldSystemFont(ofSize: 22)
               lblNombre.minimumScaleFactor = 0.5
               lblNombre.adjustsFontSizeToFitWidth = true
               
               let lblEspecie = UILabel(frame: CGRect(x: 100, y: 37, width: Int(vista.frame.width - 105), height: 28))
               lblEspecie.text = carros[i].descripcion
               lblEspecie.font = .systemFont(ofSize: 17)
               
        
               
               let boton = UIButton(frame: CGRect(x: 0, y: 0, width: vista.frame.width, height: vista.frame.height))
               boton.tag = i
               boton.addTarget(self, action: #selector(seleccionarPersonaje(sender:)), for: .touchDown)
               
               vista.addSubview(imagen)
               vista.addSubview(lblNombre)
               vista.addSubview(lblEspecie)
             
               vista.addSubview(boton)
               srcCarros.addSubview(vista)
               y += 110
           }
           srcCarros.contentSize = CGSize(width: 0, height: y)
       }
    @objc func seleccionarPersonaje(sender: UIButton)
    {
        print(carros[sender.tag].sensores)
        self.performSegue(withIdentifier: "sgSensores", sender: sender)
    }
}
