//
//  AddProductThirdViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/15/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class AddProductThirdViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
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
        tableView.register(type: AddProductSecondStepCell.self)
        tableView.register(AddProductFooterTableView.nib, forHeaderFooterViewReuseIdentifier: AddProductFooterTableView.reuseIdentifier)
    }
    
    private func checkCorrectFields(array: [String]) -> Int? {
        for (index, item) in array.enumerated() where !item.isEmpty {
            //item.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: "0", with: "")
            if item.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "").isEmpty {
                return index
            }
        }
        return nil
    }
}

extension AddProductThirdViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddProductSecondStepCell") as? AddProductSecondStepCell else { fatalError() }
        cell.fillSecondCell(indexPath: indexPath, delegate: self, UserInfo.sharedInstance.productFlow)
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

extension AddProductThirdViewController: AddProductDelegate {
    func showCodeReading() {}
    func switchChangeValue(state: Bool) {}
    
    func nextStepClicked() {
        if let index = checkCorrectFields(array: UserInfo.sharedInstance.productFlow.getFields()) {
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? AddProductSecondStepCell {
                cell.nameTextField.resignFirstResponder()
            }
            return AlertComponent.sharedInctance.showAlertMessage(message: "Пожалуйста, проверьте правильность введенных данных", vc: self)
        } else {
            performSegue(withIdentifier: "sequeAddProductLastStep", sender: nil)
        }
    }
    
    func textChange(tag: Int, text: String?) {
        switch tag {
        case 0:
            UserInfo.sharedInstance.productFlow.cellulose = text
        case 1:
            UserInfo.sharedInstance.productFlow.sugar = text
        case 2:
            UserInfo.sharedInstance.productFlow.saturatedFats = text
        case 3:
            UserInfo.sharedInstance.productFlow.monounsaturatedFats = text
        case 4:
            UserInfo.sharedInstance.productFlow.polyunsaturatedFats = text
        case 5:
            UserInfo.sharedInstance.productFlow.cholesterol = text
        case 6:
            UserInfo.sharedInstance.productFlow.sodium = text
        case 7:
            UserInfo.sharedInstance.productFlow.potassium = text
        default:
            break
        }
    }
}
