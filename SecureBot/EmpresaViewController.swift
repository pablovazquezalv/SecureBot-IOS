//
//  EmpresaViewController.swift
//  SecureBot
//
//  Created by imac on 20/04/23.
//

import UIKit

class EmpresaViewController: UIViewController {

    
    
    @IBOutlet weak var btnCrearEmpresa: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnCrearEmpresa.layer.cornerRadius = 7.0
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnCrearEmpresa(_ sender: Any)
    {
        if let url = URL(string: "https://securebot.tech/mi-empresa")
        {
                UIApplication.shared.open(url)
            }
    }
    

}
