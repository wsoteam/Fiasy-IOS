//
//  MyActivityEmptyState.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 9/11/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MyActivityEmptyState: UITableViewCell {
    
    
    // MARK: - Actions -
    @IBAction func addNewActivityClicked(_ sender: Any) {
        if let vc = UIApplication.getTopMostViewController() as? ActivityViewController {
            vc.performSegue(withIdentifier: "sequeAddNewActivity", sender: nil)
        }
    }
}
