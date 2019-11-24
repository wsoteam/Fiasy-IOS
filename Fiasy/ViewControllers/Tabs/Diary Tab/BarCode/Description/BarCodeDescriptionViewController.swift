//
//  BarCodeDescriptionViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/1/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class BarCodeDescriptionViewController: UIViewController {
    
    // MARK: - Properties -
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Action -
    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true)
    }
}
