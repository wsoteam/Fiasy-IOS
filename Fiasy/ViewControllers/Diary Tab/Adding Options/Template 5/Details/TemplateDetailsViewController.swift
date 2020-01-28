//
//  TemplateDetailsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 12/27/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS
import SwiftEntryKit
import VisualEffectView

class TemplateDetailsViewController: UIViewController {
    
    // MARK: - Outlet -
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
    private var selectedTitle: String = ""
    private var template: Template?
    private lazy var dropdownView: LMDropdownView = LMDropdownView()
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var firstLoad: Bool = true
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.setTitle("     \(LS(key: .CANCEL).uppercased())     ", for: .normal)
        finishButton.setTitle("     \(LS(key: .DONE).uppercased())     ", for: .normal)
        tableView.tag = 0
        menuTableView.tag = 1
        setupInitialState()
        setupTableView()
        setupInitialState()
        fillTitleNavigation(index: UserInfo.sharedInstance.selectedMealtimeIndex)
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
    
    func fillScreenByTemplate(_ template: Template) {
        self.template = template
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
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.register(type: TemplateDetailsTableCell.self)
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

    //MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func titleButtonClicked(_ sender: Any) {
        menuTableView.reloadData()
        showDropdownView(fromDirection: .top)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PremiumQuizViewController {
            let vc = segue.destination as? PremiumQuizViewController
            vc?.isAutorization = false
            vc?.trialFrom = "micro"
        }
    }
}

extension TemplateDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == 0 ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateDetailsTableCell") as? TemplateDetailsTableCell else { fatalError() }
            if let template = self.template {
                cell.fillCell(template, self)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? MenuCell else { fatalError() }
            cell.fillCell(indexPath, selectedTitle: self.selectedTitle, delegate: self)
            return cell
        }
    }
}

extension TemplateDetailsViewController: ProductDetailsDelegate {
    
    func changeTemplateProduct(product: Product) {
        //
    }
    
    func showSelectedPicker() {}
    func showWrongErrorCount() {
        let alert = UIAlertController(title: LS(key: .ATTENTION), message: LS(key: .ADD_PRODUCT_NEW), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        self.present(alert, animated: true)
    }
    
    func caloriesChanged(_ count: Int) {
//        self.portionCount = count
//        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ProductDetailsCell {
//            cell.fillCell(product, self, portionCount, selectedPortionId, isEditState, basketProduct)
//        }
    }
    
    func changeBasketProduct(product: Product) {
//        delegate?.replaceProduct(newCount: portionCount, selectedPortionId)
//        showSuccess()
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
        reloadDiary()
        progressTitleLabel.text = LS(key: .PRODUCT_ADDED_IN_DIARY2)
        
        progressView.trackColor = .clear
        progressView.progressColor = #colorLiteral(red: 0.9344636798, green: 0.5902308822, blue: 0.1663158238, alpha: 1)
        progressContainerView.fadeIn(duration: 0.0)
        
        progressView.setProgressWithAnimation(duration: 2, value: 2) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        }
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

// MARK: - LMDropdownViewDelegate
extension TemplateDetailsViewController: LMDropdownViewDelegate {
    
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
