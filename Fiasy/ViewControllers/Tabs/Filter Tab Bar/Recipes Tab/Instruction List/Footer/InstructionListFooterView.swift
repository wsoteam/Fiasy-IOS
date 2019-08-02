//
//  InstructionListFooterView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class InstructionListFooterView: UITableViewHeaderFooterView {
    
    // MARK: - Properties -
    static var height: CGFloat = 200.0
    private var delegate: InstructionListDelegate?
    
    // MARK: - Interface -
    func fillFooter(delegate: InstructionListDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Actions -
    @IBAction func addInstructionClicked(_ sender: Any) {
        self.delegate?.addNewInstruction()
    }
}
