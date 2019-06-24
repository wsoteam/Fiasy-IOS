//
//  MotivationTopCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/9/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import GradientProgressBar

class MotivationTopCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var daysCountLabel: UILabel!
    @IBOutlet weak var dayCountLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    // MARK: - Interface -
    func fillCell(count: Int) {
        
        progressView.tintColor = fetchProgressColor(count: count)
        progressView.progress = count >= 90 ? Float(1) : Float(Float(count)/100.0)
        
        dayCountLabel.text = "\(count)"
        daysCountLabel.text = getPrefixTitle(count: count)
    }
    
    // MARK: - Private -
    private func fetchProgressColor(count: Int) -> UIColor {
        if count == 0 {
            return #colorLiteral(red: 0.6018622518, green: 0.9138541818, blue: 0.2005874217, alpha: 1)
        } else if count > 0 && count < 8 {
            return #colorLiteral(red: 0.9331445098, green: 0.9483619332, blue: 0.1694321632, alpha: 1)
        } else if count > 7 && count < 22 {
            return #colorLiteral(red: 1, green: 0.8128992319, blue: 0.1546337903, alpha: 1)
        } else if count > 21 && count < 61 {
            return #colorLiteral(red: 0.9620590806, green: 0.5623346567, blue: 0.0363785699, alpha: 1)
        } else {
            return #colorLiteral(red: 0.9978051782, green: 0.35673666, blue: 0, alpha: 1)
        }
    }
    
    private func getPrefixTitle(count: Int) -> String {
        switch count {
            case 1:
                return "День"
            case 2,3,4:
                return "Дня"
            default:
                return "Дней"
        }
    }
}

