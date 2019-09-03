//
//  ArticleHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ArticleHeaderView: UITableViewHeaderFooterView {

    // MARK: - Outlet's -
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties -
    private var section: Int?
    private var delegate: ArticlesTabDelegate?
    static let headerHeight: CGFloat = 50.0
    
    // MARK: - Interface -
    func fillHeader(by section: Int, delegate: ArticlesTabDelegate) {
        self.section = section
        self.delegate = delegate
        
        switch section {
        case 0:
            titleLabel.text = "Питание"
        case 1:
            titleLabel.text = "Тренировки"
        default:
            break
        }
    }
    
    // MARK: - Actions -
    @IBAction func showListClicked(_ sender: Any) {
        guard let section = self.section else { return }
        delegate?.showArticlesList(section: section)
    }
}
