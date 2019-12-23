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
    @IBOutlet weak var caloriesCountTextField: UITextField!
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var premiumButton: UIButton!
    @IBOutlet weak var premDescriptionLabel: UILabel!
    @IBOutlet weak var topSelectDescriptionLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var nutrientLabel: UILabel!
    @IBOutlet weak var premiumContainerView: UIView!
    @IBOutlet weak var insertStackView: UIStackView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var pickerButton: UIButton!
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
    private var product: Product?
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
        topSelectDescriptionLabel.text = LS(key: .PRODUCT_DETAILS_DESC)
    }
    
    // MARK: - Interface -
    func fillCell(_ product: Product?, _ delegate: ProductDetailsDelegate, _ count: Int, _ selectedPortionId: Int?, _ isEditState: Bool, _ basketProduct: Bool) {
        guard let selectedProduct = product else { return }
        self.product = selectedProduct
        self.isEditState = isEditState
        self.delegate = delegate
        self.serverCount = count
        self.selectedPortionId = selectedPortionId
        self.isBasketProduct = basketProduct
        
        self.servingCount = Double(count)
        
        var findedPortion: MeasurementUnits?
        if let portionId = selectedPortionId, !selectedProduct.measurementUnits.isEmpty {
            for item in selectedProduct.measurementUnits where item.id == portionId {
                findedPortion = item
                self.servingCount = Double(count * item.amount)
                break
            }
        }

        if basketProduct {
            addButton.setTitle(LS(key: .TITLE_SAVE_PERCENT2).uppercased(), for: .normal)
            
            if let weight = product?.weight, weight > 0 {
                if let amount = findedPortion?.amount, let sel = product?.selectedPortion?.amount, weight == count {
                    if let por = product?.portionId {
                        addButton.backgroundColor = amount == sel ? #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1) : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
                        addButton.isEnabled = amount == sel ? false : true
                    } else {
                        addButton.backgroundColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
                        addButton.isEnabled = true 
                    }
                } else {
                    if let _ = product?.portionId {
                        if let _ = findedPortion {
                            addButton.backgroundColor = weight == count ? #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1) : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
                            addButton.isEnabled = weight == count ? false : true 
                        } else {
                            addButton.backgroundColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
                            addButton.isEnabled = true 
                        }
                    } else {
                        addButton.backgroundColor = weight == count ? #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1) : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
                        addButton.isEnabled = weight == count ? false : true 
                    }
                }
            } else {
                if let amount = findedPortion?.amount {
                    if product?.selectedPortion?.amount == amount && count == 1 {
                        addButton.backgroundColor = #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
                        addButton.isEnabled = false
                    } else {
                        addButton.backgroundColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
                        addButton.isEnabled = true
                    }
                } else {
                    if count == 100 {
                        addButton.backgroundColor = #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
                        addButton.isEnabled = false
                    } else {
                        addButton.backgroundColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
                        addButton.isEnabled = true
                    }
                    self.servingCount = Double(count)
                }
            }
            
            if let amount = findedPortion?.amount {
                self.servingCount = Double(amount * count)
            } else {
                self.servingCount = Double(count)
            }
        
            if let somePortion = findedPortion, let name = somePortion.name, !name.isEmpty {
                var title: String = ""
                if !somePortion.unit.isEmpty {
                    title = "\(somePortion.name ?? "") (\(somePortion.amount) \(somePortion.unit))"
                } else {
                    title = "\(somePortion.name ?? "") (\(somePortion.amount) \(selectedProduct.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAMS_UNIT)))"
                }
                caloriesCountTextField.text = "\(count)"
                pickerButton.setTitle(title, for: .normal)
            } else {
                caloriesCountTextField.text = "\(count)"
                pickerButton.setTitle("\(selectedProduct.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAM_UNIT))", for: .normal)
            }
        } else {
            if isEditState {
                addButton.setTitle(LS(key: .TITLE_CHANGE1).uppercased(), for: .normal)
                
                if let find = findedPortion {
                    if let portId = product?.portionId, count == product?.weight {
                        addButton.backgroundColor = portId == find.id ? #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1) : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
                        addButton.isEnabled = portId == find.id ? false : true
                    } else {
                        addButton.backgroundColor = count == product?.weight ? #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1) : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
                        addButton.isEnabled = count == product?.weight ? false : true
                    } 
                } else {
                    addButton.backgroundColor = count == product?.weight ? #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1) : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
                    addButton.isEnabled = count == product?.weight ? false : true  
                }
            } else {
                addButton.setTitle(LS(key: .ALERT_ADD).uppercased(), for: .normal)
                addButton.backgroundColor = count > 0 ? #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1) : #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
                addButton.isEnabled = count > 0 ? true : false 
            }
            if let somePortion = findedPortion, let name = somePortion.name, !name.isEmpty {
                var title: String = ""
                if !somePortion.unit.isEmpty {
                    title = "\(somePortion.name ?? "") (\(somePortion.amount) \(somePortion.unit))"
                } else {
                    title = "\(somePortion.name ?? "") (\(somePortion.amount) \(selectedProduct.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAMS_UNIT)))"
                }
                caloriesCountTextField.text = "\(count)"
                pickerButton.setTitle(title, for: .normal)
            } else {
                caloriesCountTextField.text = "\(count)"
                pickerButton.setTitle("\(selectedProduct.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAM_UNIT))", for: .normal)
            }
        }

        if let name = product?.name {
            let mutableAttrString = NSMutableAttributedString()
            mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 24.0),
                                                      color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: name))
            if let brand = product?.brend, !brand.isEmpty &&  brand != "null" {
                mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 20.0),
                                                      color: #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1), text: "\n(\(brand))"))
            } 
            productNameLabel.attributedText = mutableAttrString
        }
        
        if let calories = product?.calories, Double(servingCount * calories).rounded(toPlaces: 0) > 0.0 {
            let count = Int(Double(servingCount * calories).rounded(toPlaces: 0))
            fillScreenServing(count: count, unit: "", title: LS(key: .CALORIES_UNIT), label: caloriesLabel)
        } else {
            fillScreenServing(count: 0, unit: "", title: LS(key: .CALORIES_UNIT), label: caloriesLabel)
        }
        
        if let proteins = product?.proteins, Double(servingCount * proteins).rounded(toPlaces: 0) > 0.0 {
            let count = Int(Double(servingCount * proteins).rounded(toPlaces: 0))
            fillScreenServing(count: count, unit: LS(key: .GRAMS_UNIT), title: LS(key: .PROTEIN), label: proteinLabel)
        } else {
            fillScreenServing(count: 0, unit: "", title: LS(key: .PROTEIN), label: proteinLabel)
        }
        
        if let carbohydrates = product?.carbohydrates, Double(servingCount * carbohydrates).rounded(toPlaces: 0) > 0.0 {
            let count = Int(Double(servingCount * carbohydrates).rounded(toPlaces: 0))
            fillScreenServing(count: count, unit: LS(key: .GRAMS_UNIT), title: LS(key: .CARBOHYDRATES), label: carbohydratesLabel)
        } else {
            fillScreenServing(count: 0, unit: "", title: LS(key: .CARBOHYDRATES), label: carbohydratesLabel)
        }
        
        if let fats = product?.fats, Double(servingCount * fats).rounded(toPlaces: 0) > 0.0 {
            let count = Int(Double(servingCount * fats).rounded(toPlaces: 0))
            fillScreenServing(count: count, unit: LS(key: .GRAMS_UNIT), title: LS(key: .FAT), label: fatLabel)
        } else {
            fillScreenServing(count: 0, unit: "", title: LS(key: .FAT), label: fatLabel)
        }
        
        if let somePortion = findedPortion, somePortion.amount > 0 {
            nutrientLabel.text = "\(LS(key: .PRODUCT_ADD_NUTRIENTS)) \(count * somePortion.amount) \(selectedProduct.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAMS_UNIT))."
        } else {
            if count > 0 {
                nutrientLabel.text = "\(LS(key: .PRODUCT_ADD_NUTRIENTS)) \(count) \(selectedProduct.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAMS_UNIT))."
            } else {
                nutrientLabel.text = "\(LS(key: .PRODUCT_ADD_NUTRIENTS)) 100 \(selectedProduct.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAMS_UNIT))."
            }            
        }
        
        if UserInfo.sharedInstance.purchaseIsValid {
            separatorView.isHidden = false
            premiumContainerView.isHidden = true
            insertStackView.isHidden = false
            guard let item = product else { return }
            fillCarbohydrates(item, count == 0 ? 100 : count, selectedPortionId)
            fillFats(item, count == 0 ? 100 : count, selectedPortionId)
            fillProtein(item, count == 0 ? 100 : count, selectedPortionId)
        } else {
            separatorView.isHidden = true
            premiumContainerView.isHidden = false
            insertStackView.isHidden = true
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
    
    private func fillCarbohydrates(_ product: Product, _ count: Int, _ selectedPortionId: Int?) {
        var fl: Int = count
        if let portionId = selectedPortionId, !product.measurementUnits.isEmpty {
            for item in product.measurementUnits where item.id == portionId {
                fl = count * item.amount
                break
            }
        }
        carbohydrateStackView.subviews.forEach { $0.removeFromSuperview() }
        if var carbohydrates = product.carbohydrates {
            carbohydrates = carbohydrates <= 0.0 ? 0.0 : carbohydrates
            insertViewInStackView(stackView: carbohydrateStackView, left: LS(key: .CARBOHYDRATES_INTAKE), right: "\(Double(carbohydrates * Double(fl).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: true)
        }
        if var cellulose = product.cellulose, cellulose != -1.0 && cellulose != 0.0 {
            cellulose = cellulose <= 0.0 ? 0.0 : cellulose
            insertViewInStackView(stackView: carbohydrateStackView, left: LS(key: .СELLULOSE), right: "\(Double(cellulose * Double(fl).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
        }
        
        if var sugar = product.sugar, sugar != -1.0 && sugar != 0.0 {
            sugar = sugar <= 0.0 ? 0.0 : sugar
            insertViewInStackView(stackView: carbohydrateStackView, left: LS(key: .SUGAR), right: "\(Double(sugar * Double(fl).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
        }
    }
    
    private func fillFats(_ product: Product, _ count: Int, _ selectedPortionId: Int?) {
        var fl: Int = count
        if let portionId = selectedPortionId, !product.measurementUnits.isEmpty {
            for item in product.measurementUnits where item.id == portionId {
                fl = count * item.amount
                break
            }
        }
        fatStackView.subviews.forEach { $0.removeFromSuperview() }
        if var fats = product.fats {
            fats = fats <= 0.0 ? 0.0 : fats
            insertViewInStackView(stackView: fatStackView, left: LS(key: .FAT), right: "\(Double(fats * Double(fl).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: true)
        }
        if var saturatedFats = product.saturatedFats, saturatedFats != -1.0 && saturatedFats != 0.0 {
            saturatedFats = saturatedFats <= 0.0 ? 0.0 : saturatedFats
            insertViewInStackView(stackView: fatStackView, left: LS(key: .COMPLEXITY_TEXT5), right: "\(Double(saturatedFats * Double(fl).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
        }
        if var unSaturatedFats = product.polyUnSaturatedFats, unSaturatedFats != -1.0 && unSaturatedFats != 0.0 {
            unSaturatedFats = unSaturatedFats <= 0.0 ? 0.0 : unSaturatedFats
            insertViewInStackView(stackView: fatStackView, left: LS(key: .COMPLEXITY_TEXT6), right: "\(Double(unSaturatedFats * Double(fl).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: false)
        }
    }
    
    private func fillProtein(_ product: Product, _ count: Int, _ selectedPortionId: Int?) {
        var fl: Int = count
        if let portionId = selectedPortionId, !product.measurementUnits.isEmpty {
            for item in product.measurementUnits where item.id == portionId {
                fl = count * item.amount
                break
            }
        }
        proteinStackView.subviews.forEach { $0.removeFromSuperview() }
        if var proteins = product.proteins {
            proteins = proteins <= 0.0 ? 0.0 : proteins
            insertViewInStackView(stackView: proteinStackView, left: LS(key: .PROTEIN), right: "\(Double(proteins * Double(fl).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .GRAMS_UNIT))", isTitle: true)
        }
        if var cholesterol = product.cholesterol, cholesterol != -1.0 && cholesterol != 0.0 {
            cholesterol = cholesterol <= 0.0 ? 0.0 : cholesterol
            insertViewInStackView(stackView: proteinStackView, left: LS(key: .CHOLESTEROL), right: "\(Double(cholesterol * Double(fl).displayOnly(count: 2)).displayOnly(count: 2)) \(LS(key: .COMPLEXITY_TEXT4))", isTitle: false)
        }
        if var sodium = product.sodium, sodium != -1.0 && sodium != 0.0 {
            sodium = sodium <= 0.0 ? 0.0 : sodium
            insertViewInStackView(stackView: proteinStackView, left: LS(key: .SODIUM), right: "\(Double(sodium * Double(fl).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .COMPLEXITY_TEXT4))", isTitle: false)
        }
        if var potassium = product.pottassium, potassium != -1.0 && potassium != 0.0 {
            potassium = potassium <= 0.0 ? 0.0 : potassium
            insertViewInStackView(stackView: proteinStackView, left: LS(key: .POTASSIUM), right: "\(Double(potassium * Double(fl).rounded(toPlaces: 1)).displayOnly(count: 2)) \(LS(key: .COMPLEXITY_TEXT4))", isTitle: false)
        }
    }
    
    private func saveProductInDataBase() {
        guard let product = self.product else { return }   
        
        if self.serverCount <= 0 {
            delegate?.showWrongErrorCount()
            return
        }
        
        if isBasketProduct {
            delegate?.changeBasketProduct(product: product)
            return
        }
        if isEditState {
                if let uid = Auth.auth().currentUser?.uid, let generalKey = product.generalKey, let parentKey = product.parentKey {

                    let table = ref.child("USER_LIST").child(uid).child(parentKey).child(generalKey)
                    table.child("weight").setValue(self.serverCount)
                    //table.child("multiplication").setValue(mult)
                    table.child("portionId").setValue(selectedPortionId)
                    //table.child("selectedUnit").setValue(selectedComponent)
                        Amplitude.instance()?.logEvent("edit_food") // +
                        FirebaseDBManager.reloadItems()
                    self.delegate?.showSuccess()
                }
            } else {
                if let uid = Auth.auth().currentUser?.uid, let date = UserInfo.sharedInstance.selectedDate {                    
                    let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: date)!
                    let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: date)!
                    let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: date)!
                    
                    let currentDay = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: Date())!
                    let currentMonth = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: Date())!
                    let currentYear = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: Date())!
                    
                    let state = currentDay == day && currentMonth == month && currentYear == year
                    
                    var dayState: String = "today"
                    if state {
                        dayState = "today"
                    } else if date.timeIntervalSince(Date()).sign == FloatingPointSign.minus {
                        dayState = "past"
                    } else {
                        dayState = "future"
                    }
                    
                    var listDictionary: [Any] = []

                    if !product.measurementUnits.isEmpty {
                        for item in product.measurementUnits where item.name != "Стандартная порция" && item.amount != 100 {
                            if !item.unit.isEmpty {
                                let dictionary: [String : Any] = ["id": item.id, "name": "\(item.name ?? "")", "amount": "\(Int(item.amount))", "unit" : item.unit]
                                listDictionary.append(dictionary)
                            } else {
                                let dictionary: [String : Any] = ["id": item.id, "name": "\(item.name ?? "")", "amount": "\(Int(item.amount))", "unit" : product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAM_UNIT)]
                                listDictionary.append(dictionary)
                            }
                        }
                    }
                    
                    //isOwnRecipe ? "custom" : "base"
                    Amplitude.instance()?.logEvent("add_food_success", withEventProperties: ["food_intake" : UserInfo.sharedInstance.getSecondTitleMealtimeForFirebase(), "food_category" : "base", "food_date" : dayState, "food_item" : "\(product.name ?? "")-\(product.brend ?? "")"]) // +

                    let userData = ["product_id" : product.id, "day": day, "month": month, "year": year, "name": product.name, "weight": self.serverCount, "protein": product.proteins, "fat": product.fats, "carbohydrates": product.carbohydrates, "calories": product.calories, "presentDay" : state, "isRecipe" : false, "brand": product.brend ?? "", "cholesterol" : product.cholesterol, "polyUnSaturatedFats" : product.polyUnSaturatedFats, "sodium" : product.sodium, "cellulose" : product.cellulose, "saturatedFats" : product.saturatedFats, "monoUnSaturatedFats" : product.monoUnSaturatedFats, "pottassium" : product.pottassium, "sugar" : product.sugar, "portionId" : selectedPortionId, "is_Liquid" : product.isLiquid ?? false, "measurement_units" : listDictionary] as [String : Any]
                    ref.child("USER_LIST").child(uid).child(UserInfo.sharedInstance.getTitleMealtimeForFirebase()).childByAutoId().setValue(userData)
                    FirebaseDBManager.reloadItems()
                    self.delegate?.showSuccess()
//                }
//            }
        }
        }
    }

    // MARK: - Actions -
    @IBAction func showPickerClicked(_ sender: Any) {
        self.delegate?.showSelectedPicker()
    }
    
    @IBAction func addInDiaryClicked(_ sender: Any) {
        saveProductInDataBase()
    }
    
    @IBAction func showPremiumClicked(_ sender: Any) {
        delegate?.showPremiumScreen()
    }
    
    @IBAction func showErrorClicked(_ sender: Any) {
        self.delegate?.showSendError()
    }
    
    @IBAction func caloriesChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        if text.isEmpty {
            addButton.isEnabled = false
        } else {
            addButton.isEnabled = true
            self.delegate?.caloriesChanged(Int(text) ?? 1)
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
        
        return count < 4
    }
}
