//
//  DishDetailsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/15/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS
import SwiftEntryKit
import VisualEffectView

protocol DishDetailsDelegate {
    func showSuccess()
    func menuClicked(indexPath: IndexPath)
    func showWrongErrorCount()
    func caloriesChanged(_ count: Int)
}

class DishDetailsViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var editButton: UIButton!
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
    private var pickerData: [String] = []
    private var selectedTitle: String = ""
    private var selectedDish: Dish?
    private var portionCount: Int = 0
    private let isIphone5 = Display.typeIsLike == .iphone5
    private lazy var dropdownView: LMDropdownView = LMDropdownView()
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
        fillTitleNavigation(index: UserInfo.sharedInstance.selectedMealtimeIndex)
        
//        if let _ = selectedDish?.generalKeyByEdit {
//            editButton.isHidden = true
//            titleButton.setImage(UIImage(), for: .normal)
//        } else {
//            editButton.isHidden = false
//        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDishScreen" {
            if let vc = segue.destination as? DishCreateFirstViewController, let dish = self.selectedDish {
                vc.fillScreenByDish(dish: dish)
                vc.backTwice = true
            }
        }
    }
    
    func fillScreenByDish(dish: Dish) {
        self.selectedDish = dish
        if let _ = dish.generalKeyByEdit, let count = dish.weight {
            self.portionCount = count
        }
        self.selectedDish?.createdProduct = Dish.fetchCreatedProduct(dish: dish)
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
        
//        if let weight = product?.weight, weight > 0 {
//            self.titleButton.isEnabled = false
//            self.titleButton.setImage(nil, for: .normal)
//        }
//        if basketProduct == true {
//            self.titleButton.isEnabled = false
//            self.titleButton.setImage(nil, for: .normal)
//        }
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.register(type: DishDetailsTableCell.self)
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
    
    private func showPicker() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3) { 
            if let background = self.pickerContainerView.superview {
                background.fadeIn()
            }
            self.pickerContainerView.frame = CGRect(x: 0, y: self.view.bounds.size.height - self.pickerContainerView.bounds.size.height, width: UIScreen.main.bounds.width, height: self.pickerContainerView.bounds.size.height)
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
    
    //MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func titleButtonClicked(_ sender: Any) {
        if let _ = self.selectedDish?.generalKeyByEdit { return }
        menuTableView.reloadData()
        showDropdownView(fromDirection: .top)
    }
    
    @IBAction func closePickerClicked(_ sender: Any) {
        closePicker()
    }
    
    @IBAction func addWeightClicked(_ sender: Any) {
        //
    }
    
    @IBAction func editClicked(_ sender: Any) {
        performSegue(withIdentifier: "editDishScreen", sender: nil)
    }
}

extension DishDetailsViewController: LMDropdownViewDelegate {
    
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

extension DishDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == 0 ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DishDetailsTableCell") as? DishDetailsTableCell else { fatalError() }
            cell.fillCell(self.selectedDish, self, portionCount, 0)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? MenuCell else { fatalError() }
            cell.fillSecondCell(indexPath, selectedTitle: self.selectedTitle, delegate: self)
            return cell
        }
    }
}

extension DishDetailsViewController: DishDetailsDelegate {
    
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
    
    func showWrongErrorCount() {
        let alert = UIAlertController(title: LS(key: .ATTENTION), message: LS(key: .ADD_PRODUCT_NEW), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        self.present(alert, animated: true)
    }
    
    func caloriesChanged(_ count: Int) {
        self.portionCount = count
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DishDetailsTableCell {
            cell.fillCell(self.selectedDish, self, count, 0)
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
}
