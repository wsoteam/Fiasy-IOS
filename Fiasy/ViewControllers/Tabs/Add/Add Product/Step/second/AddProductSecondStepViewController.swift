//
//  AddProductSecondStepViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/15/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class AddProductSecondStepViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        navigationTitleLabel.text = LS(key: .CREATE_STEP_TITLE_30)
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
    
    @IBAction func closeClicked(_ sender: Any) {
        showCloseAlert()
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: AddProductSecondStepCell.self)
        tableView.register(AddProductFooterTableView.nib, forHeaderFooterViewReuseIdentifier: AddProductFooterTableView.reuseIdentifier)
    }
    
    private func showCloseAlert() {
        let refreshAlert = UIAlertController(title: LS(key: .CREATE_STEP_TITLE_1), message: "", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: LS(key: .ALERT_YES), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard let strongSelf = self else { return }
            let viewControllers: [UIViewController] = strongSelf.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is MyСreatedProductsViewController {
                    strongSelf.navigationController?.popToViewController(aViewController, animated: true)
                }
            }
            strongSelf.navigationController?.popViewController(animated: true)
        }))
        refreshAlert.addAction(UIAlertAction(title: LS(key: .ALERT_NO), style: .default, handler: nil))
        present(refreshAlert, animated: true)
    }
}

extension AddProductSecondStepViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddProductSecondStepCell") as? AddProductSecondStepCell else { fatalError() }
        cell.fillCell(indexPath: indexPath, delegate: self, flow: UserInfo.sharedInstance.productFlow)
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

extension AddProductSecondStepViewController: AddProductDelegate {
    func showCodeReading() {}
    func switchChangeValue(state: Bool) {}
    
    func nextStepClicked() {
        guard let calories = UserInfo.sharedInstance.productFlow.calories, !calories.replacingOccurrences(of: ".", with: "").isEmpty else {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddProductSecondStepCell {
                cell.errorLabel.isHidden = false
                cell.separatorView.backgroundColor = #colorLiteral(red: 0.9617733359, green: 0.6727946401, blue: 0.6699010134, alpha: 1)
                cell.nameTextField.becomeFirstResponder()
            }
            return
        }
        guard let fat = UserInfo.sharedInstance.productFlow.fat, !fat.replacingOccurrences(of: ".", with: "").isEmpty else {
            if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? AddProductSecondStepCell {
                cell.errorLabel.isHidden = false
                cell.separatorView.backgroundColor = #colorLiteral(red: 0.9617733359, green: 0.6727946401, blue: 0.6699010134, alpha: 1)
                cell.nameTextField.becomeFirstResponder()
            }
            return
        }
        guard let carbohydrates = UserInfo.sharedInstance.productFlow.carbohydrates, !carbohydrates.replacingOccurrences(of: ".", with: "").isEmpty else {
            if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? AddProductSecondStepCell {
                cell.errorLabel.isHidden = false
                cell.separatorView.backgroundColor = #colorLiteral(red: 0.9617733359, green: 0.6727946401, blue: 0.6699010134, alpha: 1)
                cell.nameTextField.becomeFirstResponder()
            }
            return
        }
        guard let protein = UserInfo.sharedInstance.productFlow.protein, !protein.replacingOccurrences(of: ".", with: "").isEmpty else {
            if let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? AddProductSecondStepCell {
                cell.errorLabel.isHidden = false
                cell.separatorView.backgroundColor = #colorLiteral(red: 0.9617733359, green: 0.6727946401, blue: 0.6699010134, alpha: 1)
                cell.nameTextField.becomeFirstResponder()
            }
            return
        }
        view.endEditing(true)
        performSegue(withIdentifier: "sequeAddProductThirdStep", sender: nil)
    }
    
    func textChange(tag: Int, text: String?) {
        switch tag {
        case 0:
            UserInfo.sharedInstance.productFlow.calories = text
        case 1:
            UserInfo.sharedInstance.productFlow.fat = text
        case 2:
            UserInfo.sharedInstance.productFlow.carbohydrates = text
        case 3:
            UserInfo.sharedInstance.productFlow.protein = text
        default:
            break
        }
    }
}
