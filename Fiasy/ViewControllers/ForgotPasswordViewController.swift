//
//  ForgotPasswordViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/1/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func forgotPasswordTapped(_ sender: Any) {
      
                    Auth.auth().sendPasswordReset(withEmail: passwordField.text!, completion: { (error) in
                if error != nil{
                 
                    let alertController = UIAlertController(title: "Ошибка", message: error?.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }else {
                   
                    
                    let alertController = UIAlertController(title: "Письмо выслано", message: error?.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                }
            })
      
        
        
        
    }

}
