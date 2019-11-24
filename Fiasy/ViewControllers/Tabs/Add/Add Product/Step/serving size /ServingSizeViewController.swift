//
//  ServingSizeViewController.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 11/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ServingSizeViewController: UIViewController {
    
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
        
        tableView.reloadData()
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: ServingSizeCell.self)
        tableView.register(type: ServingSizeHeaderCell.self)
        tableView.register(IngredientsFooterView.nib, forHeaderFooterViewReuseIdentifier: IngredientsFooterView.reuseIdentifier)
    }
}

extension ServingSizeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInfo.sharedInstance.recipeFlow.allServingSize.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServingSizeHeaderCell") as? ServingSizeHeaderCell else { fatalError() }
            //cell.fillCell(product: UserInfo.sharedInstance.recipeFlow.allProduct[indexPath.row])
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServingSizeCell") as? ServingSizeCell else { fatalError() }
            //cell.fillCell(product: UserInfo.sharedInstance.recipeFlow.allProduct[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: IngredientsFooterView.reuseIdentifier) as? IngredientsFooterView else {
            return UITableViewHeaderFooterView()
        }
        footer.fillFooter(delegate: self, title: "Добавить размер порции")
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return IngredientsFooterView.height
    }
}

extension ServingSizeViewController: AddTemplateDelegate {
    
    func showAddPortion() {
        performSegue(withIdentifier: "sequeAddProductList", sender: nil)
    }
    
    func removePortion(index: Int) {
        
    }
    
    func fillTemplateTitle(text: String) {
        
    }
}
