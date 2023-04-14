//
//  TelefonoViewController.swift
//  SecureBot
//
//  Created by imac on 12/04/23.
//

import UIKit

class TelefonoViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var numberunoTF: UITextField!
    @IBOutlet weak var numberdosTF: UITextField!
    @IBOutlet weak var numbertresTF: UITextField!
    @IBOutlet weak var numbercuatroTF: UITextField!
    
    override func viewDidLoad()
    {
        
        numberunoTF.delegate = self
        numberdosTF.delegate = self
        numbertresTF.delegate = self
        numbercuatroTF.delegate = self
        super.viewDidLoad()
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == numberunoTF
        {
            numberdosTF.becomeFirstResponder()
        }
        else if textField == numberdosTF
        {
            numberdosTF.resignFirstResponder()
        }
        if textField == numberdosTF
        {
            numbertresTF.becomeFirstResponder()
        }
        else if textField == numbertresTF
        {
            numbertresTF.resignFirstResponder()
        }
        
        if textField == numbertresTF
        {
            numbercuatroTF.becomeFirstResponder()
        }
        else if textField == numbercuatroTF
        {
            numbercuatroTF.resignFirstResponder()
        }
        return true
    }
   

}
