//
//  DiaryMeasuringHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/22/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class DiaryMeasuringHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = LS(key: .DIARY_MES_9)
    }
    
}
