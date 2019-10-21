//
//  PremiumDetailsCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/18/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class PremiumDetailsCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var topImageView: UIImageView!
    
    // MARK: - Properties -
    private var indexCell: Int?
    private var delegate: PremiumDetailsDelegate?
    
    // MARK: - Interface -
    func fillCell(index: Int, delegate: PremiumDetailsDelegate) {
        self.indexCell = index
        self.delegate = delegate
        
        switch index {
        case 0:
            topImageView.isHidden = false
            bottomImageView.image = #imageLiteral(resourceName: "price1")
        case 1:
            topImageView.isHidden = true
            bottomImageView.image = #imageLiteral(resourceName: "price2")
        case 2:
            topImageView.isHidden = true
            bottomImageView.image = #imageLiteral(resourceName: "price3")
        default:
            break
        }
    }
    
    // MARK: - Actions -
    @IBAction func payClicked(_ sender: Any) {
        guard let selectedIndex = indexCell else { return }
        delegate?.showSubscriptions(selectedIndex)
    }
}
