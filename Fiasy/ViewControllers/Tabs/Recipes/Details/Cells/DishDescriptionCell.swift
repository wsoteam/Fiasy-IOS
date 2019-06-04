//
//  DishDescriptionCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class DishDescriptionCell: UITableViewCell {
    
    //MARK: - Outlet -
    @IBOutlet weak var carbohydrateStackView: UIStackView!
    @IBOutlet weak var fatStackView: UIStackView!
    @IBOutlet weak var proteinStackView: UIStackView!
    @IBOutlet weak var nutrientsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cookingStepsStackView: UIStackView!
    @IBOutlet weak var ingredientsStackView: UIStackView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clearStackView()
    }
    
    //MARK: - Interface -
    func fillCell(recipe: Listrecipe) {
        fillName(recipe)
        fillIngredient(recipe)
        fillCookingSteps(recipe)
        fillNutrientsLabel()
        fillCarbohydrates(recipe)
        fillFats(recipe)
        fillProtein(recipe)
    }
    
    private func fillProtein(_ recipe: Listrecipe) {
        if let proteins = recipe.proteins {
            insertViewInStackView(stackView: proteinStackView, left: "Белки", right: "\(proteins) г", isTitle: true)
        }
        if let cholesterol = recipe.cholesterol {
            insertViewInStackView(stackView: proteinStackView, left: "Холестерин", right: "\(cholesterol) г", isTitle: false)
        }
        if let sodium = recipe.sodium {
            insertViewInStackView(stackView: proteinStackView, left: "Натрий", right: "\(sodium) г", isTitle: false)
        }
        if let potassium = recipe.potassium {
            insertViewInStackView(stackView: proteinStackView, left: "Калий", right: "\(potassium) г", isTitle: false)
        }
    }
    
    private func fillFats(_ recipe: Listrecipe) {
        if let fats = recipe.fats {
            insertViewInStackView(stackView: fatStackView, left: "Жиры", right: "\(fats) г", isTitle: true)
        }
        if let saturatedFats = recipe.saturatedFats {
            insertViewInStackView(stackView: fatStackView, left: "Насыщенные", right: "\(saturatedFats) г", isTitle: false)
        }
        if let unSaturatedFats = recipe.unSaturatedFats {
            insertViewInStackView(stackView: fatStackView, left: "Ненасыщенные", right: "\(unSaturatedFats) г", isTitle: false)
        }
    }
    
    private func fillCarbohydrates(_ recipe: Listrecipe) {
        if let carbohydrates = recipe.carbohydrates {
            insertViewInStackView(stackView: carbohydrateStackView, left: "Углеводы", right: "\(carbohydrates) г", isTitle: true)
        }
        if let cellulose = recipe.cellulose {
            insertViewInStackView(stackView: carbohydrateStackView, left: "Клетчатка", right: "\(cellulose) г", isTitle: false)
        }
        
        if let sugar = recipe.sugar {
            insertViewInStackView(stackView: carbohydrateStackView, left: "Сахар", right: "\(sugar) г", isTitle: false)
        }
    }
    
    private func insertViewInStackView(stackView: UIStackView, left: String, right: String, isTitle: Bool) {
        guard let view = NutrientsInsertView.fromXib() else { return }
        view.fillView(leftName: left, rightName: right, isTitle: isTitle)
        stackView.addArrangedSubview(view)
    }
    
    private func fillCookingSteps(_ recipe: Listrecipe) {
        if let items = recipe.instruction {
            for item in items {
                guard let view = InstructionInsertView.fromXib() else { return }
                view.fillView(title: item)
                cookingStepsStackView.addArrangedSubview(view)
            }
        }
    }
    
    private func fillIngredient(_ recipe: Listrecipe) {
        if let items = recipe.ingredients {
            for item in items {
                guard let view = IngredientInsertView.fromXib() else { return }
                view.fillView(title: item)
                ingredientsStackView.addArrangedSubview(view)
            }
        }
    }
    
    private func fillNutrientsLabel() {
        let mutableAttrString = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoRegular(size: 14.0),
                                                color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: "Питательные вещества "))
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoLight(size: 12.0),
                                                color: #colorLiteral(red: 0.1646832824, green: 0.1647188365, blue: 0.164681077, alpha: 1), text: "\nна 1 порцию"))
        mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
        nutrientsLabel.attributedText = mutableAttrString
    }
    
    private func fillName(_ recipe: Listrecipe) {
        let mutableAttrString = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10

        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoRegular(size: 14.0),
                                              color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: recipe.name ?? ""))
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoLight(size: 14.0),
                                                     color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: "\nВремя готовки: \(recipe.time ?? 0) минут"))
        mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
        nameLabel.attributedText = mutableAttrString
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    private func clearStackView() {
        for view in ingredientsStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        for view in cookingStepsStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        for view in carbohydrateStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        for view in fatStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        for view in proteinStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}
