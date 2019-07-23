//
//  AddPortionViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol AddPortionDelegate {
    func fillTextInfo(index: Int, text: String)
}

class AddPortionViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var finishButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var name: String = ""
    private var size: String = ""
    
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
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Action -
    @IBAction func finishClicked(_ sender: Any) {
        guard !name.isEmpty else {
            return AlertComponent.sharedInctance.showAlertMessage(title: "Внимание",
                                                         message: "Введите 'Наименование порции'",
                                                              vc: self)
        }
        guard !size.isEmpty else {
            return AlertComponent.sharedInctance.showAlertMessage(title: "Внимание",
                                                         message: "Введите 'Размер порции'",
                                                              vc: self)
        }
        UserInfo.sharedInstance.templateArray.append([name,"Грамм", size])
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: AddPortionTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension AddPortionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddPortionTableViewCell") as? AddPortionTableViewCell else { fatalError() }
        cell.fillCell(index: indexPath.row, delegate: self)
        return cell
    }
}

extension AddPortionViewController: AddPortionDelegate {
    
    func fillTextInfo(index: Int, text: String) {
        switch index {
        case 0:
            name = text
        default:
            size = text
        }
    }
}
