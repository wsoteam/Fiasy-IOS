//
//  AddTemplateListCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class AddTemplateListCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    // MARK: - Propertie -
    private var indexPath: IndexPath?
    private var delegate: AddTemplateDelegate?
    
    // MARK: - Interface -
    func fillCell(_ info: [String], _ indexPath: IndexPath, _ delegate: AddTemplateDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        
        nameTitleLabel.text = info.first
        sizeLabel.text = "\(info.last ?? "") г."
    }
    
    // MARK: - Action -
    @IBAction func removeClicked(_ sender: Any) {
        guard let index = indexPath?.row else { return }
        self.delegate?.removePortion(index: index)
    }
}
