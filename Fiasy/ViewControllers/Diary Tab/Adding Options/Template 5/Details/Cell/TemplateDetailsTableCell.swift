//
//  TemplateDetailsTableCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 12/27/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Amplitude_iOS

class TemplateDetailsTableCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var productListStackView: UIStackView!
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var premiumButton: UIButton!
    @IBOutlet weak var premDescriptionLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var nutrientLabel: UILabel!
    @IBOutlet weak var premiumContainerView: UIView!
    @IBOutlet weak var insertStackView: UIStackView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var proteinStackView: UIStackView!
    @IBOutlet weak var carbohydrateStackView: UIStackView!
    @IBOutlet weak var fatStackView: UIStackView!
    
    // MARK: - Properties -
    private var servingCount: Double = 0.0
    private var template: Template?
    private var isEditState: Bool = false
    private var selectedPortionId: Int?
    private var serverCount: Int = 0
    private var isBasketProduct: Bool = false
    private var delegate: ProductDetailsDelegate?
    private let ref: DatabaseReference = Database.database().reference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        errorButton.setTitle(LS(key: .REPORT_BUG), for: .normal)
        premiumButton.setTitle(LS(key: .CONNECT_PREMIUM).uppercased(), for: .normal)
        
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 15.0),
                                              color: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1), text: LS(key: .PREM_DESCRIPTION_1)))
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 15.0),
                            color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: " \(LS(key: .PREMIUM_TITLE).uppercased()) \(LS(key: .PREM_VERSION_1))"))
        premDescriptionLabel.attributedText = mutableAttrString
        //topSelectDescriptionLabel.text = LS(key: .PRODUCT_DETAILS_DESC)
    }
    
    // MARK: - Interface -
    func fillCell(_ template: Template, _ delegate: ProductDetailsDelegate) {
        self.template = template
        self.delegate = delegate
        
        if let name = template.name {
            let mutableAttrString = NSMutableAttributedString()
            mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 24.0),
                                                         color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: name))
            productNameLabel.attributedText = mutableAttrString
        }
        
        var allCalories: Double = 0.0
        var allProteins: Double = 0.0
        var allCarbohydrates: Double = 0.0
        var allFats: Double = 0.0
        for item in template.products {
            allCalories += Double((item.calories ?? 0.0) * 100.0).displayOnly(count: 0)
            allProteins += Double((item.proteins ?? 0.0) * 100.0).displayOnly(count: 0)
            allCarbohydrates += Double((item.carbohydrates ?? 0.0) * 100.0).displayOnly(count: 0)
            allFats += Double((item.fats ?? 0.0) * 100.0).displayOnly(count: 0)
        }
        
        if allCalories > 0.0 {
            let count = Int(allCalories)
            fillScreenServing(count: count, unit: "", title: LS(key: .CALORIES_UNIT), label: caloriesLabel)
        } else {
            fillScreenServing(count: 0, unit: "", title: LS(key: .CALORIES_UNIT), label: caloriesLabel)
        }
    
        if allProteins > 0.0 {
            let count = Int(allProteins)
            fillScreenServing(count: count, unit: LS(key: .GRAMS_UNIT), title: LS(key: .PROTEIN), label: proteinLabel)
        } else {
            fillScreenServing(count: 0, unit: "", title: LS(key: .PROTEIN), label: proteinLabel)
        }
        
        if allCarbohydrates > 0.0 {
            let count = Int(allCarbohydrates)
            fillScreenServing(count: count, unit: LS(key: .GRAMS_UNIT), title: LS(key: .CARBOHYDRATES), label: carbohydratesLabel)
        } else {
            fillScreenServing(count: 0, unit: "", title: LS(key: .CARBOHYDRATES), label: carbohydratesLabel)
        }
        if allFats > 0.0 {
            let count = Int(allFats)
            fillScreenServing(count: count, unit: LS(key: .GRAMS_UNIT), title: LS(key: .FAT), label: fatLabel)
        } else {
            fillScreenServing(count: 0, unit: "", title: LS(key: .FAT), label: fatLabel)
        }
        
        nutrientLabel.text = "\(LS(key: .PRODUCT_ADD_NUTRIENTS)) 100 \(LS(key: .GRAMS_UNIT))."
        
        if UserInfo.sharedInstance.purchaseIsValid {
            separatorView.isHidden = false
            premiumContainerView.isHidden = true
            insertStackView.isHidden = false
            
            fillCarbohydrates(template)
            fillFats(template)
            fillProtein(template)
        } else {
            separatorView.isHidden = true
            premiumContainerView.isHidden = false
            insertStackView.isHidden = true
        }
        
        if !template.products.isEmpty {
            productListStackView.subviews.forEach { $0.removeFromSuperview() }
            for (index, item) in template.products.enumerated() {
                guard let view = InsertTemplateProductView.fromXib() else { return }
                view.fillView(index == 0, item, template.products.count)
                productListStackView.addArrangedSubview(view)
            }
        }
    }
    
    // MARK: - Private -
    private func fillScreenServing(count: Int, unit: String, title: String, label: UILabel) {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 14.0),
                                                     color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: "\(count)\(unit)"))
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextRegular(size: 14.0),
                                                     color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: "\n\(title)"))
        label.attributedText = mutableAttrString
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    private func insertViewInStackView(stackView: UIStackView, left: String, right: String, isTitle: Bool) {
        guard let view = NutrientsInsertView.fromXib() else { return }
        view.fillView(leftName: left, rightName: right, isTitle: isTitle)
        stackView.addArrangedSubview(view)
    }
    
    private func fillCarbohydrates(_ template: Template) {
        carbohydrateStackView.subviews.forEach { $0.removeFromSuperview() }
        
        var carbohydrates: Double = 0.0
        var cellulose: Double = 0.0
        var sugar: Double = 0.0
        for item in template.products {
            carbohydrates += item.carbohydrates ?? 0.0
            cellulose += item.cellulose ?? 0.0
            sugar += item.sugar ?? 0.0
        }
        
        carbohydrates = carbohydrates <= 0.0 ? 0.0 : carbohydrates
        insertViewInStackView(stackView: carbohydrateStackView, left: LS(key: .CARBOHYDRATES_INTAKE), right: "\(Double(carbohydrates * Double(100.0).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: true)
        
        cellulose = cellulose <= 0.0 ? 0.0 : cellulose
        insertViewInStackView(stackView: carbohydrateStackView, left: LS(key: .СELLULOSE), right: "\(Double(cellulose * Double(100.0).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: false)

        sugar = sugar <= 0.0 ? 0.0 : sugar
        insertViewInStackView(stackView: carbohydrateStackView, left: LS(key: .SUGAR), right: "\(Double(sugar * Double(100.0).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
    }
    
    private func fillFats(_ template: Template) {
        let fl: Int = 100
        
        fatStackView.subviews.forEach { $0.removeFromSuperview() }
        
        var fats: Double = 0.0
        var saturatedFats: Double = 0.0
        var unSaturatedFats: Double = 0.0
        for item in template.products {
            fats += item.fats ?? 0.0
            saturatedFats += item.saturatedFats ?? 0.0
            unSaturatedFats += item.polyUnSaturatedFats ?? 0.0
        }
        
        fats = fats <= 0.0 ? 0.0 : fats
        insertViewInStackView(stackView: fatStackView, left: LS(key: .FAT), right: "\(Double(fats * Double(fl).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: true)
        
        saturatedFats = saturatedFats <= 0.0 ? 0.0 : saturatedFats
        insertViewInStackView(stackView: fatStackView, left: LS(key: .COMPLEXITY_TEXT5), right: "\(Double(saturatedFats * Double(fl).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
        
        unSaturatedFats = unSaturatedFats <= 0.0 ? 0.0 : unSaturatedFats
        insertViewInStackView(stackView: fatStackView, left: LS(key: .COMPLEXITY_TEXT6), right: "\(Double(unSaturatedFats * Double(fl).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
    }
    
    private func fillProtein(_ template: Template) {
        var fl: Int = 100
        proteinStackView.subviews.forEach { $0.removeFromSuperview() }
        var proteins: Double = 0.0
        var cholesterol: Double = 0.0
        var sodium: Double = 0.0
        var potassium: Double = 0.0
        
        for item in template.products {
            proteins += item.proteins ?? 0.0
            cholesterol += item.cholesterol ?? 0.0
            sodium += item.sodium ?? 0.0
            potassium += item.pottassium ?? 0.0
        }
        
        proteins = proteins <= 0.0 ? 0.0 : proteins
        insertViewInStackView(stackView: proteinStackView, left: LS(key: .PROTEIN), right: "\(Double(proteins * Double(fl).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: true)
        
        cholesterol = cholesterol <= 0.0 ? 0.0 : cholesterol
        insertViewInStackView(stackView: proteinStackView, left: LS(key: .CHOLESTEROL), right: "\(Double(cholesterol * Double(fl).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .COMPLEXITY_TEXT4))", isTitle: false)
        
        sodium = sodium <= 0.0 ? 0.0 : sodium
        insertViewInStackView(stackView: proteinStackView, left: LS(key: .SODIUM), right: "\(Double(sodium * Double(fl).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .COMPLEXITY_TEXT4))", isTitle: false)
        
        potassium = potassium <= 0.0 ? 0.0 : potassium
        insertViewInStackView(stackView: proteinStackView, left: LS(key: .POTASSIUM), right: "\(Double(potassium * Double(fl).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .COMPLEXITY_TEXT4))", isTitle: false)
    }
    
    private func saveProductInDataBase() {
        guard let template = self.template else { return }   
        FirebaseDBManager.saveTemplateProductInDataBase(list: template.products)
        self.delegate?.showSuccess()
    }
    
    // MARK: - Actions -
    @IBAction func addInDiaryClicked(_ sender: Any) {
        saveProductInDataBase()
    }
    
    @IBAction func showPremiumClicked(_ sender: Any) {
        delegate?.showPremiumScreen()
    }
    
    @IBAction func showErrorClicked(_ sender: Any) {
        self.delegate?.showSendError()
    }
}
