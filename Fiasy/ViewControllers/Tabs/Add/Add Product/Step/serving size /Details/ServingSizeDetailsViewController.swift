//
//  ServingSizeDetailsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol ServingSizeDetailsDelegate {
    func openPicker()
    func textChange(tag: Int, text: String?)
}

class ServingSizeDetailsViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var titleNavigationLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var selectedPicker: UIPickerView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private var isEdit: Bool = false
    private var selectedIndex: Int = 1
    private var selectedServing = Serving(name: "", unit: LS(key: .CREATE_STEP_TITLE_19), size: 0)
    private var pickerData: [String] = [LS(key: .CREATE_STEP_TITLE_18), LS(key: .CREATE_STEP_TITLE_19), LS(key: .CREATE_STEP_TITLE_20), LS(key: .CREATE_STEP_TITLE_21)]
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        selectedPicker.delegate = self
        selectedPicker.dataSource = self
        titleNavigationLabel.text = LS(key: .CREATE_STEP_TITLE_28)
        finishButton.setTitle(LS(key: .DONE), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    func fillModel(model: Serving) {
        self.isEdit = true
        self.selectedServing = model
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: ServingSizeDetailsCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func showPicker() {
        UIView.animate(withDuration: 0.3) { 
            if let background = self.pickerContainerView.superview {
                background.fadeIn()
            }
            self.pickerContainerView.frame = CGRect(x: 0, y: self.view.bounds.size.height - self.pickerContainerView.bounds.size.height, width: UIScreen.main.bounds.width, height: self.pickerContainerView.bounds.size.height)
        }
    }
    
    private func closePicker() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.pickerContainerView.frame = CGRect(x: 0, y: self.view.bounds.size.height, width: UIScreen.main.bounds.width, height: self.pickerContainerView.bounds.size.height)
        }) { (state) in
            if let background = self.pickerContainerView.superview {
                background.fadeOut()
            }
        }
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closePickerClicked(_ sender: Any) {
        closePicker()
    }
    
    @IBAction func finishClicked(_ sender: Any) {
        guard let name = selectedServing.name, !name.isEmpty else {
            if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ServingSizeDetailsCell {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
                cell.errorLabel.alpha = 1.0
                cell.separatorView.backgroundColor = #colorLiteral(red: 0.9617733359, green: 0.6727946401, blue: 0.6699010134, alpha: 1)
                cell.insertTextField.becomeFirstResponder()
            }
            return
        }
        if name.replacingOccurrences(of: " ", with: "").isEmpty {
            return AlertComponent.sharedInctance.showAlertMessage(message: LS(key: .CREATE_STEP_TITLE_22), vc: self)
        }
        
        guard let size = selectedServing.servingSize, size != 0 else {
            if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? ServingSizeDetailsCell {
                tableView.scrollToRow(at: IndexPath(row: 2, section: 0), at: .middle, animated: true)
                cell.errorLabel.alpha = 1.0
                cell.separatorView.backgroundColor = #colorLiteral(red: 0.9617733359, green: 0.6727946401, blue: 0.6699010134, alpha: 1)
                cell.insertTextField.becomeFirstResponder()
            }
            return
        }
        view.endEditing(true)
        if !self.isEdit {
            UserInfo.sharedInstance.productFlow.allServingSize.append(selectedServing)
        } else {
            if UserInfo.sharedInstance.productFlow.allServingSize.indices.contains(selectedServing.index) {
                UserInfo.sharedInstance.productFlow.allServingSize[selectedServing.index] = selectedServing
            }
        }
        navigationController?.popViewController(animated: true)
    }
}

extension ServingSizeDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServingSizeDetailsCell") as? ServingSizeDetailsCell else { fatalError() }
        cell.fillCell(indexPath: indexPath, selectedServing, self)
        return cell
    }
}

extension ServingSizeDetailsViewController {
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.tableBottomConstraint.constant = keyboardHeight - (tabBarController?.tabBar.frame.height ?? 49.0)
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

extension ServingSizeDetailsViewController: ServingSizeDetailsDelegate {
    
    func textChange(tag: Int, text: String?) {
        switch tag {
        case 0:
            selectedServing.name = text
        case 1:
            selectedServing.unitMeasurement = text
        case 2:
            selectedServing.servingSize = Int("\(text ?? "0")")
        default:
            break
        }
    }
    
    func openPicker() {
        view.endEditing(true)
        selectedPicker.selectRow(selectedIndex, inComponent: 0, animated: false)
        showPicker()
    }
}

extension ServingSizeDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.text = pickerData[row]
        pickerLabel.font = UIFont.sfProTextRegular(size: 23)
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let cell = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? ServingSizeDetailsCell {
            var title: String = ""
            switch row {
            case 0:
                selectedIndex = 0
                title = LS(key: .CREATE_STEP_TITLE_18)
            case 1:
                selectedIndex = 1
                title = LS(key: .CREATE_STEP_TITLE_19)
            case 2:
                selectedIndex = 2
                title = LS(key: .CREATE_STEP_TITLE_20)
            case 3:
                selectedIndex = 3
                title = LS(key: .CREATE_STEP_TITLE_21)
            default:
                break
            }
            selectedServing.unitMeasurement = title
            cell.updateServingUnit(text: title)
        }
    }
}
