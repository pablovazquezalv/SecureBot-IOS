//
//  SensoresViewController.swift
//  SecureBot
//
//  Created by imac on 20/04/23.
//

import UIKit

class SensoresViewController: UIViewController {

    
    
    
    @IBOutlet weak var srcSensores: UIScrollView!
    var sensores:[String] = []
    var codigos:[String] = []
    var contador = 0

    
 

    
  
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        dibujarEpisodios()
    }
    

    func dibujarEpisodios()
    {
        var y = 10
        for i in 0..<sensores.count
        {
            let vista = UIView(frame: CGRect(x: 10, y: y, width: Int(srcSensores.frame.width) - 20, height: 70))
            vista.backgroundColor = .brown
            
            
            let nombre = UILabel(frame: CGRect(x: 5, y: 5, width: vista.frame.width - 10, height: 25))
            nombre.text = "no"
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
