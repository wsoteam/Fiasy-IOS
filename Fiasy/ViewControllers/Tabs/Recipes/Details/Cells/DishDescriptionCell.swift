//
//  DishDescriptionCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Amplitude_iOS
import Intercom

class DishDescriptionCell: UITableViewCell {
    
    //MARK: - Outlet -
    @IBOutlet weak var timeCookingButton: UIButton!
    @IBOutlet weak var cookingDifficultyLabel: UILabel!
    @IBOutlet weak var numberOfServingLabel: UILabel!
    @IBOutlet weak var caloriesStackView: UIStackView!
    @IBOutlet weak var carbohydrateStackView: UIStackView!
    @IBOutlet weak var fatStackView: UIStackView!
    @IBOutlet weak var proteinStackView: UIStackView!
    @IBOutlet weak var nutrientsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cookingStepsStackView: UIStackView!
    @IBOutlet weak var ingredientsStackView: UIStackView!
    
    //MARK: - Properties -
    private var servingCount: Int = 1
    private var delegate: RecipesDetailsDelegate?
    private var ownRecipe: Bool = false
    private var recipe: Listrecipe?
    
    //MARK: - Interface -
    func fillCell(recipe: Listrecipe, delegate: RecipesDetailsDelegate, ownRecipe: Bool) {
        self.recipe = recipe
        self.ownRecipe = ownRecipe
        self.delegate = delegate
        
        fillScreenServing()
        fillName(recipe)
        fillCookingSteps(recipe)
        
        guard let time = recipe.time else {
            return
        }
        
        var diffical: String = ""
        if let complexity = recipe.complexity {
            diffical = complexity
        } else {
            if time <= 20 {
                diffical = "легко"
            } else {
                diffical = "сложно"
            }
        }
        
        timeCookingButton.setTitle("  \(time) мин", for: .normal)
        cookingDifficultyLabel.text = "Сложность: \(diffical)  •  "
    }
    
    private func fillScreenServing() {
        guard let recipe = self.recipe else { return }
        fillServing(by: servingCount)
        fillNutrientsLabel()
        fillIngredient(recipe)
        fillCalories(recipe)
        fillCarbohydrates(recipe)
        fillFats(recipe)
        fillProtein(recipe)
    }
    
    private func fillCalories(_ recipe: Listrecipe) {
        caloriesStackView.subviews.forEach { $0.removeFromSuperview() }
        if let calories = recipe.calories {
            insertViewInStackView(stackView: caloriesStackView, left: "Калорий", right: "\(calories * servingCount) Ккал", isTitle: true)
        }
    }
    
    private func fillProtein(_ recipe: Listrecipe) {
        proteinStackView.subviews.forEach { $0.removeFromSuperview() }
        if let proteins = recipe.proteins {
            insertViewInStackView(stackView: proteinStackView, left: "Белки", right: "\((proteins * Double(servingCount)).displayOnly(count: 2)) г", isTitle: true)
        }
        if let cholesterol = recipe.cholesterol {
            insertViewInStackView(stackView: proteinStackView, left: "Холестерин", right: "\(Double(cholesterol * servingCount).displayOnly(count: 2)) г", isTitle: false)
        }
        if let sodium = recipe.sodium {
            insertViewInStackView(stackView: proteinStackView, left: "Натрий", right: "\(Double(sodium * servingCount).displayOnly(count: 2)) г", isTitle: false)
        }
        if let potassium = recipe.potassium {
            insertViewInStackView(stackView: proteinStackView, left: "Калий", right: "\(Double(potassium * servingCount).displayOnly(count: 2)) г", isTitle: false)
        }
    }

    private func fillFats(_ recipe: Listrecipe) {
        fatStackView.subviews.forEach { $0.removeFromSuperview() }
        if let fats = recipe.fats {
            insertViewInStackView(stackView: fatStackView, left: "Жиры", right: "\((fats * Double(servingCount)).displayOnly(count: 2)) г", isTitle: true)
        }
        if let saturatedFats = recipe.saturatedFats {
            insertViewInStackView(stackView: fatStackView, left: "Насыщенные", right: "\((saturatedFats * Double(servingCount)).displayOnly(count: 2)) г", isTitle: false)
        }
        if let unSaturatedFats = recipe.unSaturatedFats {
            insertViewInStackView(stackView: fatStackView, left: "Ненасыщенные", right: "\((unSaturatedFats * Double(servingCount)).displayOnly(count: 2)) г", isTitle: false)
        }
    }

    private func fillCarbohydrates(_ recipe: Listrecipe) {
        carbohydrateStackView.subviews.forEach { $0.removeFromSuperview() }
        if let carbohydrates = recipe.carbohydrates {
            insertViewInStackView(stackView: carbohydrateStackView, left: "Углеводы", right: "\((carbohydrates * Double(servingCount)).displayOnly(count: 2)) г", isTitle: true)
        }
        if let cellulose = recipe.cellulose {
            insertViewInStackView(stackView: carbohydrateStackView, left: "Клетчатка", right: "\((cellulose * Double(servingCount)).displayOnly(count: 2)) г", isTitle: false)
        }

        if let sugar = recipe.sugar {
            insertViewInStackView(stackView: carbohydrateStackView, left: "Сахар", right: "\((sugar * Double(servingCount)).displayOnly(count: 2)) г", isTitle: false)
        }
    }

    private func insertViewInStackView(stackView: UIStackView, left: String, right: String, isTitle: Bool) {
        guard let view = NutrientsInsertView.fromXib() else { return }
        view.fillView(leftName: left, rightName: right, isTitle: isTitle, isOwn: ownRecipe, delegate: self)
        stackView.addArrangedSubview(view)
    }

    private func fillCookingSteps(_ recipe: Listrecipe) {
        if let items = recipe.instruction {
            for (index, item) in items.enumerated() {
                guard let view = InstructionInsertView.fromXib() else { return }
                view.fillView(index: index, title: item)
                cookingStepsStackView.addArrangedSubview(view)
            }
        }
    }

    private func fillIngredient(_ recipe: Listrecipe) {
        ingredientsStackView.subviews.forEach { $0.removeFromSuperview() }
        if !recipe.selectedProduct.isEmpty {
            for item in recipe.selectedProduct {
                guard let view = IngredientInsertView.fromXib() else { return }
                view.fillOwnRecipeView(product: item, count: servingCount)
                ingredientsStackView.addArrangedSubview(view)
            }
        } else {
            if let items = recipe.ingredients {
                for item in items {
                    guard let view = IngredientInsertView.fromXib() else { return }
                    view.fillView(item, count: servingCount)
                    ingredientsStackView.addArrangedSubview(view)
                }
            }
        }
    }

    private func fillNutrientsLabel() {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoMedium(size: 17.0),
                                                color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: "Питательные вещества на"))
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoMedium(size: 17.0),
                                                color: #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1), text: " \(servingCount) "))
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoMedium(size: 17.0),
                                                     color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: getServingPrefixName()))
        nutrientsLabel.attributedText = mutableAttrString
    }
    
    private func fillServing(by count: Int) {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoBold(size: 17.0),
                                               color: #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1), text: "\(count) "))
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoBold(size: 17.0),
                                                     color: #colorLiteral(red: 0.1293928325, green: 0.1294226646, blue: 0.129390955, alpha: 1), text: "\(getServingPrefixName())"))
        
        numberOfServingLabel.attributedText = mutableAttrString
    }

    private func fillName(_ recipe: Listrecipe) {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoBold(size: 20.0),
                                              color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: recipe.name ?? ""))
        if let units = recipe.units, Int(recipe.weight ?? 0) != 0 {
            mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoBold(size: 20.0),
                               color: #colorLiteral(red: 0.4666130543, green: 0.4666974545, blue: 0.4666077495, alpha: 1), text: " (\(Int(recipe.weight ?? 0))\(units))"))
        }
        nameLabel.attributedText = mutableAttrString
    }

    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    private func getServingPrefixName() -> String {
        var countText: String = ""
        switch servingCount {
        case 1:
            countText = "порцию"
        case 2,3,4:
            countText = "порции"
        default:
            countText = "порций"
        }
        return countText
    }
    
    private func fetchTitle(title: Eating) -> String {
        switch title {
        case .breakfast:
            return "breakfasts"
        case .dinner:
            return "dinners"
        case .lunch:
            return "lunches"
        case .snack:
            return "snacks"
        }
    }
    
    @IBAction func minusClicked(_ sender: Any) {
        guard servingCount > 1 else { return }
        servingCount = servingCount - 1
        fillScreenServing()
    }
    
    @IBAction func plusClicked(_ sender: Any) {
        servingCount = servingCount + 1
        fillScreenServing()
    }
    
    @IBAction func addProductClicked(_ sender: Any) {

        if let uid = Auth.auth().currentUser?.uid, let weight = recipe?.weight, let protein = recipe?.proteins, let fat = recipe?.fats, let carbohydrates = recipe?.carbohydrates, let calories = recipe?.calories, let name = recipe?.name, let date = UserInfo.sharedInstance.selectedDate {
            
            let ref = Database.database().reference()
            let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: date)!
            let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: date)!
            let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: date)!
            
            let currentDay = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: Date())!
            let currentMonth = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: Date())!
            let currentYear = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: Date())!
            
            let state = currentDay == day && currentMonth == month && currentYear == year
            
            let userData = ["day": day, "month": month, "year": year, "name": name, "weight": Int(weight * Double(servingCount).rounded(toPlaces: 1)), "protein": Int(protein * Double(servingCount).rounded(toPlaces: 1)), "fat": Int(fat * Double(servingCount).rounded(toPlaces: 1)), "carbohydrates": Int(carbohydrates * Double(servingCount).rounded(toPlaces: 1)), "calories": Int(calories * servingCount), "isRecipe" : true, "presentDay" : state] as [String : Any]
            ref.child("USER_LIST").child(uid).child(getTitle()).childByAutoId().setValue(userData)
            
            Intercom.logEvent(withName: "recipe_add_success", metaData: ["recipe_intake" : getTitle()]) //
            Amplitude.instance()?.logEvent("recipe_add_success", withEventProperties: ["recipe_intake" : getTitle()]) //
            
            FirebaseDBManager.reloadItems()
            delegate?.showAnimate()
        }
    }
    
    private func getTitle() -> String {
        switch UserInfo.sharedInstance.selectedMealtimeIndex {
        case 0:
            return "breakfasts"
        case 1:
            return "lunches"
        case 2:
            return "dinners"
        case 3:
            return "snacks"
        default:
            return "snacks"
        }
    }
}

extension DishDescriptionCell: PremiumDisplayDelegate {
    
    func showPremiumScreen() {
        delegate?.showPremiumScreen()
    }
}
