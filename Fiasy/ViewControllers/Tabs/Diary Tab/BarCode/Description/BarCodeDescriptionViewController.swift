//
//  BarCodeDescriptionViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/1/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class BarCodeDescriptionViewController: UIViewController {
    
    // MARK: - Outlet's -
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleTitleLabel: UILabel!
    @IBOutlet weak var agreeButton: UIButton!
    
    // MARK: - Properties -
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        agreeButton.setTitle(LS(key: .BARCODE_TITLE_1), for: .normal)
        topLabel.text = LS(key: .BARCODE_TITLE_2)
        middleTitleLabel.text = LS(key: .BARCODE_TITLE_3)
    }
    
    // MARK: - Action -
    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true)
    }
}
