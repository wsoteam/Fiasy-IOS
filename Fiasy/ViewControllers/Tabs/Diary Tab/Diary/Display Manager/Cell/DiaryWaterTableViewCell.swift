//
//  DiaryWaterTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import DropDown
import Amplitude_iOS
import FirebaseDatabase

class DiaryWaterTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var waterFiledImageView: UIImageView!
    @IBOutlet weak var offsetView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties -
    private var dropDown = DropDown()
    private var selectedDate = Date()
    private var oldYOffset: CGFloat = 0.0
    private var selectedIndex: IndexPath?
    private var items: [Bool] = [false, false, false, false, false]
    private var delegate: DiaryDisplayManagerDelegate?
    private let ref: DatabaseReference = Database.database().reference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fillDropDown()
        setupCollectionView()
        
        switch Locale.current.languageCode {
        case "es":
            // испанский
            waterFiledImageView.image = #imageLiteral(resourceName: "water_es")
        case "pt":
            // португалия (бразилия)
            waterFiledImageView.image = #imageLiteral(resourceName: "water_pt")
        case "en":
            // английский
            waterFiledImageView.image = #imageLiteral(resourceName: "water_eng")
        case "de":
            // немецикий
            waterFiledImageView.image = #imageLiteral(resourceName: "water_de")
        default:
            // русский
            waterFiledImageView.image = #imageLiteral(resourceName: "water_iconLimit")
        }
    }
    
    // MARK: - Interface -
    func fillCell(delegate: DiaryDisplayManagerDelegate, selectedDate: Date) {
        self.delegate = delegate
        self.selectedDate = selectedDate
        
        if let user = UserInfo.sharedInstance.currentUser, let waterCount = user.maxWater {
            let count = "\(waterCount)".replacingOccurrences(of: ".0", with: "")
            descriptionLabel.text = "\(LS(key: .NORM_ESTABLISHED_FIRST).capitalizeFirst) \(count)\(LS(key: .WATER_UNIT)). \(LS(key: .NORM_ESTABLISHED_SECOND).capitalizeFirst) • • •"
        } else {
            descriptionLabel.text = "\(LS(key: .NORM_ESTABLISHED_FIRST).capitalizeFirst) \(2)\(LS(key: .WATER_UNIT)). \(LS(key: .NORM_ESTABLISHED_SECOND).capitalizeFirst) • • •"
        }
        
        if !UserInfo.sharedInstance.allWaters.isEmpty {
            let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: selectedDate)!
            let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: selectedDate)!
            let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: selectedDate)!
            
            for item in UserInfo.sharedInstance.allWaters where item.day == day && item.month == month && item.year == year {
                fillItemCount(item.waterCount ?? 0.0)
                
                var count: Double = 0.0
                for item in items where item == true {
                    count += 0.25
                }
                if count >= UserInfo.sharedInstance.currentUser?.maxWater ?? 2.0 {
                    waterFiledImageView.isHidden = false
                } else {
                    waterFiledImageView.isHidden = true
                }
                return setupTopLabel(count: "\(item.waterCount ?? 0.0)".replacingOccurrences(of: ".0", with: ""))
            }

            fillItemCount(0.0)
            setupTopLabel(count: "0")
            waterFiledImageView.isHidden = true
        } else {
            fillItemCount(0.0)
            setupTopLabel(count: "0")
            waterFiledImageView.isHidden = true
        }
    }
    
    // MARK: - Private -
    private func setupCollectionView() {
        self.collectionView.register(type: WaterCollectionCell.self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    private func setupTopLabel(count: String) {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 20),
                                                     color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: "\(LS(key: .WATER).capitalizeFirst) - "))
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 20),
                                                     color: #colorLiteral(red: 0.1752049029, green: 0.6115815043, blue: 0.8576936722, alpha: 1), text: "\(count) \(LS(key: .WATER_UNIT))."))
        topLabel.attributedText = mutableAttrString
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    private func fillItemCount(_ count: Double) {
        switch count {
        case 0.0:
            items = [false, false, false, false, false]
        case 0.25:
            items = [true, false, false, false, false]
        case 0.5:
            items = [true, true, false, false, false]
        case 0.75:
            items = [true, true, true, false, false]
        case 1.0:
            items = [true, true, true, true, false]
        case 1.25:
            items = [true, true, true, true, true, false]
        case 1.5:
            items = [true, true, true, true, true, true, false]
        case 1.75:
            items = [true, true, true, true, true, true, true, false]
        case 2.0:
            items = [true, true, true, true, true, true, true, true, false]
        case 2.25:
            items = [true, true, true, true, true, true, true, true, true, false]
        case 2.5:
            items = [true, true, true, true, true, true, true, true, true, true, false]
        case 2.75:
            items = [true, true, true, true, true, true, true, true, true, true, true, false]
        case 3.0:
            items = [true, true, true, true, true, true, true, true, true, true, true, true]
        default:
            break
        }
        collectionView.reloadData()
    }
    
    private func fillDropDown() {
        DropDown.appearance().textFont = UIFont.sfProTextMedium(size: 15)
        if dropDown.dataSource.isEmpty {
            dropDown.dataSource.append("  \(LS(key: .WATER_SETTINGS))  ")
        }
        
        offsetView.layoutIfNeeded()
        dropDown.anchorView = offsetView
        dropDown.cellHeight = 50.0
        dropDown.textColor = #colorLiteral(red: 0.2274407744, green: 0.2234539092, blue: 0.2275493145, alpha: 1)
        dropDown.setupCornerRadius(8.0)
        dropDown.selectedTextColor = #colorLiteral(red: 0.2274407744, green: 0.2234539092, blue: 0.2275493145, alpha: 1)
        dropDown.dismissMode = .onTap
        dropDown.selectionBackgroundColor = .clear
        dropDown.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dropDown.direction = .bottom

        dropDown.bottomOffset = CGPoint(x: 0, y: dropDown.anchorView?.plainView.bounds.height ?? 0)
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let strongSelf = self else { return }
            
//            Amplitude.instance()?.logEvent("diary_next", withEventProperties: ["add_intake" : "water"]) // +
            strongSelf.delegate?.showWaterDetails()
        }
    }
    
    private func fillWaterInDataBase() {
        var count: Double = 0.0
        for item in items where item == true {
            count += 0.25
        }
        if let uid = Auth.auth().currentUser?.uid {
            let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: selectedDate)!
            let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: selectedDate)!
            let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: selectedDate)!
            
            var containsWater: Water?
            for (index, item) in UserInfo.sharedInstance.allWaters.enumerated() where item.day == day && item.month == month && item.year == year {
                containsWater = item
                UserInfo.sharedInstance.allWaters[index].waterCount = count
                break
            }
            if let item = containsWater {
            ref.child("USER_LIST").child(uid).child("waters").child(item.generalKey ?? "").child("waterCount").setValue(count)
                Amplitude.instance()?.logEvent("add_water_success", withEventProperties: ["value" : count]) // +
            } else {
                let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: selectedDate)!
                let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: selectedDate)!
                let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: selectedDate)!
                
                let userData = ["day": day, "year": year, "month": month, "waterCount": count] as [String : Any]
                let generalK = Database.database().reference().childByAutoId()
                
                let waterFake = Water()
                waterFake.day = day
                waterFake.year = year
                waterFake.month = month
                waterFake.waterCount = count
                waterFake.generalKey = generalK.key
                UserInfo.sharedInstance.allWaters.append(waterFake)
                
                Amplitude.instance()?.logEvent("add_water_success", withEventProperties: ["value" : count]) // +
            Database.database().reference().child("USER_LIST").child(uid).child("waters").child(generalK.key).setValue(userData)
            }
        }
        
        setupTopLabel(count: "\(count)".replacingOccurrences(of: ".0", with: ""))
        if count >= UserInfo.sharedInstance.currentUser?.maxWater ?? 2.0 {
            waterFiledImageView.isHidden = false
            delegate?.reloadWaterCell()
        } else {
            waterFiledImageView.isHidden = true
            delegate?.reloadWaterCell()
        }
    }
    
    // MARK: - Actions -
    @IBAction func moreClicked(_ sender: Any) {
        dropDown.show()
    }
}

extension DiaryWaterTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaterCollectionCell", for: indexPath) as? WaterCollectionCell else { return UICollectionViewCell() }
        if items.indices.contains(indexPath.row) {
            cell.fillCell(state: items[indexPath.row], indexPath: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? WaterCollectionCell {
            if cell.fetchSelectedState() {
                if let _ = selectedIndex { return }
                items[indexPath.row] = false
                fillWaterInDataBase()
                collectionView.reloadItems(at: [indexPath])
            } else {
                guard selectedIndex != indexPath else { return }
                selectedIndex = indexPath
                if let _ = selectedIndex {
                    if (items.count - 1) == indexPath.row && !items.contains(false) {
                        return
                    }
                }
                
                items[indexPath.row] = true
                fillWaterInDataBase()
                
                cell.filledWaterContainerView.isHidden = false
                cell.fillView.isHidden = false
                if items.count < 12 && !items.contains(false) {
                    cell.fillView.addOldAnimation { (state) in
                        self.items.append(false)
                        collectionView.reloadData()
                        self.selectedIndex = nil
                    }
                } else {
                    cell.fillView.addOldAnimation { (state) in
                        collectionView.reloadItems(at: [indexPath])
                        self.selectedIndex = nil
                    }
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0  || scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        }
    }
}

extension DiaryWaterTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}
