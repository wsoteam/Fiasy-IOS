//
//  ProductDetailsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS
import SwiftEntryKit
import VisualEffectView

protocol ProductDetailsDelegate {
    func closeModule()
    func addProductInRecipe()
    func showSendError()
    func showPremiumScreen()
    func showSelectedPicker()
    func showSuccess()
    func showWrongErrorCount()
    func menuClicked(indexPath: IndexPath)
    func caloriesChanged(_ count: Int)
    func changeBasketProduct(product: Product)
}

class ProductDetailsViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var progressTitleLabel: UILabel!
    @IBOutlet weak var blurView: VisualEffectView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var selectedPicker: UIPickerView!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var progressView: CircularProgress!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    var delegate: BasketDelegate?
    private var basketProduct: Bool = false
    private var portionCount: Int = 0
    private var selectedPortionId: Int?
    private var selectedTitle: String = ""
    private var product: Product?
    private var pickerData: [String] = []
    private var isEditState: Bool = false
    private lazy var dropdownView: LMDropdownView = LMDropdownView()
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var firstLoad: Bool = true
    private var isFavoriteProduct: Bool = false
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = product?.id {
            FirebaseDBManager.searchFavoriteInDataBase(by: id) { [weak self] (state, key) in
                guard let strongSelf = self else { return }
                strongSelf.product?.generalKey = key
                strongSelf.favoriteButton.setImage(state ? #imageLiteral(resourceName: "favorite_button-1") : #imageLiteral(resourceName: "favorite_button_empty"), for: .normal)
                strongSelf.isFavoriteProduct = state
            }
        } else if let general = product?.generalFindId {
            FirebaseDBManager.searchFavoriteByGeneralIdInDataBase(by: general) { [weak self] (state) in
                guard let strongSelf = self else { return }
                strongSelf.favoriteButton.setImage(state ? #imageLiteral(resourceName: "favorite_button-1") : #imageLiteral(resourceName: "favorite_button_empty"), for: .normal)
                strongSelf.isFavoriteProduct = state
            }
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "favorite_button_empty"), for: .normal)
        }
        
        cancelButton.setTitle("     \(LS(key: .CANCEL).uppercased())     ", for: .normal)
        finishButton.setTitle("     \(LS(key: .DONE).uppercased())     ", for: .normal)
        tableView.tag = 0
        menuTableView.tag = 1
        setupInitialState()
        setupTableView()
        setupPickerData()
        setupInitialState()
        
        fillTitleNavigation(index: UserInfo.sharedInstance.selectedMealtimeIndex)
        if let vc = UIApplication.getTopMostViewController(), vc.navigationController?.viewControllers.previous is MyСreatedProductsViewController &&  !(product?.measurementUnits.isEmpty ?? true) {
            portionCount = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardWhenTappedAround()
        configurationKeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SwiftEntryKit.dismiss()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuTableView.frame = CGRect(x: menuTableView.frame.minX,
                                     y: menuTableView.frame.minY,
                                 width: view.bounds.width,
                                height: min(view.bounds.height, CGFloat(200)))
    }
    
    func fillSelectedProduct(product: Product, title: String, basketProduct: Bool) {
        self.basketProduct = basketProduct
        self.selectedTitle = title
        //self.checkTitle(title: title)
        self.product = product
        if let weight = product.weight, weight > 0 {
            self.isEditState = true
            self.portionCount = weight
        } else if basketProduct == true {
            if let _ = product.selectedPortion {
                portionCount = 1
            } else {
                portionCount = 100
            }
        } else if let _ = product.selectedPortion {
            portionCount = 1
        }
    }
    
    func fillOwnRecipe() {
        //isOwnRecipe = true
    }
    
    // MARK: - Private -
    private func setupInitialState() {
        blurView.colorTint = .gray
        blurView.colorTintAlpha = 0.1
        blurView.blurRadius = 5
        blurView.scale = 1
        titleButton.setTitle("\(selectedTitle) ", for: .normal)
        dropdownView.delegate = self
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        if let weight = product?.weight, weight > 0 {
            self.titleButton.isEnabled = false
            self.titleButton.setImage(nil, for: .normal)
        }
        if basketProduct == true {
            self.titleButton.isEnabled = false
            self.titleButton.setImage(nil, for: .normal)
        }
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
    
    private func checkTitle(title: String) {
        switch title {
        case LS(key: .BREAKFAST):
            UserInfo.sharedInstance.selectedMealtimeIndex = 0
        case LS(key: .LUNCH):
            UserInfo.sharedInstance.selectedMealtimeIndex = 1
        case LS(key: .DINNER):
            UserInfo.sharedInstance.selectedMealtimeIndex = 2
        case LS(key: .SNACK):
            UserInfo.sharedInstance.selectedMealtimeIndex = 3
        default:
            break
        }
    }
    
    private func setupPickerData() {
        guard let product = self.product else { return }
        var rightSide: [String] = []
        if !product.measurementUnits.isEmpty {
            for item in product.measurementUnits {
                if !item.unit.isEmpty {
                    rightSide.append("\(item.name ?? "") (\(item.amount) \(item.unit))")
                } else {
                    rightSide.append("\(item.name ?? "") (\(item.amount) \(product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAMS_UNIT)))")
                }
            }
        }
        if let selected = product.selectedPortion {
            for (index, item) in product.measurementUnits.enumerated() where item.id == selected.id {
                if rightSide.indices.contains(index) {
                    rightSide.remove(at: index)
                    selectedPortionId = item.id
                    if !item.unit.isEmpty {
                        rightSide.insert("\(item.name ?? "") (\(item.amount) \(item.unit))", at: 0)
                    } else {
                        rightSide.insert("\(item.name ?? "") (\(item.amount) \(product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAMS_UNIT)))", at: 0)
                    }
                }
                break
            }
            
            if let _ = product.weight {
                if let _ = product.portionId {
                    rightSide.append(product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAM_UNIT))
                } else {
                    selectedPortionId = nil
                    rightSide.insert(product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAM_UNIT), at: 0)
                }
            } else {
                rightSide.append(product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAM_UNIT))
            }
        } else {
            if let vc = UIApplication.getTopMostViewController(), vc.navigationController?.viewControllers.previous is MyСreatedProductsViewController {
                //
            } else if product.isMineProduct == true && !product.measurementUnits.isEmpty {
                //
            } else {
                rightSide.insert(product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAM_UNIT), at: 0)
            }
        }
        
        pickerData = rightSide
        selectedPicker.delegate = self
        selectedPicker.dataSource = self
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.register(type: ProductDetailsCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func closePicker() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.pickerContainerView.frame = CGRect(x: 0, y: self.view.bounds.size.height, width: UIScreen.main.bounds.width, height: self.pickerContainerView.bounds.size.height)
        }) { (state) in
            if let background = self.pickerContainerView.superview {
                background.fadeOut()
            }
        }
    }
    
    private func reloadDiary() {
        if let nv = navigationController {             
            for vc in nv.viewControllers where vc is DiaryViewController {  
                if let diary = vc as? DiaryViewController {                     
                    diary.getItemsInDataBase()
                }             
            }          
        }
    }
    
    private func showPicker() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3) { 
            if let background = self.pickerContainerView.superview {
                background.fadeIn()
            }
            self.pickerContainerView.frame = CGRect(x: 0, y: self.view.bounds.size.height - self.pickerContainerView.bounds.size.height, width: UIScreen.main.bounds.width, height: self.pickerContainerView.bounds.size.height)
        }
    }
    
    //MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        if isFavoriteProduct {
            guard let key = self.product?.generalKey else { return }
            if key != self.product?.generalFindId {
                if let fd = self.product?.generalFindId {
                    FirebaseDBManager.removeFavorite(key: fd) { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.isFavoriteProduct = false
                        strongSelf.product?.generalKey = nil
                        strongSelf.favoriteButton.setImage(#imageLiteral(resourceName: "favorite_button_empty"), for: .normal)
                    } 
                } else {
                    FirebaseDBManager.removeFavorite(key: key) { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.isFavoriteProduct = false
                        strongSelf.product?.generalKey = nil
                        strongSelf.favoriteButton.setImage(#imageLiteral(resourceName: "favorite_button_empty"), for: .normal)
                    }
                }
            } else {
                FirebaseDBManager.removeFavorite(key: key) { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.isFavoriteProduct = false
                    strongSelf.product?.generalKey = nil
                    strongSelf.favoriteButton.setImage(#imageLiteral(resourceName: "favorite_button_empty"), for: .normal)
                } 
            }
        } else {
            guard let product = self.product else { return }
            FirebaseDBManager.saveFavoriteProductInDataBase(product: SecondProduct(second: product)) { [weak self] (key) in
                guard let strongSelf = self else { return }
                strongSelf.product?.generalKey = key
                strongSelf.isFavoriteProduct = true
                strongSelf.favoriteButton.setImage(#imageLiteral(resourceName: "favorite_button-1"), for: .normal)
            }
        }
    }
    
    @IBAction func titleButtonClicked(_ sender: Any) {
        menuTableView.reloadData()
        showDropdownView(fromDirection: .top)
    }
    
    @IBAction func closePickerClicked(_ sender: Any) {
        closePicker()
    }
    
    @IBAction func addWeightClicked(_ sender: Any) {
        guard let product = self.product else { return }
        //self.portionCount = selectedPicker.selectedRow(inComponent: 0) + 1
        let text = pickerData[selectedPicker.selectedRow(inComponent: 0)]

        if !product.measurementUnits.isEmpty {
            for item in product.measurementUnits {
                if !item.unit.isEmpty && "\(item.name ?? "") (\(item.amount) \(item.unit))" == text {
                    selectedPortionId = item.id
                    break
                } else if "\(item.name ?? "") (\(item.amount) \(product.isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAMS_UNIT)))" == text {
                    selectedPortionId = item.id
                    break
                } else {
                    selectedPortionId = nil
                }
            }
        } else {
            selectedPortionId = nil
        }
        closePicker()
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PremiumQuizViewController {
            let vc = segue.destination as? PremiumQuizViewController
            vc?.isAutorization = false
            vc?.trialFrom = "micro"
        }
    }
}

extension ProductDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == 0 ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsCell") as? ProductDetailsCell else { fatalError() }
            cell.fillCell(product, self, portionCount, selectedPortionId, isEditState, basketProduct)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? MenuCell else { fatalError() }
            cell.fillCell(indexPath, selectedTitle: self.selectedTitle, delegate: self)
            return cell
        }
    }
}

extension ProductDetailsViewController: ProductDetailsDelegate {
    
    func showWrongErrorCount() {
        let alert = UIAlertController(title: LS(key: .ATTENTION), message: LS(key: .ADD_PRODUCT_NEW), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        self.present(alert, animated: true)
    }
    
    func caloriesChanged(_ count: Int) {
        self.portionCount = count
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProductDetailsCell {
            cell.fillCell(product, self, portionCount, selectedPortionId, isEditState, basketProduct)
        }
    }
    
    func changeBasketProduct(product: Product) {
        delegate?.replaceProduct(newCount: portionCount, selectedPortionId)
        showSuccess()
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
    
    func showSuccess() {
        if isEditState {
            if basketProduct {
                progressTitleLabel.text = LS(key: .PRODUCT_CHANGED_IN_BUSKET)
            } else {
                reloadDiary()
                progressTitleLabel.text = LS(key: .PRODUCT_ADDED_IN_DIARY)
            }
        } else if basketProduct {
            progressTitleLabel.text = LS(key: .PRODUCT_CHANGED_IN_BUSKET)
        } else {
            reloadDiary()
            progressTitleLabel.text = LS(key: .PRODUCT_ADDED_IN_DIARY)
        }
        progressView.trackColor = .clear
        progressView.progressColor = #colorLiteral(red: 0.9344636798, green: 0.5902308822, blue: 0.1663158238, alpha: 1)
        progressContainerView.fadeIn(duration: 0.0)
        
        progressView.setProgressWithAnimation(duration: 2, value: 2) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        }
    }
    
    func showSelectedPicker() {
//        if firstLoad {
//            firstLoad = false
//            if portionCount > 0 && pickerData[0].indices.contains(portionCount - 1) {
//                selectedPicker.selectRow(portionCount - 1, inComponent: 0, animated: false)
//            }
//            for (index, item) in pickerData[1].enumerated() where item == selectedComponent {
//                selectedPicker.selectRow(index, inComponent: 1, animated: false)
//            }
//        }
        showPicker()
    }
    
    func showPremiumScreen() {
        Amplitude.instance()?.logEvent("product_page_micro") // +
        performSegue(withIdentifier: "sequePremiumScreen", sender: nil)
    }
    
    func addProductInRecipe() {
        let alert = UIAlertController(title: "Внимание", message: "Данный продукт добавлен в ваш рецепт", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ок", style: .default) { (alert) in
            self.closeModule()
        }
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func closeModule() {
        navigationController?.popViewController(animated: true)
    }
    
    func showSendError() {
        performSegue(withIdentifier: "sequeSendErrorScreen", sender: nil)
    }
}

extension ProductDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
      
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.text = pickerData[row]
        pickerLabel.font = UIFont.sfProTextRegular(size: 18)
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
}

// MARK: - LMDropdownViewDelegate
extension ProductDetailsViewController: LMDropdownViewDelegate {
    
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
