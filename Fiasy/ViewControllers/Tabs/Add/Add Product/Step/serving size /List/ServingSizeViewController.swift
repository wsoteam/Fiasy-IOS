//
//  ServingSizeViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol ServingSizeDelegate {
    func changeServingSize(index: Int)
}

class ServingSizeViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sequeServingSizeScreen" {
            if let vc = segue.destination as? ServingSizeDetailsViewController {
                if let model = sender as? Serving {
                    vc.fillModel(model: model)
                }
            }
        }
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        performSegue(withIdentifier: "sequeAddProductSecondStep", sender: nil)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: ServingSizeCell.self)
        tableView.register(type: ServingSizeHeaderCell.self)
        tableView.register(IngredientsFooterView.nib, forHeaderFooterViewReuseIdentifier: IngredientsFooterView.reuseIdentifier)
    }
    
    private func showСonfirmationOfDeletion(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        guard let view = BasketAlertView.fromXib() else { return }
        view.descriptionLabel.text = "Вы точно хотите удалить?"
        alertController.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 15).isActive = true
        view.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        view.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let removeAction = UIAlertAction(title: "Удалить", style: .default) { [weak self] (alert) in
            guard let strongSelf = self else { return }
            UserInfo.sharedInstance.productFlow.allServingSize.remove(at: indexPath.row - 2)
            strongSelf.removeRow(indexPath)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        cancelAction.setValue(#colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), forKey: "titleTextColor")
        removeAction.setValue(#colorLiteral(red: 0.9231546521, green: 0.3429711461, blue: 0.342156291, alpha: 1), forKey: "titleTextColor")
        
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func removeRow(_ indexPath: IndexPath) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .left)
            self.tableView.endUpdates()
        })
        CATransaction.commit()
    }
}

extension ServingSizeViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserInfo.sharedInstance.productFlow.allServingSize.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServingSizeHeaderCell") as? ServingSizeHeaderCell else { fatalError() }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServingSizeCell") as? ServingSizeCell else { fatalError() }
            let item = UserInfo.sharedInstance.productFlow.allServingSize[indexPath.row - 1]
            cell.fillCell(serving: item, screenDelegate: self, index: indexPath.row - 1)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right, (indexPath.row != 0 && indexPath.row != 1) else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
            guard let strongSelf = self else { return }
            strongSelf.showСonfirmationOfDeletion(indexPath: indexPath)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "Combined Shape (1)")
        deleteAction.hidesWhenSelected = true
        deleteAction.backgroundColor = #colorLiteral(red: 0.9231601357, green: 0.3388705254, blue: 0.3422900438, alpha: 1)
        return [deleteAction]
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
        performSegue(withIdentifier: "sequeServingSizeScreen", sender: nil)
    }
    func removePortion(index: Int) {}
    func fillTemplateTitle(text: String) {}
}

extension ServingSizeViewController: ServingSizeDelegate {
    
    func changeServingSize(index: Int) {
        let item = UserInfo.sharedInstance.productFlow.allServingSize[index]
        item.index = index
        performSegue(withIdentifier: "sequeServingSizeScreen", sender: item)
    }
}
