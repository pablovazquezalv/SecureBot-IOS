//
//  SplashViewController.swift
//  SecureBot
//
//  Created by imac on 12/04/23.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var imvSplash: UIImageView!
    let userData = UserData.sharedData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imvSplash.frame.origin.y = view.frame.height
        imvSplash.frame.origin.x = (view.frame.width - imvSplash.frame.width)/2.0
    }
  
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveLinear) {
            self.imvSplash.frame.origin.y = (self.view.frame.height - self.imvSplash.frame.height)/2.0
        } completion: { res in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                if self.userData.rememberMe == false {
                    self.performSegue(withIdentifier: "sgSplash", sender: nil)
                } else if self.userData.rememberMe == true && self.userData.token.count > 1 {
                    self.performSegue(withIdentifier: "sgRememberMe", sender: self)
                } else {
                    self.performSegue(withIdentifier: "sgSplash", sender: nil)
                }
            }
        }
    }
}
