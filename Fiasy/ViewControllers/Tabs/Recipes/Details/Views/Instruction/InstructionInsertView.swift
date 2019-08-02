//
//  InstructionInsertView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/5/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class InstructionInsertView: UIView {
    
    //MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Interface -
    func fillView(index: Int, title: String) {
        titleLabel.text = "\(index + 1). \(title)"
    }
}
