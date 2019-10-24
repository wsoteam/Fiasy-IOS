//
//  MeasuringListTableViewCell.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 10/23/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MeasuringListTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var emptyStackView: UIStackView!
    @IBOutlet var backgroundListVIews: [UIView]!

    // MARK: - Properties -
    private var delegate: MeasuringListDelegate?
    
    // MARK: - Interface -
    func fillCell(index: Int, delegate: MeasuringListDelegate) {
        self.delegate = delegate
        changeIndex(index: index)
    }
    
    // MARK: - Private -
    private func changeIndex(index: Int) {
        for item in backgroundListVIews {
            if item.tag == index {
                item.backgroundColor = #colorLiteral(red: 0.9344636798, green: 0.5902308822, blue: 0.1663158238, alpha: 1)
            } else {
                item.backgroundColor = #colorLiteral(red: 0.8783355355, green: 0.8784865737, blue: 0.8783260584, alpha: 1)
            }
        }
    }
    
    // MARK: - Actions -
    @IBAction func filterClicked(_ sender: UIButton) {
        emptyStackView.alpha = 0.0
        changeIndex(index: sender.tag)
        self.delegate?.filterClickedByTag(index: sender.tag)
    }
}
