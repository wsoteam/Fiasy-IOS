//
//  AddProductFooterTableView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/15/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class AddProductFooterTableView: UITableViewHeaderFooterView {

    // MARK: - Outlet's -
    @IBOutlet weak var backgroundNextContainerView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Properties -
    static var height: CGFloat = 100.0
    private var delegate: AddProductDelegate?
    
    // MARK: - Life cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nextButton.setTitle("\(LS(key: .UNBOARDING_NEXT)) ", for: .normal)
    }
    
    // MARK: - Interface -
    func fillFooter(delegate: AddProductDelegate) {
        self.delegate = delegate
    }
    
    func changeButtonState(state: Bool) {
        if state {
            nextButton.isEnabled = true
            backgroundNextContainerView.backgroundColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
            backgroundNextContainerView.shadowColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
        } else {
            nextButton.isEnabled = false
            backgroundNextContainerView.backgroundColor = #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
            backgroundNextContainerView.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1495795816)
        }
    }
    
    // MARK: - Actions -
    @IBAction func nextStepClicked(_ sender: Any) {
        self.delegate?.nextStepClicked()
    }
}
