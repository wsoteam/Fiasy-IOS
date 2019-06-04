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
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Properties -
    private var delegate: RecipesDelegate?
    static let headerHeight: CGFloat = 60.0
    
    //MARK: - Interface -
    func fillHeader(by section: Int, delegate: RecipesDelegate) {
        self.delegate = delegate
        switch section {
        case 0:
            titleLabel.text = "Завтрак"
        case 1:
            titleLabel.text = "Обед"
        case 2:
            titleLabel.text = "Ужин"
        case 3:
            titleLabel.text = "Перекус"
        default:
            break
        }
    }
    
    //MARK: - Actions -
    @IBAction func showMoreClicked(_ sender: Any) {
        guard let title = titleLabel.text else {
            return
        }
        delegate?.showMoreClicked(title: title)
    }
}
