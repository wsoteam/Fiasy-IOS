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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private var flow = UserInfo.sharedInstance.productFlow
    
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
}

extension AddProductSecondStepViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddProductSecondStepCell") as? AddProductSecondStepCell else { fatalError() }
        cell.fillCell(indexPath: indexPath, delegate: self)
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
        guard let calories = flow.calories, !calories.replacingOccurrences(of: ".", with: "").isEmpty else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Введите количество калорий в продукте", vc: self)
        }
        guard let fat = flow.fat, !fat.replacingOccurrences(of: ".", with: "").isEmpty else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Введите количество жиров в продукте", vc: self)
        }
        guard let carbohydrates = flow.carbohydrates, !carbohydrates.replacingOccurrences(of: ".", with: "").isEmpty else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Введите количество углеводов в продукте", vc: self)
        }
        guard let protein = flow.protein, !protein.replacingOccurrences(of: ".", with: "").isEmpty else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Введите количество белков в продукте", vc: self)
        }
        UserInfo.sharedInstance.productFlow = self.flow
        performSegue(withIdentifier: "sequeAddProductThirdStep", sender: nil)
    }
    
    func textChange(tag: Int, text: String?) {
        switch tag {
        case 0:
            flow.calories = text
        case 1:
            flow.fat = text
        case 2:
            flow.carbohydrates = text
        case 3:
            flow.protein = text
        default:
            break
        }
    }
}
