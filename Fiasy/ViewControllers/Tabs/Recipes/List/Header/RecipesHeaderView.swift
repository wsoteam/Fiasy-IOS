//
//  RecipesHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class RecipesHeaderView: UITableViewHeaderFooterView {

    //MARK: - Outlet's -
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Properties -
    private var delegate: RecipesDelegate?
    static let headerHeight: CGFloat = 60.0
    
    //MARK: - Interface -
    func fillHeader(by section: Int, delegate: RecipesDelegate) {
        self.delegate = delegate
        
        allButton.setTitle("\(LS(key: .ALL)) ", for: .normal)
        switch section {
        case 0:
            titleLabel.text = LS(key: .BREAKFAST)
        case 1:
            titleLabel.text = LS(key: .LUNCH)
        case 2:
            titleLabel.text = LS(key: .DINNER)
        case 3:
            titleLabel.text = LS(key: .SNACK)
        default:
            break
        }
    }
    
    func secondFillHeader(nutrition: Nutrition, delegate: RecipesDelegate) {
        //self.section = section
        self.delegate = delegate
        
        titleLabel.text = nutrition.name
    }
    
    //MARK: - Actions -
    @IBAction func showMoreClicked(_ sender: Any) {
        guard let title = titleLabel.text else {
            return
        }
        delegate?.showMoreClicked(title: title)
    }
}
