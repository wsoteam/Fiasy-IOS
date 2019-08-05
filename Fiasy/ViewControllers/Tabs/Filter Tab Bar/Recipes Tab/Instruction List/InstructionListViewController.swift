//
//  InstructionListViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol InstructionListDelegate {
    func addNewInstruction()
    func removeRow(_ indexPath: IndexPath)
    func fillInstructionText(tag: Int, text: String)
}

class InstructionListViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!

    // MARK: - Properties -


    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let _ = touch.view as? UITableViewCell {
            return false
        }
        return true
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextStepClicked(_ sender: Any) {
        if UserInfo.sharedInstance.recipeFlow.instructionsList.isEmpty {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Пожалуйста, добавьте инструкцию по приготовлению", vc: self)
        }
        for (index,item) in UserInfo.sharedInstance.recipeFlow.instructionsList.enumerated() where item.replacingOccurrences(of: " ", with: "").isEmpty {
            AlertComponent.sharedInctance.showSecondAlertMessage(message: "Один из пунктов не может быть пустым", vc: self) {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? InstructionListTableCell {
                    cell.textView.becomeFirstResponder()
                }
            }
            return
        }
        performSegue(withIdentifier: "sequeCheckRecipeScreen", sender: nil)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
        tableView.register(type: InstructionListTableCell.self)
        tableView.register(InstructionListFooterView.nib, forHeaderFooterViewReuseIdentifier: InstructionListFooterView.reuseIdentifier)
    }
}

extension InstructionListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInfo.sharedInstance.recipeFlow.instructionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionListTableCell") as? InstructionListTableCell else { fatalError() }
        if UserInfo.sharedInstance.recipeFlow.instructionsList.indices.contains(indexPath.row) {
            cell.fillCell(tableView, indexPath, self, UserInfo.sharedInstance.recipeFlow.instructionsList[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: InstructionListFooterView.reuseIdentifier) as? InstructionListFooterView else {
            return nil
        }
        footer.fillFooter(delegate: self)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0000001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return InstructionListFooterView.height
    }
}

extension InstructionListViewController: InstructionListDelegate {
    
    func fillInstructionText(tag: Int, text: String) {
        if UserInfo.sharedInstance.recipeFlow.instructionsList.indices.contains(tag) {
            UserInfo.sharedInstance.recipeFlow.instructionsList[tag] = text
        }
    }
    
    func removeRow(_ indexPath: IndexPath) {
        if UserInfo.sharedInstance.recipeFlow.instructionsList.indices.contains(indexPath.row) {
            UserInfo.sharedInstance.recipeFlow.instructionsList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func addNewInstruction() {
        UserInfo.sharedInstance.recipeFlow.instructionsList.append("")
        let indexPath = IndexPath(row: UserInfo.sharedInstance.recipeFlow.instructionsList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)
        
        if let cell = self.tableView.cellForRow(at: indexPath) as? InstructionListTableCell {
            cell.textView.becomeFirstResponder()
        }
    }
}
