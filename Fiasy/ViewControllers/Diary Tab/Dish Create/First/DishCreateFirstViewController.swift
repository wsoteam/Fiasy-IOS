//
//  DishCreateFirstViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/8/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit
import AMPopTip

protocol DishCreateFirstScreenDelegate {
    func showPicker()
    func showAddPortion()
    func textChange(name: String)
}

class DishCreateFirstViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var frameView: UIView!
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
    var backTwice: Bool = false
    private var popTip = PopTip()
    private var selectedDish: Dish?
    private var firstLoad: Bool = true
    weak var footer: DishCreateFirstFooterView?
    private lazy var mediaPicker: ImagePickerService = {
        self.mediaPicker = ImagePickerService()
        configureMediaPicker()
        return self.mediaPicker
    }()
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillPopTip()
        setupTableView()
        UserInfo.sharedInstance.dishFlow = DishFlow()
        if let dish = selectedDish {
            UserInfo.sharedInstance.dishFlow.generalKey = dish.generalKey
            UserInfo.sharedInstance.dishFlow.dishName = dish.name
            UserInfo.sharedInstance.dishFlow.allProduct = dish.products
            UserInfo.sharedInstance.dishFlow.imageUrl = dish.imageUrl
            var callories: Int = 0
            var protein: Int = 0
            var carbohydrates: Int = 0
            var fats: Int = 0
            for item in UserInfo.sharedInstance.dishFlow.allProduct {
                callories += Int(((item.calories ?? 0.0) * 100).rounded(toPlaces: 0))
                protein += Int(((item.proteins ?? 0.0) * 100).rounded(toPlaces: 0))
                carbohydrates += Int(((item.carbohydrates ?? 0.0) * 100).rounded(toPlaces: 0))
                fats += Int(((item.fats ?? 0.0) * 100).rounded(toPlaces: 0))
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
        if !firstLoad {
            reloadServing()
        } else {
            firstLoad = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    func fillScreenByDish(dish: Dish) {
        self.selectedDish = dish
    }
    
    // MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        showCloseAlert()
    }
    
    @IBAction func saveClicked(_ sender: UIButton) {
        if let name = UserInfo.sharedInstance.dishFlow.dishName, name.isEmpty {
            tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? DishCreateFirstCell {
                cell.titleLabel.textColor = cell.nameTextView.text.isEmpty ? #colorLiteral(red: 0.9231546521, green: 0.3429711461, blue: 0.342156291, alpha: 1) : #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)
                cell.separatorView.backgroundColor = cell.nameTextView.text.isEmpty ? #colorLiteral(red: 0.9231546521, green: 0.3429711461, blue: 0.342156291, alpha: 1) : #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)
            }
            return
        } 
        
        var productName: String = ""
        let fullNameArr = (UserInfo.sharedInstance.dishFlow.dishName ?? "").split{$0 == " "}.map(String.init)
        for item in fullNameArr where !item.isEmpty {
            productName = productName.isEmpty ? item : productName + " \(item)"
        }
        
        if productName.isEmpty {
            if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? DishCreateFirstCell {
                cell.titleLabel.textColor = productName.isEmpty ? #colorLiteral(red: 0.9231546521, green: 0.3429711461, blue: 0.342156291, alpha: 1) : #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)
                cell.separatorView.backgroundColor = productName.isEmpty ? #colorLiteral(red: 0.9231546521, green: 0.3429711461, blue: 0.342156291, alpha: 1) : #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)
            }
            return
        }
        
        if UserInfo.sharedInstance.dishFlow.allProduct.count < 2 {
            if let footer = self.footer {
                footer.errorLabel.isHidden = false
            }
        } else {
            sender.isEnabled = false
            UserInfo.sharedInstance.dishFlow.dishName = productName
            FirebaseDBManager.saveDishItemsInDataBase {
                if self.backTwice {
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    for aViewController in viewControllers {
                        if aViewController is DishViewController {
                            self.navigationController?.popToViewController(aViewController, animated: true)
                        }
                    }
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        performSegue(withIdentifier: "sequeDishDescription", sender: nil)
//        guard let view = MeasuringAlertMiddleWeightView.fromXib(), !popTip.isVisible else { return }
//        view.frame = CGRect(x: 0, y: 0, width: 220, height: 80)
//        view.secondFillView(delegate: self)
//        popTip.show(customView: view, direction: .down, in: self.view, from: frameView.frame)
    }

    // MARK: - Private -    
    private func showCloseAlert() {
        let refreshAlert = UIAlertController(title: LS(key: .CREATE_STEP_TITLE_1), message: "", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: LS(key: .ALERT_YES), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard let strongSelf = self else { return }
            let viewControllers: [UIViewController] = strongSelf.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is DishViewController {
                    strongSelf.navigationController?.popToViewController(aViewController, animated: true)
                }
            }
        }))
        refreshAlert.addAction(UIAlertAction(title: LS(key: .ALERT_NO), style: .default, handler: nil))
        present(refreshAlert, animated: true)
    }
    
    private func secondReloadServing() {
        var callories: Int = 0
        var protein: Int = 0
        var carbohydrates: Int = 0
        var fats: Int = 0
        for item in UserInfo.sharedInstance.dishFlow.allProduct {
            callories += Int(((item.calories ?? 0.0) * 100).rounded(toPlaces: 0))
            protein += Int(((item.proteins ?? 0.0) * 100).rounded(toPlaces: 0))
            carbohydrates += Int(((item.carbohydrates ?? 0.0) * 100).rounded(toPlaces: 0))
            fats += Int(((item.fats ?? 0.0) * 100).rounded(toPlaces: 0))
        }
        fillScreenServing(count: callories, unit: "", title: LS(key: .CALORIES_UNIT), label: caloriesLabel)
        fillScreenServing(count: protein, unit: LS(key: .GRAMS_UNIT), title: LS(key: .PROTEIN), label: proteinLabel)
        fillScreenServing(count: carbohydrates, unit: LS(key: .GRAMS_UNIT), title: LS(key: .CARBOHYDRATES), label: carboLabel)
        fillScreenServing(count: fats, unit: LS(key: .GRAMS_UNIT), title: LS(key: .FAT), label: fatLabel)
        
        if !firstLoad {
            if UserInfo.sharedInstance.dishFlow.allProduct.count < 2 {
                if let footer = self.footer {
                    footer.errorLabel.isHidden = false
                }
            } else {
                if let footer = self.footer {
                    footer.errorLabel.isHidden = true
                }
            }
            
            if UserInfo.sharedInstance.dishFlow.allProduct.count > 1 {             nextButtonBackgroundView.backgroundColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)     
                nextButton.isEnabled = true         
            } else {            
                nextButtonBackgroundView.backgroundColor = #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)             
                nextButton.isEnabled = false       
            }
        }
    }
    
    private func reloadServing() {
        var callories: Int = 0
        var protein: Int = 0
        var carbohydrates: Int = 0
        var fats: Int = 0
        for item in UserInfo.sharedInstance.dishFlow.allProduct {
            callories += Int(((item.calories ?? 0.0) * 100).rounded(toPlaces: 0))
            protein += Int(((item.proteins ?? 0.0) * 100).rounded(toPlaces: 0))
            carbohydrates += Int(((item.carbohydrates ?? 0.0) * 100).rounded(toPlaces: 0))
            fats += Int(((item.fats ?? 0.0) * 100).rounded(toPlaces: 0))
        }
        fillScreenServing(count: callories, unit: "", title: LS(key: .CALORIES_UNIT), label: caloriesLabel)
        fillScreenServing(count: protein, unit: LS(key: .GRAMS_UNIT), title: LS(key: .PROTEIN), label: proteinLabel)
        fillScreenServing(count: carbohydrates, unit: LS(key: .GRAMS_UNIT), title: LS(key: .CARBOHYDRATES), label: carboLabel)
        fillScreenServing(count: fats, unit: LS(key: .GRAMS_UNIT), title: LS(key: .FAT), label: fatLabel)
        
        if let name = UserInfo.sharedInstance.dishFlow.dishName, !name.isEmpty {
            nextButtonBackgroundView.backgroundColor = name.isEmpty ? #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1) : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
            nextButton.isEnabled = !name.isEmpty
        } else if UserInfo.sharedInstance.dishFlow.allProduct.count > 1 {
            nextButtonBackgroundView.backgroundColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
            nextButton.isEnabled = true
        } else {
            nextButtonBackgroundView.backgroundColor = #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
            nextButton.isEnabled = false
        }
        
        tableView.reloadData()
        
        if !firstLoad {
            if UserInfo.sharedInstance.dishFlow.allProduct.count < 2 {
                if let footer = self.footer {
                    footer.errorLabel.isHidden = false
                }
            } else {
                if let footer = self.footer {
                    footer.errorLabel.isHidden = true
                }
            }
        }
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
    
    private func fillPopTip() {
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.shouldDismissOnTap = false
        popTip.bubbleColor = .clear
        popTip.edgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.register(DishCreateFirstFooterView.nib, forHeaderFooterViewReuseIdentifier: DishCreateFirstFooterView.reuseIdentifier)
        tableView.register(type: DishCreateFirstCell.self)
        tableView.register(type: TemplateSelectedProductCell.self)
        tableView.reloadData()
    }
    
    private func configureMediaPicker() {
        mediaPicker.targetVC = self
        mediaPicker.onImageSelected = { [weak self] image in
            guard let strongSelf = self else { return }
            if let cell = strongSelf.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DishCreateFirstCell {
                cell.fillSelectedImage(image)
                if let name = UserInfo.sharedInstance.dishFlow.dishName, !name.isEmpty {
                    strongSelf.nextButtonBackgroundView.backgroundColor = name.isEmpty ? #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1) : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
                    strongSelf.nextButton.isEnabled = !name.isEmpty
                }
                UserInfo.sharedInstance.dishFlow.dishImage = image
            }
        }
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
            if UserInfo.sharedInstance.dishFlow.allProduct.indices.contains(indexPath.row) {
                UserInfo.sharedInstance.dishFlow.allProduct.remove(at: indexPath.row)
                strongSelf.secondReloadServing()
                strongSelf.removeRow(indexPath)
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

extension DishCreateFirstViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : UserInfo.sharedInstance.dishFlow.allProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DishCreateFirstCell") as? DishCreateFirstCell else { fatalError() } 
            cell.fillCell(tableView, UserInfo.sharedInstance.dishFlow.dishImage, selectedDish, self)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateSelectedProductCell") as? TemplateSelectedProductCell else { fatalError() }
            cell.delegate = self
            if UserInfo.sharedInstance.dishFlow.allProduct.indices.contains(indexPath.row) {
                cell.fillCell(product: UserInfo.sharedInstance.dishFlow.allProduct[indexPath.row])
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != 0 { return nil }
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: DishCreateFirstFooterView.reuseIdentifier) as? DishCreateFirstFooterView else {
            return UITableViewHeaderFooterView()
        }
        footer.fillFooter(delegate: self, title: "Добавить продукт")
        self.footer = footer
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001 
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? DishCreateFirstFooterView.height : 0.0001 
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
}

extension DishCreateFirstViewController {
    
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

extension DishCreateFirstViewController: MeasuringCellDelegate {
    func showAlert(button: UIButton) {}
    func addNewMeasuring(date: Date, measuring: Measuring?) {}
    func showDescription() {
        popTip.hide()
        performSegue(withIdentifier: "sequeDishDescription", sender: nil)
    }
}

extension DishCreateFirstViewController: DishCreateFirstScreenDelegate {
    
    func textChange(name: String) {
        UserInfo.sharedInstance.dishFlow.dishName = name
        nextButtonBackgroundView.backgroundColor = name.isEmpty ? #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1) : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
        nextButton.isEnabled = !name.isEmpty
    }
    
    func showAddPortion() {
        performSegue(withIdentifier: "sequeAddProductScreen", sender: nil)
    }
    
    func showPicker() {
        mediaPicker.showPickAttachment()
    }
}
