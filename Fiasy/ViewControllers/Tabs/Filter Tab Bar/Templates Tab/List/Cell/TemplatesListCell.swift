//
//  TemplatesListCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class TemplatesListCell: UITableViewCell {
    
    // MARK: - Outlet's -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    // MARK: - Properties -
    private var item: Template?
    
    // MARK: - Interface -
    func fillCell(_ item: Template) {
        self.item = item
        
        titleLabel.text = item.name
        //countLabel.text = "\(item.fields.count) \(getNameCount(item.fields.count))"
    }
    
    func fetchTemplate() -> Template? {
        return item
    }
    
    // MARK: - Private -
    private func getNameCount(_ count: Int) -> String {
        if count == 1 {
            return "порция"
        } else if count > 1 && count < 5 {
            return "порции"
        } else {
            return "порций"
        }
    }
}
