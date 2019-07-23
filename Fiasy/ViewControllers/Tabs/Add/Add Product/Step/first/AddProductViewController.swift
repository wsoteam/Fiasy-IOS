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
    private var flow = AddProductFlow()
    
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
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
        cell.fillCell(indexCell: indexPath, delegate: self, barCode: flow.barCode)
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
        flow.showAll = state
    }
    
    func textChange(tag: Int, text: String?) {
        switch tag {
        case 0:
            flow.brend = text
        case 1:
            flow.name = text
        case 2:
            flow.barCode = text
        default:
            break
        }
    }
    
    func nextStepClicked() {
        guard let _ = flow.name else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Введите название продукта", vc: self)
        }
        UserInfo.sharedInstance.productFlow = self.flow
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
        flow.barCode = code
        controller.dismiss(animated: true)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true)
    }
}

