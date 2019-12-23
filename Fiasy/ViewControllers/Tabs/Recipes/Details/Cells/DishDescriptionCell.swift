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

class DishDescriptionCell: UITableViewCell {
    
    //MARK: - Outlet -
    @IBOutlet weak var ingridientLabel: UILabel!
    @IBOutlet weak var cookingMethodButton: UIButton!
    @IBOutlet weak var addInDiaryButton: UIButton!
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
    private var screenTitle: String = ""
    private var servingCount: Int = 1
    private var delegate: RecipesDetailsDelegate?
    private var ownRecipe: Bool = false
    private var recipe: SecondRecipe?
    
    //MARK: - Interface -
    func fillCell(recipe: SecondRecipe, delegate: RecipesDetailsDelegate, ownRecipe: Bool, title: String) {
        self.screenTitle = title
        self.recipe = recipe
        self.ownRecipe = ownRecipe
        self.delegate = delegate
        
        fillScreenServing()
        fillName(recipe)
        fillCookingSteps(recipe)
        
        ingridientLabel.text = LS(key: .INGREDIENTS_ON)
        addInDiaryButton.setTitle("      \(LS(key: .ADD_TO_DIARY).uppercased())      ", for: .normal)
        cookingMethodButton.setTitle("  \(LS(key: .СOOKING_METHOD))", for: .normal)
        
        guard let time = recipe.time else {
            return
        }
        
        var diffical: String = ""
//        if let complexity = recipe.complexity {
//            diffical = complexity
//        } else {
//            if time <= 20 {
//                diffical = "легко"
//            } else {
//                diffical = "сложно"
//            }
//        }
        if time <= 30 {
            diffical = LS(key: .COMPLEXITY_TEXT1)
        } else {
            diffical = LS(key: .COMPLEXITY_TEXT2)
        }        
        timeCookingButton.setTitle("  \(time) \(LS(key: .MIN))", for: .normal)
        cookingDifficultyLabel.text = "\(LS(key: .COMPLEXITY_TEXT3)): \(diffical)  •  "
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
    
    private func fillCalories(_ recipe: SecondRecipe) {
        caloriesStackView.subviews.forEach { $0.removeFromSuperview() }
        if let calories = recipe.calories {
            insertViewInStackView(stackView: caloriesStackView, left: LS(key: .CALORIES).capitalizeFirst, right: "\(calories * servingCount) \(LS(key: .CALORIES_UNIT).capitalizeFirst)", isTitle: true)
        }
    }

    private func fillProtein(_ recipe: SecondRecipe) {
        proteinStackView.subviews.forEach { $0.removeFromSuperview() }
        if let proteins = recipe.proteins {
            insertViewInStackView(stackView: proteinStackView, left: LS(key: .PROTEIN).capitalizeFirst, right: "\((proteins * Double(servingCount)).rounded(toPlaces: 1)) \(LS(key: .GRAMS_UNIT))", isTitle: true)
        }
        
        if let cholesterol = recipe.cholesterol {
            insertViewInStackView(stackView: proteinStackView, left: LS(key: .CHOLESTEROL).capitalizeFirst, right: "\(Double(cholesterol * servingCount).rounded(toPlaces: 1)) \(LS(key: .COMPLEXITY_TEXT4))", isTitle: false)
        }
        if let sodium = recipe.sodium {
            insertViewInStackView(stackView: proteinStackView, left: LS(key: .SODIUM).capitalizeFirst, right: "\(Double(sodium * Double(servingCount)).rounded(toPlaces: 1)) \(LS(key: .COMPLEXITY_TEXT4))", isTitle: false)
        }
        
        if let potassium = recipe.potassium {
            insertViewInStackView(stackView: proteinStackView, left: LS(key: .POTASSIUM).capitalizeFirst, right: "\(Double(potassium * Double(servingCount)).rounded(toPlaces: 1)) \(LS(key: .COMPLEXITY_TEXT4))", isTitle: false)
        }
    }

    private func fillFats(_ recipe: SecondRecipe) {
        fatStackView.subviews.forEach { $0.removeFromSuperview() }
        if let fats = recipe.fats {
            insertViewInStackView(stackView: fatStackView, left: LS(key: .FAT).capitalizeFirst, right: "\((fats * Double(servingCount)).rounded(toPlaces: 1)) \(LS(key: .GRAMS_UNIT))", isTitle: true)
        }
        
        if let saturatedFats = recipe.saturatedFats {
            insertViewInStackView(stackView: fatStackView, left: LS(key: .COMPLEXITY_TEXT5).capitalizeFirst, right: "\((saturatedFats * Double(servingCount)).rounded(toPlaces: 1)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
        }
        if let unSaturatedFats = recipe.unSaturatedFats {
            insertViewInStackView(stackView: fatStackView, left: LS(key: .COMPLEXITY_TEXT6).capitalizeFirst, right: "\((unSaturatedFats * Double(servingCount)).rounded(toPlaces: 1)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
        }
    }

    private func fillCarbohydrates(_ recipe: SecondRecipe) {
        carbohydrateStackView.subviews.forEach { $0.removeFromSuperview() }
        if let carbohydrates = recipe.carbohydrates {
            insertViewInStackView(stackView: carbohydrateStackView, left: LS(key: .CARBOHYDRATES_INTAKE).capitalizeFirst, right: "\((carbohydrates * Double(servingCount)).rounded(toPlaces: 1)) \(LS(key: .GRAMS_UNIT))", isTitle: true)
        }
        
        if let cellulose = recipe.cellulose {
            insertViewInStackView(stackView: carbohydrateStackView, left: LS(key: .СELLULOSE).capitalizeFirst, right: "\((cellulose * Double(servingCount)).rounded(toPlaces: 1)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
        }

        if let sugar = recipe.sugar {
            insertViewInStackView(stackView: carbohydrateStackView, left: LS(key: .SUGAR).capitalizeFirst, right: "\((sugar * Double(servingCount)).rounded(toPlaces: 1)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
        }
    }

    private func insertViewInStackView(stackView: UIStackView, left: String, right: String, isTitle: Bool) {
        guard let view = NutrientsInsertView.fromXib() else { return }
        view.fillView(leftName: left, rightName: right, isTitle: isTitle)
        stackView.addArrangedSubview(view)
    }

    private func fillCookingSteps(_ recipe: SecondRecipe) {
        if let items = recipe.instructions {
            for (index, item) in items.enumerated() {
                guard let view = InstructionInsertView.fromXib() else { return }
                view.fillView(index: index, title: item)
                cookingStepsStackView.addArrangedSubview(view)
            }
        }
    }

    private func fillIngredient(_ recipe: SecondRecipe) {
        ingredientsStackView.subviews.forEach { $0.removeFromSuperview() }
//        if !recipe.selectedProduct.isEmpty {
//            for item in recipe.selectedProduct {
//                guard let view = IngredientInsertView.fromXib() else { return }
//                view.fillOwnRecipeView(product: item, count: servingCount)
//                ingredientsStackView.addArrangedSubview(view)
//            }
//        } else {
            if let items = recipe.ingredients {
                for item in items {
                    guard let view = IngredientInsertView.fromXib() else { return }
                    view.fillView(item, count: servingCount)
                    ingredientsStackView.addArrangedSubview(view)
                }
            }
       // }
    }

    private func fillNutrientsLabel() {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoMedium(size: 17.0),
                                                color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: LS(key: .PRODUCT_ADD_NUTRIENTS).capitalizeFirst))
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

    private func fillName(_ recipe: SecondRecipe) {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextBold(size: 24.0),
                                              color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: recipe.recipeName ?? ""))
//        if let units = recipe.units, Int(recipe.weight ?? 0) != 0 {
//            mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoBold(size: 20.0),
//                               color: #colorLiteral(red: 0.4666130543, green: 0.4666974545, blue: 0.4666077495, alpha: 1), text: " (\(Int(recipe.weight ?? 0))\(units))"))
//        }
        nameLabel.attributedText = mutableAttrString
    }

    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    private func getServingPrefixName() -> String {
        var countText: String = ""
        switch servingCount {
        case 1:
            countText = LS(key: .PORTION)
        case 2,3,4:
            countText = LS(key: .SERVINGS)
        default:
            if getPreferredLocale().languageCode == "ru" {
                countText = "порций"
            } else {
                countText = LS(key: .SERVINGS)
            }
        }
        return countText
    }
    
//    private func fetchTitle(title: Eating) -> String {
//        switch title {
//        case .breakfast:
//            return "breakfasts"
//        case .dinner:
//            return "dinners"
//        case .lunch:
//            return "lunches"
//        case .snack:
//            return "snacks"
//        }
//    }
    
    private func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
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
//        
//        if ownRecipe {
//            guard let name = recipe?.recipeName else { return }
//            Amplitude.instance()?.logEvent("add_custom_recipe", withEventProperties: ["recipe_id" : name]) // +
//        }

        if let uid = Auth.auth().currentUser?.uid, let protein = recipe?.proteins, let fat = recipe?.fats, let carbohydrates = recipe?.carbohydrates, let calories = recipe?.calories, let name = recipe?.recipeName, let date = UserInfo.sharedInstance.selectedDate {
            
            let ref = Database.database().reference()
            let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: date)!
            let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: date)!
            let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: date)!
            
            let currentDay = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: Date())!
            let currentMonth = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: Date())!
            let currentYear = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: Date())!
            
            let state = currentDay == day && currentMonth == month && currentYear == year
            
            let userData = ["day": day, "month": month, "year": year, "name": name, "urlOfImages" : recipe?.imageUrl, "weight": servingCount, "protein": protein, "fat": fat, "carbohydrates": carbohydrates, "calories": calories, "isRecipe" : true, "presentDay" : state] as [String : Any]
            ref.child("USER_LIST").child(uid).child(getNewTitle()).childByAutoId().setValue(userData)
            
            Amplitude.instance()?.logEvent("add_recipe_success", withEventProperties: ["recipe_intake" : getSecondTitle()]) // +
            delegate?.showAnimate()
        }
    }
    
    private func getNewTitle() -> String {
        switch screenTitle {
        case LS(key: .BREAKFAST):
            return "breakfasts"
        case LS(key: .LUNCH):
            return "lunches"
        case LS(key: .DINNER):
            return "dinners"
        case LS(key: .SNACK):
            return "snacks"
        default:
            return "snacks"
        }
    }
    
    private func getSecondTitle() -> String {
        switch UserInfo.sharedInstance.selectedMealtimeIndex {
        case 0:
            return "breakfast"
        case 1:
            return "lunch"
        case 2:
            return "dinner"
        case 3:
            return "snack"
        default:
            return "snack"
        }
    }
}

extension DishDescriptionCell: PremiumDisplayDelegate {
    
    func showPremiumScreen() {
        delegate?.showPremiumScreen()
    }
}
