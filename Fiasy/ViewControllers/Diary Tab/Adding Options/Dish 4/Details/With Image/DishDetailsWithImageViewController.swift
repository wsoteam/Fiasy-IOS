//
//  DishDetailsWithImageViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/16/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import FirebaseDatabase
import VisualEffectView

class DishDetailsWithImageViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var blurView: VisualEffectView!
    @IBOutlet weak var progressTitleLabel: UILabel!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var progressView: CircularProgress!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var caloriesCountTextField: UITextField!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var dishImageView: UIImageView!
    
    // MARK: - Properties -
    private var selectedDish: Dish?
    private var portionCount: Int = 0
    private var selectedTitle: String = ""
    private let isIphone5 = Display.typeIsLike == .iphone5
    private lazy var dropdownView: LMDropdownView = LMDropdownView()
    private let ref: DatabaseReference = Database.database().reference()
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
        fillTopContainer()
        setupTableView()
        fillTitleNavigation(index: UserInfo.sharedInstance.selectedMealtimeIndex)
//        if let _ = selectedDish?.generalKeyByEdit {
//            editButton.isHidden = true
//        } else {
//            editButton.isHidden = false
//        }
        
        guard let selectedDish = self.selectedDish else { return }
        if let _ = selectedDish.generalKeyByEdit {
            titleButton.setImage(UIImage(), for: .normal)
            caloriesCountTextField.text = "\(portionCount)"
            addButton.setTitle(LS(key: .TITLE_CHANGE1).uppercased(), for: .normal)
            addButton.backgroundColor = (self.portionCount > 0 && self.portionCount != selectedDish.weight) ? #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1) : #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
            addButton.isEnabled = (self.portionCount > 0 && self.portionCount != selectedDish.weight) ? true : false
        } else {
            addButton.setTitle(LS(key: .ALERT_ADD).uppercased(), for: .normal)
            addButton.backgroundColor = self.portionCount > 0 ? #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1) : #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
            addButton.isEnabled = self.portionCount > 0 ? true : false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardWhenTappedAround()
        configurationKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuTableView.frame = CGRect(x: menuTableView.frame.minX,
                                  y: menuTableView.frame.minY,
                              width: view.bounds.width,
                             height: min(view.bounds.height, CGFloat(200)))
    }
    
    // MARK: - Interface -
    func fillScreenByDish(dish: Dish) {
        self.selectedDish = dish
        if let _ = dish.generalKeyByEdit, let count = dish.weight {
            self.portionCount = count
        }
        self.selectedDish?.createdProduct = Dish.fetchCreatedProduct(dish: dish)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDishScreen" {
            if let vc = segue.destination as? DishCreateFirstViewController, let dish = self.selectedDish {
                vc.fillScreenByDish(dish: dish)
                vc.backTwice = true
            }
        }
    }
    
    //MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editClicked(_ sender: Any) {
        performSegue(withIdentifier: "editDishScreen", sender: nil)
    }
    
    @IBAction func titleButtonClicked(_ sender: Any) {
        if let _ = self.selectedDish?.generalKeyByEdit { return }
        menuTableView.reloadData()
        showDropdownView(fromDirection: .top)
    }
    
    @IBAction func addInDiaryClicked(_ sender: Any) {
        saveProductInDataBase()
    }
    
    @IBAction func caloriesValueChanged(_ sender: UITextField) {
        guard let text = sender.text, let selectedDish = self.selectedDish else { return }
        
        addButton.isEnabled = !text.isEmpty
        self.portionCount = Int(text) ?? 0
        fillTopContainer()

        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DishDetailsWithImageCell {
            cell.changeCount(selectedDish, self.portionCount)
        }
        
        if let _ = selectedDish.generalKeyByEdit {
            addButton.setTitle(LS(key: .TITLE_CHANGE1).uppercased(), for: .normal)
            addButton.backgroundColor = (self.portionCount > 0 && self.portionCount != selectedDish.weight) ? #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1) : #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
            addButton.isEnabled = (self.portionCount > 0 && self.portionCount != selectedDish.weight) ? true : false
        } else {
            addButton.setTitle(LS(key: .ALERT_ADD).uppercased(), for: .normal)
            addButton.backgroundColor = self.portionCount > 0 ? #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1) : #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
            addButton.isEnabled = self.portionCount > 0 ? true : false
        }
    }
    
    // MARK: - Private -
    private func fillTopContainer() {
        guard let product = self.selectedDish?.createdProduct else { return }
        let servingCount = Double(portionCount)
        if let calories = product.calories, Double(servingCount * calories).rounded(toPlaces: 0) > 0.0 {
            let count = Int(Double(servingCount * calories).rounded(toPlaces: 0))
            fillScreenServing(count: count, unit: "", title: LS(key: .CALORIES_UNIT), label: caloriesLabel)
        } else {
            fillScreenServing(count: 0, unit: "", title: LS(key: .CALORIES_UNIT), label: caloriesLabel)
        }
        
        if let proteins = product.proteins, Double(servingCount * proteins).rounded(toPlaces: 0) > 0.0 {
            let count = Int(Double(servingCount * proteins).rounded(toPlaces: 0))
            fillScreenServing(count: count, unit: LS(key: .GRAMS_UNIT), title: LS(key: .PROTEIN), label: proteinLabel)
        } else {
            fillScreenServing(count: 0, unit: "", title: LS(key: .PROTEIN), label: proteinLabel)
        }
        
        if let carbohydrates = product.carbohydrates, Double(servingCount * carbohydrates).rounded(toPlaces: 0) > 0.0 {
            let count = Int(Double(servingCount * carbohydrates).rounded(toPlaces: 0))
            fillScreenServing(count: count, unit: LS(key: .GRAMS_UNIT), title: LS(key: .CARBOHYDRATES), label: carbohydratesLabel)
        } else {
            fillScreenServing(count: 0, unit: "", title: LS(key: .CARBOHYDRATES), label: carbohydratesLabel)
        }
        
        if let fats = product.fats, Double(servingCount * fats).rounded(toPlaces: 0) > 0.0 {
            let count = Int(Double(servingCount * fats).rounded(toPlaces: 0))
            fillScreenServing(count: count, unit: LS(key: .GRAMS_UNIT), title: LS(key: .FAT), label: fatLabel)
        } else {
            fillScreenServing(count: 0, unit: "", title: LS(key: .FAT), label: fatLabel)
        }
    }
    
    private func saveProductInDataBase() {
        guard let dish = self.selectedDish else { return }   
        
        if self.portionCount <= 0 {
            showWrongErrorCount()
            return
        }
        if let editKey = dish.generalKeyByEdit {
            if let uid = Auth.auth().currentUser?.uid, let parentKey = dish.parentKey {
                let table = ref.child("USER_LIST").child(uid).child(parentKey).child(editKey)
                table.child("weight").setValue(self.portionCount)
                FirebaseDBManager.reloadItems()
                showSuccess()
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
                if !dish.products.isEmpty {
                    for product in dish.products {
                        let dictionary: [String : Any] = ["product_id" : product.id, "generalId" : product.generalFindId, "name": product.name, "protein": product.proteins, "fat": product.fats, "carbohydrates": product.carbohydrates, "calories": product.calories, "brand": product.brend ?? "", "cholesterol" : product.cholesterol, "polyUnSaturatedFats" : product.polyUnSaturatedFats, "sodium" : product.sodium, "cellulose" : product.cellulose, "saturatedFats" : product.saturatedFats, "monoUnSaturatedFats" : product.monoUnSaturatedFats, "pottassium" : product.pottassium, "sugar" : product.sugar, "is_Liquid" : product.isLiquid ?? false]
                        listDictionary.append(dictionary)
                    }
                }
                
                let userData = ["name" : dish.name, "weight": self.portionCount, "isDish" : true, "food_date" : dayState, "day": day, "month": month, "year": year, "presentDay" : state, "imageUrl" : dish.imageUrl, "products" : listDictionary] as [String : Any]
                ref.child("USER_LIST").child(uid).child(UserInfo.sharedInstance.getTitleMealtimeForFirebase()).childByAutoId().setValue(userData)
                FirebaseDBManager.reloadItems()
                showSuccess()
            }
        }
    }
    
    private func setupInitialState() {
        guard let dish = self.selectedDish else { return }
        if let path = selectedDish?.imageUrl, let url = try? path.asURL() {
            let resource = ImageResource(downloadURL: url)
            dishImageView.kf.setImage(with: resource)
        }
        productNameLabel.text = dish.name
        dropdownView.delegate = self
        menuTableView.delegate = self
        menuTableView.dataSource = self
        blurView.colorTint = .gray
        blurView.colorTintAlpha = 0.1
        blurView.blurRadius = 5
        blurView.scale = 1
    }
    
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
    
    private func fillTitleNavigation(index: Int) {
        UserInfo.sharedInstance.selectedMealtimeIndex = index
        switch index {
        case 0:
            selectedTitle = LS(key: .BREAKFAST)
        case 1:
            selectedTitle = LS(key: .LUNCH)
        case 2:
            selectedTitle = LS(key: .DINNER)
        case 3:
            selectedTitle = LS(key: .SNACK)
        default:
            break
        }
        titleButton.setTitle("\(selectedTitle)  ", for: .normal)
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0)
        tableView.register(type: DishDetailsWithImageCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension DishDetailsWithImageViewController: LMDropdownViewDelegate {
    
    func showDropdownView(fromDirection direction: LMDropdownViewDirection) {
        dropdownView.direction = direction
        if dropdownView.isOpen {
            dropdownView.hide()
        } else {
            dropdownView.show(menuTableView, containerView: listContainerView)
        }
    }
    
    func dropdownViewWillShow(_ dropdownView: LMDropdownView) {
        titleButton.setImage(#imageLiteral(resourceName: "Polygon (2)"), for: .normal)
    }
    
    func dropdownViewDidShow(_ dropdownView: LMDropdownView) {
        listContainerView.isUserInteractionEnabled = true
    }
    
    func dropdownViewWillHide(_ dropdownView: LMDropdownView) {}
    func dropdownViewDidHide(_ dropdownView: LMDropdownView) {
        titleButton.setImage(#imageLiteral(resourceName: "Polygon (1)"), for: .normal)
        listContainerView.isUserInteractionEnabled = false
    }
}

extension DishDetailsWithImageViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == 0 ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailsWithImageCell") as? DishDetailsWithImageCell else { fatalError() }
            cell.fillCell(self.selectedDish, self, portionCount)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? MenuCell else { fatalError() }
            cell.fillSecondCell(indexPath, selectedTitle: self.selectedTitle, delegate: self)
            return cell
        }
    }
}

extension DishDetailsWithImageViewController: DishDetailsDelegate {
    
    func showSuccess() {
        progressView.trackColor = .clear
        progressView.progressColor = #colorLiteral(red: 0.9344636798, green: 0.5902308822, blue: 0.1663158238, alpha: 1)
        progressContainerView.fadeIn(duration: 0.0)
        
        if let _ = self.selectedDish?.generalKeyByEdit {
            progressTitleLabel.text = "Блюдо изменено в дневнике"
        } else {
            progressTitleLabel.text = "Блюдо добавлено в дневник"
        }
        progressView.setProgressWithAnimation(duration: 2, value: 2) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        }
    }
    
    func menuClicked(indexPath: IndexPath) {
        for (index, item) in menuTableView.visibleCells.enumerated() {
            if let cell = item as? MenuCell {
                if index == indexPath.row {
                    cell.radioButton.isOn = true
                    fillTitleNavigation(index: indexPath.row)
                } else {
                    cell.radioButton.isOn = false
                }
            }
        }
        if dropdownView.isOpen {
            dropdownView.hide()
        }
    }
    
    func showWrongErrorCount() {
        let alert = UIAlertController(title: LS(key: .ATTENTION), message: LS(key: .ADD_PRODUCT_NEW), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        self.present(alert, animated: true)
    }
    
    func caloriesChanged(_ count: Int) {
        //
    }
}

extension DishDetailsWithImageViewController: UITextFieldDelegate {
    
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
