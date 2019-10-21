//
//  FirstQuizFinishCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class FirstQuizFinishCell: UICollectionViewCell {
    
    //MARK: - Outlet -
    @IBOutlet weak var filledLabel: UILabel!
    @IBOutlet weak var carbohydratesTitleLabel: UILabel!
    @IBOutlet weak var fatTitleLabel: UILabel!
    @IBOutlet weak var proteinTitleLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var recommendedCaloriesLabel: UILabel!
    
    //MARK: - Properties -
    private var delegate: QuizFinishViewOutput?
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    //MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupDisplayScreen()
        if UserInfo.sharedInstance.registrationFlow.gender == 0 {
            genderImage.image = #imageLiteral(resourceName: "women_empty1")
        } else {
            genderImage.image = #imageLiteral(resourceName: "man_empty1")
        }
    }
    
    // MARK: - Interface -
    func fillCell(delegate: QuizFinishViewOutput) {
        self.delegate = delegate
        
        configureSelectedData()
        delegate.changeStateBackButton(hidden: true)
    }
    
    // MARK: - Private -
    private func fillRecommendedCalories(count: Int) {
        let mutableAttrString = NSMutableAttributedString()
        let font = UIFont.sfProTextSemibold(size: 15)
        mutableAttrString.append(configureAttrString(by: font,
                                              color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: "\(LS(key: .RECOMMENDED_RATE)) ="))
        mutableAttrString.append(configureAttrString(by: font,
                                              color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: " \(count)"))
        mutableAttrString.append(configureAttrString(by: font,
                                              color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: " \(LS(key: .CALORIES_UNIT))"))
        recommendedCaloriesLabel.attributedText = mutableAttrString
    }
    
    private func setupDisplayScreen() {
        let mutableAttrString = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        let font = UIFont.sfProTextSemibold(size: isIphone5 ? 11 : 14)
        
        paragraphStyle.lineSpacing = 2
        paragraphStyle.alignment = .center
        
        mutableAttrString.append(configureAttrString(by: font, color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: "\(LS(key: .FIRST_PIECE_DESCRIPTION))\n"))
        mutableAttrString.append(configureAttrString(by: font, color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: LS(key: .IN_A_MONTH)))
        mutableAttrString.append(configureAttrString(by: font, color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: LS(key: .SECOND_PIECE_DESCRIPTION)))
        mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
        filledLabel.attributedText = mutableAttrString
        
        proteinTitleLabel.font = proteinTitleLabel.font?.withSize(isIphone5 ? 12.0 : 15.0)
        fatTitleLabel.font = fatTitleLabel.font?.withSize(isIphone5 ? 12.0 : 15.0)
        carbohydratesTitleLabel.font = carbohydratesTitleLabel.font?.withSize(isIphone5 ? 12.0 : 15.0)
        
        topLabel.text = LS(key: .PLAN_CALCULATED)
        proteinTitleLabel.text = LS(key: .PROTEIN)
        fatTitleLabel.text = LS(key: .FAT)
        carbohydratesTitleLabel.text = LS(key: .CARBOHYDRATES)
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    private func configureSelectedData() {
        let flow = UserInfo.sharedInstance.registrationFlow
        var BMR: Double = 0.0
        let birthday: Date = flow.dateOfBirth ?? Date()
        let ageComponents = Calendar.current.dateComponents([.year], from: birthday, to: Date())
        let age = Double(ageComponents.year ?? 0)
        
        var fat: Int = 0
        var protein: Int = 0
        var carbohydrates: Int = 0
        if flow.gender == 0 {
            BMR = (10 * flow.weight) + (6.25 * Double(flow.growth)) - (5 * age) - 161
        } else {
            BMR = (10 * flow.weight) + (6.25 * Double(flow.growth)) - (5 * age) + 5
        }
        let activity = (BMR * RegistrationFlow.fetchActivityCoefficient(value: flow.loadActivity))
        let result = RegistrationFlow.fetchResultByAdjustmentCoefficient(target: flow.target, count: activity).displayOnly(count: 0)
        
        if flow.gender == 0 {
            fat = (Int((result * 0.25).displayOnly(count: 0))/9) + 16
            protein = (Int((result * 0.4).displayOnly(count: 0))/4) - 16
            carbohydrates = (Int((result * 0.35).displayOnly(count: 0))/4) - 16
        } else {
            fat = (Int((result * 0.25).displayOnly(count: 0))/9) + 36
            protein = (Int((result * 0.4).displayOnly(count: 0))/4) - 36
            carbohydrates = (Int((result * 0.35).displayOnly(count: 0))/4) - 36
        }
        fillRecommendedCalories(count: Int(result))
        proteinLabel.text = "\(protein) г"
        fatLabel.text = "\(fat) г"
        carbohydratesLabel.text = "\(carbohydrates) г"
    }
}
