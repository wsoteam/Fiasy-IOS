//
//  IngredientsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/20/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class IngredientsViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private let flow = UserInfo.sharedInstance.recipeFlow
    private var selectedIndex: IndexPath?
    private lazy var picker: IngredientPickerService = {
        let picker = IngredientPickerService()
        picker.targetVC = self
        picker.remove = { [weak self] in
            guard let strongSelf = self, let index = strongSelf.selectedIndex else { return }
            if UserInfo.sharedInstance.recipeFlow.allProduct.indices.contains(index.row) {
                UserInfo.sharedInstance.recipeFlow.allProduct.remove(at: index.row)
                strongSelf.tableView.reloadData()
            }
        }
        return picker
    }()
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupLongPressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishClicked(_ sender: Any) {
        guard UserInfo.sharedInstance.recipeFlow.allProduct.count >= 1 else {
            return AlertComponent.sharedInctance.showAlertMessage(message: "Вам нужно добавить как минимум 1 продукт", vc: self)
        }
        performSegue(withIdentifier: "sequeAddInstructionScreen", sender: nil)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 100, right: 0)
        tableView.register(type: IngredientsTableViewCell.self)
        tableView.register(IngredientsFooterView.nib, forHeaderFooterViewReuseIdentifier: IngredientsFooterView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupLongPressGesture() {
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                self.selectedIndex = indexPath
                picker.showPicker()
            }
        }
    }
}

extension IngredientsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInfo.sharedInstance.recipeFlow.allProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell") as? IngredientsTableViewCell else { fatalError() }
        cell.fillCell(product: UserInfo.sharedInstance.recipeFlow.allProduct[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: IngredientsFooterView.reuseIdentifier) as? IngredientsFooterView else {
            return UITableViewHeaderFooterView()
        }
        footer.fillFooter(delegate: self, title: "Добавить продукт")
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return IngredientsFooterView.height
    }
}

extension IngredientsViewController: AddTemplateDelegate {
    
    func showAddPortion() {
        performSegue(withIdentifier: "sequeAddProductList", sender: nil)
    }
    
    func removePortion(index: Int) {
        
    }
    
    func fillTemplateTitle(text: String) {
        
    }
}
