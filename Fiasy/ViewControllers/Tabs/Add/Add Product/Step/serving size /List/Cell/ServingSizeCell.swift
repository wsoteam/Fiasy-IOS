//
//  ServingSizeCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ServingSizeCell: SwipeTableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    // MARK: - Properties -
    private var screenDelegate: ServingSizeDelegate?
    private var index: Int = 0
    
    // MARK: - Life cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        changeButton.setTitle(LS(key: .CREATE_STEP_TITLE_29), for: .normal)
    }
    
    // MARK: - Interface -
    func fillCell(serving: Serving, screenDelegate: ServingSizeDelegate, index: Int) {
        self.index = index
        changeButton.isHidden = index == 0
        self.screenDelegate = screenDelegate
        nameLabel.text = serving.name
        if let cher = "\(serving.unitMeasurement ?? "")".lowercased().first {
            unitLabel.text = "\(serving.servingSize ?? 0) \(String(cher))."
        }
    }
    
    // MARK: - Actions -
    @IBAction func changeClicked(_ sender: Any) {
        self.screenDelegate?.changeServingSize(index: index)
    }
}
