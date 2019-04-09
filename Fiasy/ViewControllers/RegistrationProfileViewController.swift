//
//  RegistrationProfileViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit




class RegistrationProfileViewController: UIViewController {

    @IBOutlet weak var centralView: UIView!
    @IBOutlet weak var everyDayButton: UIButton!
    @IBOutlet weak var viewGroup1: RadioButtonContainerView!
    @IBOutlet weak var optionAG3: RadioButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var blurView2: UIVisualEffectView!

    @IBOutlet weak var selectContentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        selectContentView.isHidden = true
        blurView.isHidden = true
        blurView2.isHidden = true

        everyDayButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        everyDayButton.titleLabel!.numberOfLines = 2//if you want unlimited number of lines put 0

        
       
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

    }
    
    @IBAction func lowAction(_ sender: Any) {
        
        selectContentView.isHidden = true
        blurView.isHidden = true
        blurView2.isHidden = false

    }
    
    
    @IBAction func everydayAction(_ sender: Any) {
        selectContentView.isHidden = false
        blurView.isHidden = false

    }
    
    @IBAction func nextAction(_ sender: Any) {
        
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        selectContentView.isHidden = true
        blurView.isHidden = true
        blurView2.isHidden = true


    }
    func setupGroup2() {
        viewGroup1.buttonContainer.delegate = self
        viewGroup1.buttonContainer.setEachRadioButtonColor {
            return RadioButtonColor(active: $0.tintColor , inactive: $0.tintColor)
        }
    }

}

extension RegistrationProfileViewController: RadioButtonDelegate {
    
    func radioButtonDidSelect(_ button: RadioButton) {
        print("Select: ", button.title(for: .normal)!)
    }
    
    func radioButtonDidDeselect(_ button: RadioButton) {
        print("Deselect: ",  button.title(for: .normal)!)
    }
}

