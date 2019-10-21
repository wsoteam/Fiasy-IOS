//
//  AddTemplateViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS

protocol AddTemplateDelegate {
    func showAddPortion()
    func removePortion(index: Int)
    func fillTemplateTitle(text: String)
}

class AddTemplateViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!
    @IBOutlet weak var finishButtonConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private var name: String = ""
    private var generalKey: String?
    private var selectedTemplate: Template?
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
        hideKeyboardWhenTappedAround()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    func fillTemplate(template: Template) {
        self.selectedTemplate = template
        name = template.name ?? ""
        self.generalKey = template.generalKey
        UserInfo.sharedInstance.templateArray = template.fields
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishClicked(_ sender: Any) {
        guard !name.isEmpty else {
            return AlertComponent.sharedInctance.showAlertMessage(title: "Внимание",
                                                         message: "Назовите свой прием пищи",
                                                              vc: self)
        }
        if name.replacingOccurrences(of: " ", with: "").isEmpty {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Имя не может состоять только из пробелов", vc: self)
        }
        guard !UserInfo.sharedInstance.templateArray.isEmpty else {
            return AlertComponent.sharedInctance.showAlertMessage(title: "Внимание",
                                                         message: "Добавьте порцию",
                                                              vc: self)
        }
        FirebaseDBManager.saveTemplate(titleName: name, generalKey: self.generalKey)
        
        Amplitude.instance()?.logEvent("custom_template_success") // +
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: AddTemplateListCell.self)
        tableView.register(type: AddTemplateHeaderCell.self)
        tableView.register(IngredientsFooterView.nib, forHeaderFooterViewReuseIdentifier: IngredientsFooterView.reuseIdentifier)
    }
}

extension AddTemplateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInfo.sharedInstance.templateArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddTemplateHeaderCell") as? AddTemplateHeaderCell else { fatalError() }
            cell.fillCell(by: self, selectedTemplate: selectedTemplate, name: name)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddTemplateListCell") as? AddTemplateListCell else { fatalError() }
            if UserInfo.sharedInstance.templateArray.indices.contains(indexPath.row - 1) {
                cell.fillCell(UserInfo.sharedInstance.templateArray[indexPath.row - 1], indexPath, self)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: IngredientsFooterView.reuseIdentifier) as? IngredientsFooterView else {
            return UITableViewHeaderFooterView()
        }
        footer.fillFooter(delegate: self, title: "Добавить порцию")
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return IngredientsFooterView.height
    }
}

extension AddTemplateViewController: AddTemplateDelegate {
    
    func fillTemplateTitle(text: String) {
        self.name = text
    }
    
    func removePortion(index: Int) {
        var indexPath: IndexPath?
        if UserInfo.sharedInstance.templateArray.indices.contains(index - 1) {
            UserInfo.sharedInstance.templateArray.remove(at: index - 1)
            indexPath = IndexPath(row: index, section: 0)
        }
        if let index = indexPath {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [index], with: .left)
                self.tableView.endUpdates()
            })
            CATransaction.commit()
        }
    }
    
    func showAddPortion() {
        performSegue(withIdentifier: "sequeAddPortsion", sender: nil)
    }
}
