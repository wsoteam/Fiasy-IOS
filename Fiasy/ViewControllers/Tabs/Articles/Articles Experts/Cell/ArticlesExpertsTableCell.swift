//
//  ArticlesExpertsTableCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ArticlesExpertsTableCell: UITableViewCell {
    
    
    // MARK: - Actions -
    @IBAction func nextClicked(_ sender: Any) {
        if let vc = UIApplication.getTopMostViewController() as? ArticlesExpertsViewController {
            vc.performSegue(withIdentifier: "sequeListExpertArticles", sender: nil)
        }
    }
}
