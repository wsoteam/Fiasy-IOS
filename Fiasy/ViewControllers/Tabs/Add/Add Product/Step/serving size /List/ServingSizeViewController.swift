//
//  ServingSizeViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol ServingSizeDelegate {
    func changeServingSize(index: Int)
    func servingClicked(_ checkMark: BEMCheckBox, _ serving: Serving)
}

class ServingSizeViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var nextButtonBackgroundView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleNavigationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        nextButton.setTitle("\(LS(key: .UNBOARDING_NEXT)) ", for: .normal)
        titleNavigationLabel.text = LS(key: .CREATE_STEP_TITLE_17)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkServingSize()
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
    
    @IBAction func closeClicked(_ sender: Any) {
        showCloseAlert()
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        performSegue(withIdentifier: "sequeAddProductSecondStep", sender: nil)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: ServingSizeCell.self)
        tableView.register(type: ServingSizeHeaderCell.self)
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
        }))
        refreshAlert.addAction(UIAlertAction(title: LS(key: .ALERT_NO), style: .default, handler: nil))
        present(refreshAlert, animated: true)
    }
    
    private func showСonfirmationOfDeletion(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        guard let view = BasketAlertView.fromXib() else { return }
        view.descriptionLabel.text = LS(key: .CREATE_STEP_TITLE_13)
        alertController.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 15).isActive = true
        view.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        view.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let removeAction = UIAlertAction(title: LS(key: .DELETE), style: .default) { [weak self] (alert) in
            guard let strongSelf = self else { return }
            UserInfo.sharedInstance.productFlow.allServingSize.remove(at: indexPath.row - 2)
            strongSelf.checkServingSize()
            strongSelf.removeRow(indexPath)
        }
        let cancelAction = UIAlertAction(title: LS(key: .CANCEL), style: .cancel)
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
    
    private func checkServingSize() {
        var isContains: Bool = false
        for item in UserInfo.sharedInstance.productFlow.allServingSize where item.selected == true {
            isContains = true
            break
        }
        nextButtonBackgroundView.backgroundColor = isContains ? #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)  : #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
        nextButton.isEnabled = isContains
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
            cell.fillCell(delegate: self)
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
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
    
    func servingClicked(_ checkMark: BEMCheckBox, _ serving: Serving) {
        var isContains: Bool = false
        for item in UserInfo.sharedInstance.productFlow.allServingSize where item.selected == true {
            isContains = true
            break
        }
        if isContains && !checkMark.on {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ServingSizeHeaderCell {
                cell.errorLabel.isHidden = false
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            return
        }
        checkMark.setOn(!checkMark.on, animated: true)
        let list = UserInfo.sharedInstance.productFlow.allServingSize
        for (index, item) in list.enumerated() where item.name == serving.name && item.unitMeasurement == serving.unitMeasurement {
            UserInfo.sharedInstance.productFlow.allServingSize[index].selected = checkMark.on
        }
        checkServingSize()
    }

    func changeServingSize(index: Int) {
        let item = UserInfo.sharedInstance.productFlow.allServingSize[index]
        item.index = index
        performSegue(withIdentifier: "sequeServingSizeScreen", sender: item)
    }
}
