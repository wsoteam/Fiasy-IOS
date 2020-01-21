//
//  AddProductViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/15/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol AddProductDelegate {
    func nextStepClicked()
    func showCodeReading()
    func switchChangeValue(state: Bool)
    func textChange(tag: Int, text: String?)
}

class AddProductViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    var productFrom = "button"
    private var selectedFavorite: Favorite?
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = self.selectedFavorite {
            //
        } else {
            UserInfo.sharedInstance.productFlow = AddProductFlow()
        }
        
        setupTableView()
        navigationTitleLabel.text = LS(key: .CREATE_STEP_TITLE_9)
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardWhenTappedAround()
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sequeBarcodeScannerScreen" {
            if let vc = segue.destination as? BarcodeViewController {
                vc.fillDelegate(delegate: self)
            }
        }
    }
    
    func fillEditProductFavorite(favorite: Favorite) {
        self.selectedFavorite = favorite
        UserInfo.sharedInstance.productFlow = AddProductFlow()
        for item in favorite.measurementUnits {
            let serving = Serving(name: item.name ?? "", unit: item.unit, size: item.amount)
            serving.selected = true
            UserInfo.sharedInstance.productFlow.allServingSize.append(serving)
        }
        
        UserInfo.sharedInstance.productFlow.selectedFavorite = favorite
        UserInfo.sharedInstance.productFlow.name = favorite.name
        UserInfo.sharedInstance.productFlow.brend = favorite.brand
        UserInfo.sharedInstance.productFlow.barCode = favorite.barcode
        UserInfo.sharedInstance.productFlow.productType = favorite.isLiquid == true ? .liquid : .product
        
        if favorite.fats != -1 {
            UserInfo.sharedInstance.productFlow.fat = "\(((favorite.fats ?? 0.0) * 100).displayOnly(count: 2))".replacingOccurrences(of: "-1.0", with: "")
        }
        if favorite.proteins != -1 {
            UserInfo.sharedInstance.productFlow.protein = "\(((favorite.proteins ?? 0.0) * 100).displayOnly(count: 2))".replacingOccurrences(of: "-1.0", with: "")
        }
        if favorite.carbohydrates != -1 {
            UserInfo.sharedInstance.productFlow.carbohydrates = "\(((favorite.carbohydrates ?? 0.0) * 100).displayOnly(count: 2))".replacingOccurrences(of: "-1.0", with: "")
        }
        if favorite.calories != -1 {
            UserInfo.sharedInstance.productFlow.calories = "\(((favorite.calories ?? 0.0) * 100).displayOnly(count: 2))".replacingOccurrences(of: "-1.0", with: "")
        }
        if favorite.cellulose != -1 {
            UserInfo.sharedInstance.productFlow.cellulose = "\(((favorite.cellulose ?? 0.0) * 100).displayOnly(count: 2))".replacingOccurrences(of: "-1.0", with: "")
        }
        if favorite.sugar != -1 {
            UserInfo.sharedInstance.productFlow.sugar = "\(((favorite.sugar ?? 0.0) * 100).displayOnly(count: 2))".replacingOccurrences(of: "-1.0", with: "")
        }
        if favorite.saturatedFats != -1 {
            UserInfo.sharedInstance.productFlow.saturatedFats = "\(((favorite.saturatedFats ?? 0.0) * 100).displayOnly(count: 2))".replacingOccurrences(of: "-1.0", with: "")
        }
        if favorite.monoUnSaturatedFats != -1 {
            UserInfo.sharedInstance.productFlow.monounsaturatedFats = "\(((favorite.monoUnSaturatedFats ?? 0.0) * 100).displayOnly(count: 2))".replacingOccurrences(of: "-1.0", with: "")
        }
        if favorite.polyUnSaturatedFats != -1 {
            UserInfo.sharedInstance.productFlow.polyunsaturatedFats = "\(((favorite.polyUnSaturatedFats ?? 0.0) * 100).displayOnly(count: 2))".replacingOccurrences(of: "-1.0", with: "")
        }
        if favorite.cholesterol != -1 {
            UserInfo.sharedInstance.productFlow.cholesterol = "\(((favorite.cholesterol ?? 0.0) * 100).displayOnly(count: 2))".replacingOccurrences(of: "-1.0", with: "")
        }
        if favorite.sodium != -1 {
            UserInfo.sharedInstance.productFlow.sodium = "\(((favorite.sodium ?? 0.0) * 100).displayOnly(count: 2))".replacingOccurrences(of: "-1.0", with: "")
        }
        if favorite.pottassium != -1 {
            UserInfo.sharedInstance.productFlow.potassium = "\(((favorite.pottassium ?? 0.0) * 100).displayOnly(count: 2))".replacingOccurrences(of: "-1.0", with: "")
        }
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        showCloseAlert()
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        showCloseAlert()
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(type: AddProductTableViewCell.self)
    }
    
    private func showCloseAlert() {
        let refreshAlert = UIAlertController(title: LS(key: .CREATE_STEP_TITLE_1), message: "", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: LS(key: .ALERT_YES), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        }))
        refreshAlert.addAction(UIAlertAction(title: LS(key: .ALERT_NO), style: .default, handler: nil))
        present(refreshAlert, animated: true)
    }
    
    private func fillBarCode(code: String) {
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
    }
}

extension AddProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddProductTableViewCell") as? AddProductTableViewCell else { fatalError() }
        cell.fillCell(indexCell: indexPath, delegate: self, barCode: UserInfo.sharedInstance.productFlow.barCode, selectedFavorite)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

extension AddProductViewController: AddProductDelegate {
    
    func switchChangeValue(state: Bool) {
        UserInfo.sharedInstance.productFlow.showAll = state
    }
    
    func textChange(tag: Int, text: String?) {
        switch tag {
        case 0:
            UserInfo.sharedInstance.productFlow.brend = text
        case 1:
            UserInfo.sharedInstance.productFlow.name = text
        case 2:
            UserInfo.sharedInstance.productFlow.barCode = text
        default:
            break
        }
    }
    
    func nextStepClicked() {
        guard let name = UserInfo.sharedInstance.productFlow.name, !name.isEmpty else {
            if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? AddProductTableViewCell {
                tableView.scrollToRow(at: IndexPath(row: 1, section: 0), at: .middle, animated: true)
                cell.errorLabel.isHidden = false
                cell.separatorView.backgroundColor = #colorLiteral(red: 0.9617733359, green: 0.6727946401, blue: 0.6699010134, alpha: 1)
                cell.nameTextField.becomeFirstResponder()
            }
            return
        }
        if name.replacingOccurrences(of: " ", with: "").isEmpty {
            return AlertComponent.sharedInctance.showAlertMessage(message: LS(key: .CREATE_STEP_TITLE_2), vc: self)
        }
        if let brand = UserInfo.sharedInstance.productFlow.brend {
            if !brand.isEmpty {
                if brand.replacingOccurrences(of: " ", with: "").isEmpty {
                    return AlertComponent.sharedInctance.showAlertMessage(message: LS(key: .CREATE_STEP_TITLE_3), vc: self)
                }
            } else {
                UserInfo.sharedInstance.productFlow.brend = nil
            }
        }
        view.endEditing(true)
        performSegue(withIdentifier: "sequeServingSizeScreen", sender: nil)
    }
    
    func showCodeReading() {
        performSegue(withIdentifier: "sequeBarcodeScannerScreen", sender: nil)
    }
}

extension AddProductViewController: BarcodeDelegate {
    
    func foundBarcode(code: String) {
        UserInfo.sharedInstance.productFlow.barCode = code
        fillBarCode(code: code)
    }
}
