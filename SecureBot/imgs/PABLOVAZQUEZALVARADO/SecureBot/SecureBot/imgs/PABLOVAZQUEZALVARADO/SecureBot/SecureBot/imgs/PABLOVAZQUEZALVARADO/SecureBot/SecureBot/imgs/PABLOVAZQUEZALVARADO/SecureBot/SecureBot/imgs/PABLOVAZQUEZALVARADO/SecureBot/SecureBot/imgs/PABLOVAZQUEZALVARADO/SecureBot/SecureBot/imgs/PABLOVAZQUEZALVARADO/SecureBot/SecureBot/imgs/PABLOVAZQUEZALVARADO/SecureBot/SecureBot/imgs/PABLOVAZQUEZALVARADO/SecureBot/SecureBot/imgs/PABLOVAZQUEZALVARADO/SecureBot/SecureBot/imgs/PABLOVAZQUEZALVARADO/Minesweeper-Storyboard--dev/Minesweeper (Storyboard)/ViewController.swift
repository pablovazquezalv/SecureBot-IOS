//
//  ViewController.swift
//  Minesweeper (Storyboard)
//
//  Created by Student on 4/23/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    
    
    
    @IBAction func easyButton(_ sender: UIButton) {
        let firstVC = self.storyboard?.instantiateViewController(withIdentifier: "easyView") as! easyView
                self.navigationController?.pushViewController(firstVC, animated: true)
    }
    
    @IBAction func mediumButton(_ sender: UIButton) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "mediumView") as! mediumView
                self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
 
    //hides bar
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
}

