//
//  ListExpertArticlesTableCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ListExpertArticlesTableCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var daysLabel: [UILabel]!
    @IBOutlet var daysButton: [RadioButton]!
    
    // MARK: - Properties -
    private var info: Expert?
    
    // MARK: - Interface -
    func fillCell(info: Expert?) {
        self.info = info
        titleLabel.text = LS(key: .ART_SERIES_TITLE)
        descriptionLabel.text = LS(key: .ART_SERIES_INFO)
        for (index, item) in daysLabel.enumerated() {
            fillTextDay(day: index, label: item, info)
        }
    }
    
    // MARK: - Private -
    private func fillTextDay(day: Int, label: UILabel, _ info: Expert?) {
        var article: Article?
        for item in UserInfo.sharedInstance.articleExpert where item.dayInSeries == (day + 1) {
            article = item
            break
        }
        if let artc = article {
            var name: String?
            switch Locale.current.languageCode {
            case "es":
                // испанский
                name = artc.titleES?.stripOutHtml()
            case "pt":
            // португалия (бразилия)
                name = artc.titlePT?.stripOutHtml()
            case "en":
            // английский
                name = artc.titleENG?.stripOutHtml()
            case "de":
            // немецикий
                name = artc.titleDE?.stripOutHtml()
            default:
                // русский
                name = artc.titleRU?.stripOutHtml()
            }
            let lines = (name ?? "").split { $0.isNewline }
            let result = lines.joined(separator: "\n")
            let mutableAttrString = NSMutableAttributedString()
            switch day {
            case 0:
                daysButton[0].isOn = true
                mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
                mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                label.attributedText = mutableAttrString
            case 1:
                if let unlocked = info?.unlockedArticles, unlocked >= 2 {
                    daysButton[day].isOn = true
                    mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
                    mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    label.attributedText = mutableAttrString
                } else {
                    daysButton[day].isOn = false
                    mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.611733973, green: 0.6037768722, blue: 0.6119503379, alpha: 1)]))
                    mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.611733973, green: 0.6037768722, blue: 0.6119503379, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    label.attributedText = mutableAttrString
                }
            case 2:
                if let unlocked = info?.unlockedArticles, unlocked >= 3 {
                    daysButton[day].isOn = true
                    mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
                    mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    label.attributedText = mutableAttrString
                } else {
                    daysButton[day].isOn = false
                    mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.611733973, green: 0.6037768722, blue: 0.6119503379, alpha: 1)]))
                    mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.611733973, green: 0.6037768722, blue: 0.6119503379, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    label.attributedText = mutableAttrString
                }
            case 3:
                if let unlocked = info?.unlockedArticles, unlocked >= 4 {
                    daysButton[day].isOn = true
                    mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
                    mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    label.attributedText = mutableAttrString
                } else {
                    daysButton[day].isOn = false
                    mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.611733973, green: 0.6037768722, blue: 0.6119503379, alpha: 1)]))
                    mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.611733973, green: 0.6037768722, blue: 0.6119503379, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    label.attributedText = mutableAttrString
                }
            case 4:
                if let unlocked = info?.unlockedArticles, unlocked >= 5 {
                    daysButton[day].isOn = true
                    mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
                    mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    label.attributedText = mutableAttrString
                } else {
                    daysButton[day].isOn = false
                    mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.611733973, green: 0.6037768722, blue: 0.6119503379, alpha: 1)]))
                    mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.611733973, green: 0.6037768722, blue: 0.6119503379, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    label.attributedText = mutableAttrString
                }
            case 5:
                if let unlocked = info?.unlockedArticles, unlocked >= 6 {
                    daysButton[day].isOn = true
                    mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
                    mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    label.attributedText = mutableAttrString
                } else {
                    daysButton[day].isOn = false
                    mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.611733973, green: 0.6037768722, blue: 0.6119503379, alpha: 1)]))
                    mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.611733973, green: 0.6037768722, blue: 0.6119503379, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    label.attributedText = mutableAttrString
                }
            case 6:
                if let unlocked = info?.unlockedArticles, unlocked >= 7 {
                    daysButton[day].isOn = true
                    mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
                    mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    label.attributedText = mutableAttrString
                } else {
                    daysButton[day].isOn = false
                    mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.611733973, green: 0.6037768722, blue: 0.6119503379, alpha: 1)]))
                    mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.611733973, green: 0.6037768722, blue: 0.6119503379, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    label.attributedText = mutableAttrString
                }
            case 7:
                if let unlocked = info?.unlockedArticles, unlocked >= 8 {
                    daysButton[day].isOn = true
                    mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
                    mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    label.attributedText = mutableAttrString
                } else {
                    daysButton[day].isOn = false
                    mutableAttrString.append(NSAttributedString(string: " \(LS(key: .ART_SERIES_DAY)) \(day + 1). ", attributes: [.font: UIFont.sfProTextMedium(size: 17), .foregroundColor: #colorLiteral(red: 0.611733973, green: 0.6037768722, blue: 0.6119503379, alpha: 1)]))
                    mutableAttrString.append(NSAttributedString(string: result, attributes: [.font: UIFont.sfProTextSemibold(size: 17), .foregroundColor: #colorLiteral(red: 0.611733973, green: 0.6037768722, blue: 0.6119503379, alpha: 1), .underlineStyle : NSUnderlineStyle.single.rawValue]))
                    label.attributedText = mutableAttrString
                }
            default:
                break
            }
        }
    }
    
    // MARK: - Actions -
    @IBAction func buttonClicked(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "showedExpert")
        UserDefaults.standard.synchronize()
        if sender.tag == 0 {
            if let vc = UIApplication.getTopMostViewController() as? ListExpertArticlesViewController {
                vc.showSomeArticle(tag: sender.tag)
            }
        } else {
            if let unlocked = self.info?.unlockedArticles, unlocked >= (sender.tag + 1) {
                if let vc = UIApplication.getTopMostViewController() as? ListExpertArticlesViewController {
                    DispatchQueue.global(qos: .background).async {
                        FirebaseDBManager.fetchExpertInfoInDataBase { (info) in
                            let milisecond = Int64((Date().timeIntervalSince1970 * 1000.0).rounded())
                            if let count = info?.unlockedArticles {
                                if (sender.tag + 1) > count {
                                    FirebaseDBManager.saveExpertInfoInDataBase(id: "burlakov", count: (sender.tag + 1), milisecond: Int(milisecond))
                                }
                            } else {
                                FirebaseDBManager.saveExpertInfoInDataBase(id: "burlakov", count: 1, milisecond: Int(milisecond))
                            }
                        }
                    }
                    vc.showSomeArticle(tag: sender.tag)
                }
            }
        }
    }
}
