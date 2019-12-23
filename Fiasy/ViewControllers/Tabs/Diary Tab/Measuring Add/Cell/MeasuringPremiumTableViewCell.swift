//
//  MeasuringPremiumTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/23/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MeasuringPremiumTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var premiumButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties -
    private var measuring: Measuring?
    private var delegate: MeasuringDelegate?
    
    // MARK: - Interface -
    func fillCell(index: Int, delegate: MeasuringDelegate, allMeasurings: [Measuring]) {
        self.delegate = delegate
        
        premiumButton.setTitle("     \(LS(key: .PREMIUM_TITLE).uppercased())     ", for: .normal)
        switch index {
        case 0:
            addButton.tag = 0
            titleLabel.text = LS(key: .MEASURING_TITLE1)
            
            var list: [Measuring] = []
            for secondItem in allMeasurings where secondItem.type == .chest {
                list.append(secondItem)
            }
            list = list.sorted (by: {$0.timeInMillis > $1.timeInMillis})
            if list.isEmpty {
                measuring = nil
                addButton.setImage(UIImage(), for: .normal)
                addButton.setTitle(LS(key: .ALERT_ADD), for: .normal)
            } else {
                if let first = list.first, list.count > 1 {
                    let components = Calendar.current.dateComponents([.day], from: first.date ?? Date(), to: Date())
                    if (components.day ?? 0) >= 5 {
                        addButton.setImage(#imageLiteral(resourceName: "icon_glyph_arrow-reload"), for: .normal)
                    } else {
                        addButton.setImage(UIImage(), for: .normal)
                    }
                    
                    let mutableAttrString = NSMutableAttributedString()
                    mutableAttrString.append(NSAttributedString(string: " \(first.weight ?? 0.0) \(LS(key: .GROWTH_UNIT)) ", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    let current: CGFloat = CGFloat(list[0].weight ?? 0.0)
                    let old: CGFloat = CGFloat(list[1].weight ?? 0.0)
                    if current > 0.0 && old > 0.0 {
                        let percent = pctDiff(x1: old, x2: current).rounded(toPlaces: 1)
                        if percent > 0.0 {
                            mutableAttrString.append(NSAttributedString(string: "(+\(percent)%)", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.1528404951, green: 0.6837828755, blue: 0.3752267957, alpha: 1)]))
                        } else if percent != 0.0 {
                            mutableAttrString.append(NSAttributedString(string: "(\(percent)%)", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.1528404951, green: 0.6837828755, blue: 0.3752267957, alpha: 1)]))
                        }
                    }
                    measuring = first
                    addButton.setAttributedTitle(mutableAttrString, for: .normal)
                } else {
                    let components = Calendar.current.dateComponents([.day], from: list.first?.date ?? Date(), to: Date())
                    if (components.day ?? 0) >= 5 {
                        addButton.setImage(#imageLiteral(resourceName: "icon_glyph_arrow-reload"), for: .normal)
                    } else {
                        addButton.setImage(UIImage(), for: .normal)
                    }
                    measuring = list.first
                    addButton.setAttributedTitle(NSAttributedString(string: " \(list.first?.weight ?? 0.0) \(LS(key: .GROWTH_UNIT))", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)
                }
            }
        case 1:
            addButton.tag = 1
            titleLabel.text = LS(key: .MEASURING_TITLE2)
            
            var list: [Measuring] = []
            for secondItem in allMeasurings where secondItem.type == .waist {
                list.append(secondItem)
            }
            list = list.sorted (by: {$0.timeInMillis > $1.timeInMillis})
            if list.isEmpty {
                measuring = nil
                addButton.setImage(UIImage(), for: .normal)
                addButton.setTitle(LS(key: .ALERT_ADD), for: .normal)
            } else {
                if let first = list.first, list.count > 1 {
                    let components = Calendar.current.dateComponents([.day], from: first.date ?? Date(), to: Date())
                    if (components.day ?? 0) >= 5 {
                        addButton.setImage(#imageLiteral(resourceName: "icon_glyph_arrow-reload"), for: .normal)
                    } else {
                        addButton.setImage(UIImage(), for: .normal)
                    }
                    
                    let mutableAttrString = NSMutableAttributedString()
                    mutableAttrString.append(NSAttributedString(string: " \(first.weight ?? 0.0) \(LS(key: .GROWTH_UNIT)) ", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    let current: CGFloat = CGFloat(list[0].weight ?? 0.0)
                    let old: CGFloat = CGFloat(list[1].weight ?? 0.0)
                    if current > 0.0 && old > 0.0 {
                        let percent = pctDiff(x1: old, x2: current).rounded(toPlaces: 1)
                        if percent > 0.0 {
                            mutableAttrString.append(NSAttributedString(string: "(+\(percent)%)", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.1528404951, green: 0.6837828755, blue: 0.3752267957, alpha: 1)]))
                        } else if percent != 0.0 {
                            mutableAttrString.append(NSAttributedString(string: "(\(percent)%)", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.1528404951, green: 0.6837828755, blue: 0.3752267957, alpha: 1)]))
                        }
                    }
                    measuring = first
                    addButton.setAttributedTitle(mutableAttrString, for: .normal)
                } else {
                    let components = Calendar.current.dateComponents([.day], from: list.first?.date ?? Date(), to: Date())
                    if (components.day ?? 0) >= 5 {
                        addButton.setImage(#imageLiteral(resourceName: "icon_glyph_arrow-reload"), for: .normal)
                    } else {
                        addButton.setImage(UIImage(), for: .normal)
                    }
                    
                    measuring = list.first
                    addButton.setAttributedTitle(NSAttributedString(string: " \(list.first?.weight ?? 0.0) \(LS(key: .GROWTH_UNIT))", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)
                }
            }
        case 2:
            addButton.tag = 2
            titleLabel.text = LS(key: .MEASURING_TITLE3)
            
            var list: [Measuring] = []
            for secondItem in allMeasurings where secondItem.type == .hips {
                list.append(secondItem)
            }
            list = list.sorted (by: {$0.timeInMillis > $1.timeInMillis})
            if list.isEmpty {
                measuring = nil
                addButton.setImage(UIImage(), for: .normal)
                addButton.setTitle(LS(key: .ALERT_ADD), for: .normal)
            } else {
                if let first = list.first, list.count > 1 {
                    let components = Calendar.current.dateComponents([.day], from: first.date ?? Date(), to: Date())
                    if (components.day ?? 0) >= 5 {
                        addButton.setImage(#imageLiteral(resourceName: "icon_glyph_arrow-reload"), for: .normal)
                    } else {
                        addButton.setImage(UIImage(), for: .normal)
                    }

                    let mutableAttrString = NSMutableAttributedString()
                    mutableAttrString.append(NSAttributedString(string: " \(first.weight ?? 0.0) \(LS(key: .GROWTH_UNIT)) ", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    let current: CGFloat = CGFloat(list[0].weight ?? 0.0)
                    let old: CGFloat = CGFloat(list[1].weight ?? 0.0)
                    if current > 0.0 && old > 0.0 {
                        let percent = pctDiff(x1: old, x2: current).rounded(toPlaces: 1)
                        if percent > 0.0 {
                            mutableAttrString.append(NSAttributedString(string: "(+\(percent)%)", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.1528404951, green: 0.6837828755, blue: 0.3752267957, alpha: 1)]))
                        } else if percent != 0.0 {
                            mutableAttrString.append(NSAttributedString(string: "(\(percent)%)", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.1528404951, green: 0.6837828755, blue: 0.3752267957, alpha: 1)]))
                        }
                    }
                    measuring = first
                    addButton.setAttributedTitle(mutableAttrString, for: .normal)
                } else {
                    let components = Calendar.current.dateComponents([.day], from: list.first?.date ?? Date(), to: Date())
                    if (components.day ?? 0) >= 5 {
                        addButton.setImage(#imageLiteral(resourceName: "icon_glyph_arrow-reload"), for: .normal)
                    } else {
                        addButton.setImage(UIImage(), for: .normal)
                    }
                    
                    measuring = list.first
                    addButton.setAttributedTitle(NSAttributedString(string: " \(list.first?.weight ?? 0.0) \(LS(key: .GROWTH_UNIT))", attributes: [.font: UIFont.sfProTextMedium(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]), for: .normal)
                }
            }
        default:
            break
        }
        premiumButton.isHidden = UserInfo.sharedInstance.purchaseIsValid
        addButton.isHidden = !UserInfo.sharedInstance.purchaseIsValid 
    }
    
    // MARK: - Private -
    func pctDiff(x1: CGFloat, x2: CGFloat) -> Double {
        let diff = (x2 - x1) / x1
        return Double(round(100 * (diff * 100)) / 100)
    }
    
    // MARK: - Actions -
    @IBAction func addClicked(_ sender: UIButton) {
        if let measuring = self.measuring, measuring.type != .weight {
            if (Calendar.current.component(.day, from: measuring.date ?? Date()) == Calendar.current.component(.day, from: Date()) && Calendar.current.component(.month, from: measuring.date ?? Date()) == Calendar.current.component(.month, from: Date()) && Calendar.current.component(.year, from: measuring.date ?? Date()) == Calendar.current.component(.year, from: Date())) {
                delegate?.addPremiumMeasuring(tag: sender.tag, measuring: measuring)
            } else {
                delegate?.addPremiumMeasuring(tag: sender.tag, measuring: nil)
            }
        } else {
            delegate?.addPremiumMeasuring(tag: sender.tag, measuring: measuring)
        }
    }
    
    @IBAction func showPremiumClicked(_ sender: Any) {
        delegate?.showPremiumScreen()
    }
}
