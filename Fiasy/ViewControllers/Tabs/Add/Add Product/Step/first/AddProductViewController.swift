//
//  AddProductViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/15/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import BarcodeScanner

protocol AddProductDelegate {
    
    func nextStepClicked()
    func showCodeReading()
    func switchChangeValue(state: Bool)
    func textChange(tag: Int, text: String?)
}

class AddProductViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    var productFrom = "button"
    private var selectedFavorite: Favorite?
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
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
    
    func fillEditProductFavorite(favorite: Favorite) {
        UserInfo.sharedInstance.productFlow = AddProductFlow()
        self.selectedFavorite = favorite
        
        UserInfo.sharedInstance.productFlow.selectedFavorite = favorite
        UserInfo.sharedInstance.productFlow.name = favorite.name
        UserInfo.sharedInstance.productFlow.brend = favorite.brand
        UserInfo.sharedInstance.productFlow.barCode = favorite.barcode
        
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
        let refreshAlert = UIAlertController(title: "Хотите выйти без сохранения?", message: "", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(refreshAlert, animated: true)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: AddProductTableViewCell.self)
        tableView.register(AddProductFooterTableView.nib, forHeaderFooterViewReuseIdentifier: AddProductFooterTableView.reuseIdentifier)
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: AddProductFooterTableView.reuseIdentifier) as? AddProductFooterTableView else {
            return nil
        }
        footer.fillFooter(delegate: self)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0000001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return AddProductFooterTableView.height
    }
}

extension AddProductViewController: AddProductDelegate, BarcodeScannerCodeDelegate, BarcodeScannerDismissalDelegate {
    
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
                cell.nameTextField.becomeFirstResponder()
            }
            return AlertComponent.sharedInctance.showAlertMessage(message: "Введите название продукта", vc: self)
        }
        if name.replacingOccurrences(of: " ", with: "").isEmpty {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Имя не может состоять только из пробелов", vc: self)
        }
        if let brand = UserInfo.sharedInstance.productFlow.brend {
            if !brand.isEmpty {
                if brand.replacingOccurrences(of: " ", with: "").isEmpty {
                    return AlertComponent.sharedInctance.showAlertMessage(message: "'Марка/Производитель' не может состоять только из пробелов", vc: self)
                }
            } else {
                UserInfo.sharedInstance.productFlow.brend = nil
            }
        }

        performSegue(withIdentifier: "sequeAddProductSecondStep", sender: nil)
    }
    
    func showCodeReading() {
        let viewController = BarcodeScannerViewController()
        viewController.headerViewController.titleLabel.text = "Сканирование штрих-кода"
        viewController.codeDelegate = self
        viewController.dismissalDelegate = self
        viewController.messageViewController.messages.scanningText = "Поместите штрих-код в окно для сканирования. Поиск начнется автоматически."
        present(viewController, animated: true)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        UserInfo.sharedInstance.productFlow.barCode = code
        fillBarCode(code: code)
        controller.dismiss(animated: true)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true)
    }
}

