//
//  DishDetailsWithImageCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/17/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit

class DishDetailsWithImageCell: UITableViewCell {

    // MARK: - Outlet -
    @IBOutlet weak var productListStackView: UIStackView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var nutrientLabel: UILabel!
    @IBOutlet weak var insertStackView: UIStackView!
    @IBOutlet weak var proteinStackView: UIStackView!
    @IBOutlet weak var carbohydrateStackView: UIStackView!
    @IBOutlet weak var fatStackView: UIStackView!
    
    // MARK: - Properties -
    private var dish: Dish?
    private var servingCount: Double = 0.0
    //private var delegate: DishDetailsDelegate?
    
    // MARK: - Interface -
    func fillCell(_ dish: Dish?, _ delegate: DishDetailsDelegate, _ count: Int) {
        self.servingCount = Double(count)
        guard let selectedDish = dish, let product = selectedDish.createdProduct else { return }
        
        changeCount(selectedDish, count)
        if !selectedDish.products.isEmpty {
            productListStackView.subviews.forEach { $0.removeFromSuperview() }
            for (index, item) in selectedDish.products.enumerated() {
                guard let view = InsertTemplateProductView.fromXib() else { return }
                view.fillView(index == 0, item, selectedDish.products.count)
                productListStackView.addArrangedSubview(view)
            }
        }
    }
    
    func changeCount(_ dish: Dish?, _ count: Int) {
        guard let selectedDish = dish, let product = selectedDish.createdProduct else { return }
        fillCarbohydrates(product, count)
        fillFats(product, count)
        fillProtein(product, count)
        
        nutrientLabel.text = "\(LS(key: .PRODUCT_ADD_NUTRIENTS)) \(count) \(product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .SECOND_GRAM_UNIT))"
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
    
    private func fillCarbohydrates(_ product: Product, _ count: Int) {
        var fl: Int = count
        carbohydrateStackView.subviews.forEach { $0.removeFromSuperview() }
        if var carbohydrates = product.carbohydrates {
            carbohydrates = carbohydrates <= 0.0 ? 0.0 : carbohydrates
            insertViewInStackView(stackView: carbohydrateStackView, left: LS(key: .CARBOHYDRATES_INTAKE), right: "\(Double(carbohydrates * Double(fl).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: true)
        }
        if var cellulose = product.cellulose, cellulose > 0.0 {
            cellulose = cellulose <= 0.0 ? 0.0 : cellulose
            insertViewInStackView(stackView: carbohydrateStackView, left: LS(key: .СELLULOSE), right: "\(Double(cellulose * Double(fl).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
        }
        
        if var sugar = product.sugar, sugar > 0.0 {
            sugar = sugar <= 0.0 ? 0.0 : sugar
            insertViewInStackView(stackView: carbohydrateStackView, left: LS(key: .SUGAR), right: "\(Double(sugar * Double(fl).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
        }
    }
    
    private func fillFats(_ product: Product, _ count: Int) {
        var fl: Int = count
        fatStackView.subviews.forEach { $0.removeFromSuperview() }
        if var fats = product.fats {
            fats = fats <= 0.0 ? 0.0 : fats
            insertViewInStackView(stackView: fatStackView, left: LS(key: .FAT).capitalizeFirst, right: "\(Double(fats * Double(fl).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: true)
        }
        if var saturatedFats = product.saturatedFats, saturatedFats > 0.0 {
            saturatedFats = saturatedFats <= 0.0 ? 0.0 : saturatedFats
            insertViewInStackView(stackView: fatStackView, left: LS(key: .COMPLEXITY_TEXT5), right: "\(Double(saturatedFats * Double(fl).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
        }
        if var unSaturatedFats = product.polyUnSaturatedFats, unSaturatedFats > 0.0 {
            unSaturatedFats = unSaturatedFats <= 0.0 ? 0.0 : unSaturatedFats
            insertViewInStackView(stackView: fatStackView, left: LS(key: .COMPLEXITY_TEXT6), right: "\(Double(unSaturatedFats * Double(fl).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
        }
    }
    
    private func fillProtein(_ product: Product, _ count: Int) {
        var fl: Int = count
        proteinStackView.subviews.forEach { $0.removeFromSuperview() }
        if var proteins = product.proteins {
            proteins = proteins <= 0.0 ? 0.0 : proteins
            insertViewInStackView(stackView: proteinStackView, left: LS(key: .PROTEIN).capitalizeFirst, right: "\(Double(proteins * Double(fl).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: true)
        }
        if var cholesterol = product.cholesterol, cholesterol > 0.0 {
            cholesterol = cholesterol <= 0.0 ? 0.0 : cholesterol
            insertViewInStackView(stackView: proteinStackView, left: LS(key: .CHOLESTEROL), right: "\(Double(cholesterol * Double(fl).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .COMPLEXITY_TEXT4))", isTitle: false)
        }
        if var sodium = product.sodium, sodium > 0.0 {
            sodium = sodium <= 0.0 ? 0.0 : sodium
            insertViewInStackView(stackView: proteinStackView, left: LS(key: .SODIUM), right: "\(Double(sodium * Double(fl).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .COMPLEXITY_TEXT4))", isTitle: false)
        }
        if var potassium = product.pottassium, potassium > 0.0 {
            potassium = potassium <= 0.0 ? 0.0 : potassium
            insertViewInStackView(stackView: proteinStackView, left: LS(key: .POTASSIUM), right: "\(Double(potassium * Double(fl).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .COMPLEXITY_TEXT4))", isTitle: false)
        }
    }
    
    private func insertViewInStackView(stackView: UIStackView, left: String, right: String, isTitle: Bool) {
        guard let view = NutrientsInsertView.fromXib() else { return }
        view.fillView(leftName: left, rightName: right, isTitle: isTitle)
        stackView.addArrangedSubview(view)
    }
}
