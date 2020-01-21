//
//  ServingSizeCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import BEMCheckBox

class ServingSizeCell: SwipeTableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var checkMark: BEMCheckBox!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!

    // MARK: - Properties -
    private var serving: Serving?
    private var screenDelegate: ServingSizeDelegate?
    private var index: Int = 0
    
    // MARK: - Life cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCheckMark()
        //changeButton.setTitle(LS(key: .CREATE_STEP_TITLE_29), for: .normal)
    }
    
    // MARK: - Interface -
    func fillCell(serving: Serving, screenDelegate: ServingSizeDelegate, index: Int) {
        self.index = index
        self.serving = serving
        //changeButton.isHidden = index == 0
        self.screenDelegate = screenDelegate
        nameLabel.text = serving.name
        var nameUnit: String = LS(key: .SECOND_GRAM_UNIT)
        if serving.unitMeasurement == LS(key: .CREATE_STEP_TITLE_19) {
            nameUnit = LS(key: .SECOND_GRAM_UNIT)
        } else if serving.unitMeasurement == LS(key: .CREATE_STEP_TITLE_20) {
            nameUnit = LS(key: .WATER_UNIT)
        } else if serving.unitMeasurement == LS(key: .CREATE_STEP_TITLE_21) {
            nameUnit = LS(key: .LIG_PRODUCT)
        } else if serving.unitMeasurement == LS(key: .CREATE_STEP_TITLE_18) {
            nameUnit = LS(key: .WEIGHT_UNIT)
        }
        unitLabel.text = "\(serving.servingSize ?? 0) \(nameUnit)"
        if serving.selected {
            checkMark.setOn(true, animated: false)
        } else {
            checkMark.setOn(false, animated: false)
        }
    }
    
    // MARK: - Private -
    private func setupCheckMark() {
        checkMark.boxType = .square
    }
    
    // MARK: - Actions -
    @IBAction func checkMarkClicked(_ sender: Any) {
        guard let serving = self.serving else { return }
        screenDelegate?.servingClicked(checkMark, serving)
    }
}
