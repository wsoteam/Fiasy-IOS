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
    func menuClicked(indexPath: IndexPath)
    func changeBasketProduct(product: Product)
}

class ProductDetailsViewController: UIViewController {
    
    // MARK: - Outlet -
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
    private var pickerData: [[String]] = []
    private var isEditState: Bool = false
    private lazy var dropdownView: LMDropdownView = LMDropdownView()
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var firstLoad: Bool = true
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tag = 0
        menuTableView.tag = 1
        setupInitialState()
        setupTableView()
        setupPickerData()
        setupInitialState()
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
        self.checkTitle(title: title)
        self.product = product
        if let weight = product.weight, weight > 0 {
            self.isEditState = true
            self.portionCount = weight
        } else if basketProduct == true {
            if let portion = product.selectedPortion {
                portionCount = 1
            } else {
                portionCount = 100
            }
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
            selectedTitle = "Завтрак"
        case 1:
            selectedTitle = "Обед"
        case 2:
            selectedTitle = "Ужин"
        case 3:
            selectedTitle = "Перекус"
        default:
            break
        }
        titleButton.setTitle("\(selectedTitle)  ", for: .normal)
    }
    
    private func checkTitle(title: String) {
        switch title {
        case "Завтрак":
            UserInfo.sharedInstance.selectedMealtimeIndex = 0
        case "Обед":
            UserInfo.sharedInstance.selectedMealtimeIndex = 1
        case "Ужин":
            UserInfo.sharedInstance.selectedMealtimeIndex = 2
        case "Перекус":
            UserInfo.sharedInstance.selectedMealtimeIndex = 3
        default:
            break
        }
    }
    
    private func setupPickerData() {
        guard let product = self.product else { return }
        var leftSide: [String] = []
        var rightSide: [String] = []
        for index in 1...999 {
            leftSide.append("\(index)")
        }
        
        if !product.measurementUnits.isEmpty {
            for item in product.measurementUnits {
                if !item.unit.isEmpty {
                    rightSide.append("\(item.name ?? "") (\(item.amount) \(item.unit))")
                } else {
                    rightSide.append("\(item.name ?? "") (\(item.amount) \(product.isLiquid == true ? "мл" : "г"))")
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
                        rightSide.insert("\(item.name ?? "") (\(item.amount) \(product.isLiquid == true ? "мл" : "г"))", at: 0)
                    }
                }
                break
            }
            rightSide.append(product.isLiquid == true ? "мл" : "грамм")
        } else {
            rightSide.insert(product.isLiquid == true ? "мл" : "грамм", at: 0)
        }
        
        pickerData.append(leftSide)
        pickerData.append(rightSide)
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
    
    @IBAction func titleButtonClicked(_ sender: Any) {
        menuTableView.reloadData()
        showDropdownView(fromDirection: .top)
    }
    
    @IBAction func closePickerClicked(_ sender: Any) {
        closePicker()
    }
    
    @IBAction func addWeightClicked(_ sender: Any) {
        guard let product = self.product else { return }
        self.portionCount = selectedPicker.selectedRow(inComponent: 0) + 1
        let text = pickerData[1][selectedPicker.selectedRow(inComponent: 1)]

        if !product.measurementUnits.isEmpty {
            for item in product.measurementUnits {
                if !item.unit.isEmpty && "\(item.name ?? "") (\(item.amount) \(item.unit))" == text {
                    selectedPortionId = item.id
                    break
                } else if "\(item.name ?? "") (\(item.amount) \(product.isLiquid == true ? "мл" : "г"))" == text {
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
                progressTitleLabel.text = "Продукт изменен в корзине"
            } else {
                reloadDiary()
                progressTitleLabel.text = "Продукт изменен в дневнике"
            }
        } else if basketProduct {
            progressTitleLabel.text = "Продукт изменен в корзине"
        } else {
            reloadDiary()
            progressTitleLabel.text = "Продукт добавлен в дневник"
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
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
      
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.text = pickerData[component][row]
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
