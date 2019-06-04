//
//  MealtimeViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MealtimeViewController: UIViewController {
    
    //MARK: - Actions -
    @IBAction func closeModule(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func mealtimeClicked(_ sender: UIButton) {
        sender.isEnabled = false
        dismiss(animated: true) { [unowned self] in
            UserInfo.sharedInstance.selectedMealtimeIndex = sender.tag
            self.post(Constant.SHOW_PRODUCT_LIST)
        }
    }
}
