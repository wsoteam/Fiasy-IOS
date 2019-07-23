//
//  TextGrowingTextView+Сonfigure.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/25/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Foundation
import NextGrowingTextView

extension NextGrowingTextView {
    
    func configureGrowingTextView() {
        maxNumberOfLines = 5
        textView.font = UIFont.fontRobotoMedium(size: 13)
        textView.textColor = #colorLiteral(red: 0.2587913275, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
        textView.tintColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
        
//        placeholderAttributedText = NSAttributedString(string: title,
//                                             attributes: [.font: UIFont.fontRobotoMedium(size: 13), .foregroundColor: #colorLiteral(red: 0.2587913275, green: 0.2588421106, blue: 0.2587881684, alpha: 1)])
        textView.isUserInteractionEnabled = true
        textView.autocorrectionType = .no
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
    }
}
