//
//  DiaryMeasuringTableViewCell.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 10/22/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class DiaryMeasuringTableViewCell: UITableViewCell {
    
    

    // MARK: - Properties -
    private var delegate: DiaryDisplayManagerDelegate?
    
    // MARK: - Interface -
    func fillCell(delegate: DiaryDisplayManagerDelegate) {
        self.delegate = delegate
    }

    // MARK: - Actions -
    @IBAction func showMeasuringClicked(_ sender: Any) {
        self.delegate?.showMeasuringScreen()
    }
}
