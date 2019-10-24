//
//  MeasuringAlertMiddleWeightView.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 10/23/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MeasuringAlertMiddleWeightView: UIView {
    
    // MARK: - Outlet's -
    
    // MARK: - Properties -
    private var delegate: MeasuringCellDelegate?
    
    // MARK: - Interface -
    func fillView(delegate: MeasuringCellDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Actions -
    @IBAction func detailsAlertClicked(_ sender: Any) {
        self.delegate?.showDescription()
    }
}
