//
//  ProductDetailsCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/22/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Amplitude_iOS

class ProductDetailsCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var saveButton: LoadingButton!
    @IBOutlet weak var bottomSeparatorView: UIView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var proteinStackView: UIStackView!
    @IBOutlet weak var carbohydrateStackView: UIStackView!
    @IBOutlet weak var fatStackView: UIStackView!
    @IBOutlet weak var nutritionalTitleLabel: UILabel!
    
    //MARK: - Properties -
    private var servingCount: Int = 0
    private var product: Product?
    private var isEditState: Bool = false
    private var editProduct: Mealtime?
    private var delegate: ProductDetailsDelegate?
    private let ref: DatabaseReference = Database.database().reference()
    
    // MARK: - Interface -
    func fillCell(product: Product?, delegate: ProductDetailsDelegate, editProduct: Mealtime?, _ isEditState: Bool) {
        if let weight = editProduct?.weight {
            servingCount = weight
            weightTextField.text = "\(weight)"
            saveButton.setTitle("ИЗМЕНИТЬ", for: .normal)
        }
        self.product = product
        self.delegate = delegate
        self.isEditState = isEditState
        self.editProduct = editProduct
        fillScreenServing()
    }
    
    // MARK: - Private -
    private func fillScreenServing() {
        guard let product = self.product else { return }
        fillNutrientsLabel()
        fillCalories(product)
        fillCarbohydrates(product)
        fillFats(product)
        fillProtein(product)
    }
    
    private func fillNutrientsLabel() {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoMedium(size: 17.0),
                                                     color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: "Питательные вещества на"))
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoMedium(size: 17.0),
                                                     color: #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1), text: " \(servingCount) г."))
        nutritionalTitleLabel.attributedText = mutableAttrString
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    private func insertViewInStackView(stackView: UIStackView, left: String, right: String, isTitle: Bool) {
        guard let view = NutrientsInsertView.fromXib() else { return }
        view.fillView(leftName: left, rightName: right, isTitle: isTitle)
        stackView.addArrangedSubview(view)
    }
    
    private func fillCalories(_ product: Product) {
        if var calories = product.calories {
            calories = calories <= 0.0 ? 0.0 : calories
            caloriesLabel.text = " = \(Double(calories * Double(servingCount).rounded(toPlaces: 1)).rounded(toPlaces: 0)) Ккал".replacingOccurrences(of: ".0", with: "")
        }
    }
    
    private func fillCarbohydrates(_ product: Product) {
        carbohydrateStackView.subviews.forEach { $0.removeFromSuperview() }
        if var carbohydrates = product.carbohydrates {
            carbohydrates = carbohydrates <= 0.0 ? 0.0 : carbohydrates
            insertViewInStackView(stackView: carbohydrateStackView, left: "Углеводы", right: "\(Double(carbohydrates * Double(servingCount).rounded(toPlaces: 1)).rounded(toPlaces: 1)) г", isTitle: true)
        }
        if var cellulose = product.cellulose {
            cellulose = cellulose <= 0.0 ? 0.0 : cellulose
            insertViewInStackView(stackView: carbohydrateStackView, left: "Клетчатка", right: "\(Double(cellulose * Double(servingCount).rounded(toPlaces: 1)).rounded(toPlaces: 1)) г", isTitle: false)
        }
        
        if var sugar = product.sugar {
            sugar = sugar <= 0.0 ? 0.0 : sugar
            insertViewInStackView(stackView: carbohydrateStackView, left: "Сахар", right: "\(Double(sugar * Double(servingCount).rounded(toPlaces: 1)).rounded(toPlaces: 1)) г", isTitle: false)
        }
    }
    
    private func fillFats(_ product: Product) {
        fatStackView.subviews.forEach { $0.removeFromSuperview() }
        if var fats = product.fats {
            fats = fats <= 0.0 ? 0.0 : fats
            insertViewInStackView(stackView: fatStackView, left: "Жиры", right: "\(Double(fats * Double(servingCount).rounded(toPlaces: 1)).rounded(toPlaces: 1)) г", isTitle: true)
        }
        if var saturatedFats = product.saturatedFats {
            saturatedFats = saturatedFats <= 0.0 ? 0.0 : saturatedFats
            insertViewInStackView(stackView: fatStackView, left: "Насыщенные", right: "\(Double(saturatedFats * Double(servingCount).rounded(toPlaces: 1)).rounded(toPlaces: 1)) г", isTitle: false)
        }
        if var unSaturatedFats = product.polyUnSaturatedFats {
            unSaturatedFats = unSaturatedFats <= 0.0 ? 0.0 : unSaturatedFats
            insertViewInStackView(stackView: fatStackView, left: "Ненасыщенные", right: "\(Double(unSaturatedFats * Double(servingCount).rounded(toPlaces: 1)).rounded(toPlaces: 1)) г", isTitle: false)
        }
    }
    
    private func fillProtein(_ product: Product) {
        proteinStackView.subviews.forEach { $0.removeFromSuperview() }
        if var proteins = product.proteins {
            proteins = proteins <= 0.0 ? 0.0 : proteins
            insertViewInStackView(stackView: proteinStackView, left: "Белки", right: "\(Double(proteins * Double(servingCount).rounded(toPlaces: 1)).rounded(toPlaces: 1)) г", isTitle: true)
        }
        if var cholesterol = product.cholesterol {
            cholesterol = cholesterol <= 0.0 ? 0.0 : cholesterol
            insertViewInStackView(stackView: proteinStackView, left: "Холестерин", right: "\(Double(cholesterol * Double(servingCount).rounded(toPlaces: 1)).rounded(toPlaces: 1)) г", isTitle: false)
        }
        if var sodium = product.sodium {
            sodium = sodium <= 0.0 ? 0.0 : sodium
            insertViewInStackView(stackView: proteinStackView, left: "Натрий", right: "\(Double(sodium * Double(servingCount).rounded(toPlaces: 1)).rounded(toPlaces: 1)) г", isTitle: false)
        }
        if var potassium = product.pottassium {
            potassium = potassium <= 0.0 ? 0.0 : potassium
            insertViewInStackView(stackView: proteinStackView, left: "Калий", right: "\(Double(potassium * Double(servingCount).rounded(toPlaces: 1)).rounded(toPlaces: 1)) г", isTitle: false)
        }
    }
    
    private func saveProductInDataBase(weight: Int) {
        guard let product = self.product, let title = self.saveButton.titleLabel?.text else { return }
        if title.isEmpty { return }
        if title == "ИЗМЕНЕНО" || title == "ДОБАВЛЕННО" {
            let message = isEditState ? "Выбранный продукт уже изменен" : "Вы уже добавили продукт в дневник"
            self.delegate?.showAlert(message: message)
            return
        }
        let carbohydrates = Double((product.carbohydrates ?? 0.0) * Double(servingCount).rounded(toPlaces: 1)).rounded(toPlaces: 0)
        let fat = Double((product.fats ?? 0.0) * Double(servingCount).rounded(toPlaces: 1)).rounded(toPlaces: 0)
        let protein = Double((product.proteins ?? 0.0) * Double(servingCount).rounded(toPlaces: 1)).rounded(toPlaces: 0)
        if isEditState {
            if let edit = self.editProduct, edit.weight == weight {
                self.saveButton.hideLoading()
                self.delegate?.showAlert(message: "Вы ничего не изменили")
                return
            }
            saveButton.showLoading()
            if let uid = Auth.auth().currentUser?.uid, let generalKey = editProduct?.generalKey, let parentKey = editProduct?.parentKey {
                if let weight = weightTextField.text, let calories = caloriesLabel.text?.replacingOccurrences(of: " Ккал", with: "").replacingOccurrences(of: " = ", with: "") {
                    let table = ref.child("USER_LIST").child(uid).child(parentKey).child(generalKey)
                    table.child("weight").setValue(Int(weight))
                    table.child("protein").setValue(Int(protein))
                    table.child("fat").setValue(Int(fat))
                    table.child("carbohydrates").setValue(Int(carbohydrates))
                    table.child("calories").setValue(Int(calories))
                    FirebaseDBManager.reloadItems()
                    UserInfo.sharedInstance.isReload = true
                    delayWithSeconds(1) {
                        self.saveButton.hideLoading()
                        self.saveButton.setTitle("ИЗМЕНЕНО", for: .normal)
                        self.saveButton.setImage(#imageLiteral(resourceName: "Shape (2)"), for: .normal)
                    }
                }
            }
        } else {
            Amplitude.instance().logEvent("attempt_add_food")
            saveButton.showLoading()
            if let uid = Auth.auth().currentUser?.uid, let date = UserInfo.sharedInstance.selectedDate, let weight = weightTextField.text, let calories = caloriesLabel.text?.replacingOccurrences(of: " Ккал", with: "").replacingOccurrences(of: " = ", with: "") {
                let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: date)!
                let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: date)!
                let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: date)!
                
                let currentDay = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: Date())!
                let currentMonth = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: Date())!
                let currentYear = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: Date())!
                
                let state = currentDay == day && currentMonth == month && currentYear == year
                
                let userData = ["day": day, "month": month, "year": year, "name": product.name, "weight": Int(weight), "protein": Int(protein), "fat": Int(fat), "carbohydrates": Int(carbohydrates), "calories": Int(calories), "presentDay" : state] as [String : Any]
                ref.child("USER_LIST").child(uid).child(UserInfo.sharedInstance.getTitleMealtimeForFirebase()).childByAutoId().setValue(userData)
                    FirebaseDBManager.reloadItems()
                    delayWithSeconds(1) {
                        self.saveButton.hideLoading()
                        self.saveButton.setTitle("ДОБАВЛЕННО", for: .normal)
                        self.saveButton.setImage(#imageLiteral(resourceName: "Shape (2)"), for: .normal)
                    }
            }
        }
    }
    
    private func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    // MARK: - Actions -
    @IBAction func valueChange(_ sender: UITextField) {
        guard let text = sender.text, let count = Int(text) else {
            if sender.text?.isEmpty ?? false {
                servingCount = 0
                fillScreenServing()
            }
            return
        }
        if let title = self.saveButton.titleLabel?.text, isEditState && title == "ИЗМЕНЕНО" {
            saveButton.setImage(UIImage(), for: .normal)
            saveButton.setTitle("ИЗМЕНИТЬ", for: .normal)
        }
        servingCount = count
        fillScreenServing()
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        guard let text = weightTextField.text, !text.isEmpty else {
            self.delegate?.showEmptyTextAlert()
            return
        }
        guard let count = Int(text) else { return }
        if count == 0 {
            self.delegate?.showZeroAlert()
        } else {
            saveProductInDataBase(weight: count)
        }
    }
}

extension ProductDetailsCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 10
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomSeparatorView.backgroundColor = #colorLiteral(red: 0.9386252165, green: 0.490940094, blue: 0, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bottomSeparatorView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
    }
}