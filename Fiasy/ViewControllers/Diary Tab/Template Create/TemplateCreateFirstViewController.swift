//
//  TemplateCreateFirstViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 12/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol TemplateCreateDelegate {
    func editProduct(count: Int, product: Product)
    func activeFinishButton(_ state: Bool)
}

class TemplateCreateFirstViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var nextButtonBackgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carboLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private var editTemplate: Template?
    private var firstLoad: Bool = true

    weak var header: TemplateCreateFirstHeaderView?
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserInfo.sharedInstance.templateName = ""
        UserInfo.sharedInstance.templateProductList.removeAll()
        UserInfo.sharedInstance.templateEditKey = nil
        if let template = editTemplate {
            UserInfo.sharedInstance.templateEditKey = template.generalKey
            UserInfo.sharedInstance.templateName = template.name ?? ""
            UserInfo.sharedInstance.templateProductList = template.products
            
            var callories: Int = 0
            var protein: Int = 0
            var carbohydrates: Int = 0
            var fats: Int = 0
            for item in template.products {
                if let weg = item.weight {
                    callories += Int(((item.calories ?? 0.0) * Double(weg)).rounded(toPlaces: 0))
                    protein += Int(((item.proteins ?? 0.0) * Double(weg)).rounded(toPlaces: 0))
                    carbohydrates += Int(((item.carbohydrates ?? 0.0) * Double(weg)).rounded(toPlaces: 0))
                    fats += Int(((item.fats ?? 0.0) * Double(weg)).rounded(toPlaces: 0))
                } else {
                    callories += Int(((item.calories ?? 0.0) * 100).rounded(toPlaces: 0))
                    protein += Int(((item.proteins ?? 0.0) * 100).rounded(toPlaces: 0))
                    carbohydrates += Int(((item.carbohydrates ?? 0.0) * 100).rounded(toPlaces: 0))
                    fats += Int(((item.fats ?? 0.0) * 100).rounded(toPlaces: 0))
                }
            }
            fillScreenServing(count: callories, unit: "", title: LS(key: .CALORIES_UNIT), label: caloriesLabel)
            fillScreenServing(count: protein, unit: LS(key: .GRAMS_UNIT), title: LS(key: .PROTEIN), label: proteinLabel)
            fillScreenServing(count: carbohydrates, unit: LS(key: .GRAMS_UNIT), title: LS(key: .CARBOHYDRATES), label: carboLabel)
            fillScreenServing(count: fats, unit: LS(key: .GRAMS_UNIT), title: LS(key: .FAT), label: fatLabel)
        } else {
            fillScreenServing(count: 0, unit: "", title: LS(key: .CALORIES_UNIT), label: caloriesLabel)
            fillScreenServing(count: 0, unit: LS(key: .GRAMS_UNIT), title: LS(key: .PROTEIN), label: proteinLabel)
            fillScreenServing(count: 0, unit: LS(key: .GRAMS_UNIT), title: LS(key: .CARBOHYDRATES), label: carboLabel)
            fillScreenServing(count: 0, unit: LS(key: .GRAMS_UNIT), title: LS(key: .FAT), label: fatLabel)
        }
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
        if !firstLoad {
            reloadServing(needReload: true)
        } else {
            firstLoad = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    func fillScreenByTemplate(template: Template) {
        self.editTemplate = template
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTemplateProduct" {
            if let vc = segue.destination as? ProductDetailsViewController, let product = sender as? SecondProduct {
                var showTitle: String = "Завтрак"
                switch UserInfo.sharedInstance.selectedMealtimeIndex {
                case 0:
                    showTitle = LS(key: .BREAKFAST)
                case 1:
                    showTitle = LS(key: .LUNCH)
                case 2:
                    showTitle = LS(key: .DINNER)
                case 3:
                    showTitle = LS(key: .SNACK)
                default:
                    break
                }
                vc.fillSelectedProduct(product: product, title: showTitle, basketProduct: false, true, delegate: self)
            }
        }
    }
    
    // MARK: - Actions -
    @IBAction func closeClicked(_ sender: Any) {
        showCloseAlert()
    }
    
    @IBAction func finishClicked(_ sender: Any) {
        if UserInfo.sharedInstance.templateName.isEmpty {
            tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TemplateCreateFirstCell {
                cell.titleLabel.textColor = #colorLiteral(red: 0.9231546521, green: 0.3429711461, blue: 0.342156291, alpha: 1) 
                cell.separatorView.backgroundColor = #colorLiteral(red: 0.9231546521, green: 0.3429711461, blue: 0.342156291, alpha: 1)
            }
            return
        }
        
        var productName: String = ""
        let fullNameArr = (UserInfo.sharedInstance.templateName).split{$0 == " "}.map(String.init)
        for item in fullNameArr where !item.isEmpty {
            productName = productName.isEmpty ? item : productName + " \(item)"
        }
        if productName.isEmpty {
            if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? TemplateCreateFirstCell {
                cell.titleLabel.textColor = productName.isEmpty ? #colorLiteral(red: 0.9231546521, green: 0.3429711461, blue: 0.342156291, alpha: 1) : #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)
                cell.separatorView.backgroundColor = productName.isEmpty ? #colorLiteral(red: 0.9231546521, green: 0.3429711461, blue: 0.342156291, alpha: 1) : #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)
            }
            return
        }
        
        if UserInfo.sharedInstance.templateProductList.count < 2 {
            if let header = self.header {
                header.errorLabel.isHidden = false
            }
        } else {
            FirebaseDBManager.saveTemplateItemsInDataBase()
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Private -
    private func reloadServing(needReload: Bool) {
        var callories: Int = 0
        var protein: Int = 0
        var carbohydrates: Int = 0
        var fats: Int = 0
        for item in UserInfo.sharedInstance.templateProductList {
            if let weg = item.weight {
                callories += Int(((item.calories ?? 0.0) * Double(weg)).rounded(toPlaces: 0))
                protein += Int(((item.proteins ?? 0.0) * Double(weg)).rounded(toPlaces: 0))
                carbohydrates += Int(((item.carbohydrates ?? 0.0) * Double(weg)).rounded(toPlaces: 0))
                fats += Int(((item.fats ?? 0.0) * Double(weg)).rounded(toPlaces: 0))
            } else {
                callories += Int(((item.calories ?? 0.0) * 100).rounded(toPlaces: 0))
                protein += Int(((item.proteins ?? 0.0) * 100).rounded(toPlaces: 0))
                carbohydrates += Int(((item.carbohydrates ?? 0.0) * 100).rounded(toPlaces: 0))
                fats += Int(((item.fats ?? 0.0) * 100).rounded(toPlaces: 0))
            }
        }
        fillScreenServing(count: callories, unit: "", title: LS(key: .CALORIES_UNIT), label: caloriesLabel)
        fillScreenServing(count: protein, unit: LS(key: .GRAMS_UNIT), title: LS(key: .PROTEIN), label: proteinLabel)
        fillScreenServing(count: carbohydrates, unit: LS(key: .GRAMS_UNIT), title: LS(key: .CARBOHYDRATES), label: carboLabel)
        fillScreenServing(count: fats, unit: LS(key: .GRAMS_UNIT), title: LS(key: .FAT), label: fatLabel)

        if needReload {
            tableView.reloadData()
        }
        
        if !firstLoad {
            if UserInfo.sharedInstance.templateProductList.count < 2 {
                if let header = self.header {
                    header.errorLabel.isHidden = false
                }
            } else {
                if let header = self.header {
                    header.errorLabel.isHidden = true
                }
            }
            
            if UserInfo.sharedInstance.templateProductList.count > 1 {             nextButtonBackgroundView.backgroundColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)     
                nextButton.isEnabled = true         
            } else {            
                nextButtonBackgroundView.backgroundColor = #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)             
                nextButton.isEnabled = false       
            }
        }
    }
    
    private func showCloseAlert() {
        let refreshAlert = UIAlertController(title: LS(key: .CREATE_STEP_TITLE_1), message: "", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: LS(key: .ALERT_YES), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard let strongSelf = self else { return }
            let viewControllers: [UIViewController] = strongSelf.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is TemplateViewController {
                    strongSelf.navigationController?.popToViewController(aViewController, animated: true)
                }
            }
        }))
        refreshAlert.addAction(UIAlertAction(title: LS(key: .ALERT_NO), style: .default, handler: nil))
        present(refreshAlert, animated: true)
    }
    
    private func fillScreenServing(count: Int, unit: String, title: String, label: UILabel) {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 14.0),
                                                     color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: "\(count)\(unit)"))
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextRegular(size: 14.0),
                                                     color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: "\n\(title)"))
        label.attributedText = mutableAttrString
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.register(TemplateCreateFirstHeaderView.nib, forHeaderFooterViewReuseIdentifier: TemplateCreateFirstHeaderView.reuseIdentifier)
        tableView.register(IngredientsFooterView.nib, forHeaderFooterViewReuseIdentifier: IngredientsFooterView.reuseIdentifier)
        
        tableView.register(type: TemplateSelectedProductCell.self)
        tableView.register(type: TemplateCreateFirstCell.self)
        tableView.reloadData()
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
    
    private func showСonfirmationOfDeletion(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        guard let view = BasketAlertView.fromXib() else { return }
        view.titleImageView.image = #imageLiteral(resourceName: "Dish_234")
        view.descriptionLabel.text = "Вы точно хотите удалить продукт?"
        alertController.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 15).isActive = true
        view.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        view.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let removeAction = UIAlertAction(title: LS(key: .DELETE), style: .default) { [weak self] (alert) in
            guard let strongSelf = self else { return }
            if UserInfo.sharedInstance.templateProductList.indices.contains(indexPath.row) {
                UserInfo.sharedInstance.templateProductList.remove(at: indexPath.row)
                strongSelf.removeRow(indexPath)
                strongSelf.reloadServing(needReload: false)
            }
        }
        let cancelAction = UIAlertAction(title: LS(key: .CANCEL), style: .cancel)
        cancelAction.setValue(#colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), forKey: "titleTextColor")
        removeAction.setValue(#colorLiteral(red: 0.9231546521, green: 0.3429711461, blue: 0.342156291, alpha: 1), forKey: "titleTextColor")
        
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

extension TemplateCreateFirstViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 0
        } else {
            return UserInfo.sharedInstance.templateProductList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateCreateFirstCell") as? TemplateCreateFirstCell else { fatalError() }   
            cell.fillCell(delegate: self, editTemplate)
            return cell
        } else if indexPath.section == 1 {
            return UITableViewCell()
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateSelectedProductCell") as? TemplateSelectedProductCell else { fatalError() }
            cell.delegate = self
            if UserInfo.sharedInstance.templateProductList.indices.contains(indexPath.row) {
                cell.fillCell(product: UserInfo.sharedInstance.templateProductList[indexPath.row])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if UserInfo.sharedInstance.templateProductList.indices.contains(indexPath.row) {
                performSegue(withIdentifier: "editTemplateProduct", sender: UserInfo.sharedInstance.templateProductList[indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
            guard let strongSelf = self else { return }
            strongSelf.showСonfirmationOfDeletion(indexPath: indexPath)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "Combined Shape (1)")
        deleteAction.hidesWhenSelected = true
        deleteAction.backgroundColor = #colorLiteral(red: 0.9231601357, green: 0.3388705254, blue: 0.3422900438, alpha: 1)
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 1 { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TemplateCreateFirstHeaderView.reuseIdentifier) as? TemplateCreateFirstHeaderView else {
            return nil
        }
        self.header = header
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != 1 { return nil }
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: IngredientsFooterView.reuseIdentifier) as? IngredientsFooterView else {
            return UITableViewHeaderFooterView()
        }
        footer.fillFooter(delegate: self, title: "Добавить продукт")
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? TemplateCreateFirstHeaderView.height : 0.0001 
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? IngredientsFooterView.height : 0.0001
    }
}

extension TemplateCreateFirstViewController: AddTemplateDelegate {
    
    func showAddPortion() {
        performSegue(withIdentifier: "sequeAddProductScreen", sender: nil)
    }
    
    func removePortion(index: Int) {
        
    }
    
    func fillTemplateTitle(text: String) {
        
    }
}

extension TemplateCreateFirstViewController: TemplateCreateDelegate {
    
    func editProduct(count: Int, product: Product) {
        guard let _ = self.editTemplate else { return }
        for (index, item) in UserInfo.sharedInstance.templateProductList.enumerated() where item.id == product.id {
            UserInfo.sharedInstance.templateProductList[index].weight = count
        }
        reloadServing(needReload: true)
    }
    
    func activeFinishButton(_ state: Bool) {
        nextButtonBackgroundView.backgroundColor = state ? #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1) : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
        nextButton.isEnabled = !state
    }
}

extension TemplateCreateFirstViewController {
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.tableBottomConstraint.constant = keyboardHeight
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        self.tableBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
