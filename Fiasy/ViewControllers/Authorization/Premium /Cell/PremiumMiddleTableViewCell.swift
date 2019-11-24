//
//  PremiumMiddleTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class PremiumMiddleTableViewCell: UITableViewCell {

    // MARK: - Outlet -
    @IBOutlet weak var insertStackView: UIStackView!
    
    // MARK: - Interface -
    func fillCell(state: PremiumColorState) {
        insertStackView.removeAllSubviews()
        if insertStackView.subviews.isEmpty {
            for index in 0...4 {
                guard let view = InsertPremiumDescriptionView.fromXib() else { return }
                view.fillCell(index: index, state: state)
                insertStackView.addArrangedSubview(view)
            }
        }
    }
}
