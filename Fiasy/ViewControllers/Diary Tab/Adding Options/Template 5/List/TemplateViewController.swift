//
//  TemplateViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 12/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol TemplateViewDelegate {
    func moreClicked(indexPath: IndexPath)
}

class TemplateViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var blockedView: UIView!
    @IBOutlet weak var addProductButton: UIButton!
    @IBOutlet weak var emptyProductsLabel: UILabel!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var searchSeparatorView: UIView!
    @IBOutlet weak var addProductTitleLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var generalStackView: UIStackView!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var textField: DesignableUITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: CircularProgress!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    
    lazy var removeAlertPresetsView: TemplateAlertPresetsView = {
        guard let view = TemplateAlertPresetsView.fromXib() else { return TemplateAlertPresetsView() }
        return view
    }()
    
    // MARK: - Properties -
    private var allTemplate: [Template] = []
    private var filteredTemplate: [Template] = []
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivity()
        setupTableView()
        blockedView.isHidden = true
        //        fetchItemsInDataBase()
        //        addProductTitleLabel.text = LS(key: .ADD_PRODUCT_IN_JOURNAL)
                navigationTitleLabel.text = LS(key: .PATTERNS_TITLE)
                textField.placeholder = LS(key: .SEARCH)
                cancelSearchButton.setTitle(LS(key: .CANCEL), for: .normal)
        //        emptyProductsLabel.text = LS(key: .MY_PRODUCT_TITLE_1)
        //        addProductButton.setTitle("          \(LS(key: .ADD_PRODUCT).uppercased())          ", for: .normal)
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseDBManager.fetchTemplateInDataBase { [weak self] (templates) in
            guard let strongSelf = self else { return }
            strongSelf.allTemplate = templates
            strongSelf.filteredTemplate = templates
            strongSelf.tableView.reloadData()
            strongSelf.emptyView.isHidden = !templates.isEmpty
            strongSelf.hideActivity()
        } 
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sequeTemplateDetailsScreen" {
            if let vc = segue.destination as? TemplateDetailsViewController, let template = sender as? Template {
                vc.fillScreenByTemplate(template)
                //vc.fillEditProductFavorite(favorite: product)
            }
        }
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        view.endEditing(true)
        self.textField.text?.removeAll()
        filteredTemplate = allTemplate
        tableView.reloadData()
        cancelSearchButton.hideAnimated(in: generalStackView)
    }
    
    @IBAction func createProductClicked(_ sender: Any) {
        //        UserInfo.sharedInstance.productFlow = AddProductFlow()
        //        performSegue(withIdentifier: "sequeProductCreate", sender: nil)
    }
    
    @IBAction func searchValueChange(_ sender: Any) {
        guard let field = textField.text, !allTemplate.isEmpty else { return }
        if field.isEmpty {
            filteredTemplate = allTemplate
        } else {
            var firstItems: [Template] = []
            for item in allTemplate where self.isContains(pattern: field, in: "\(item.name ?? "")") {
                firstItems.append(item)
            }
            filteredTemplate = firstItems
        }
        tableView.reloadData()
    }
    
    private func isContains(pattern: String, in text: String?) -> Bool {
        guard let text = text else { return false }
        let lowcasePattern = pattern.lowercased()
        let lowcaseText = text.lowercased()
        
        let fullNameArr = lowcasePattern.split{$0 == " "}.map(String.init)
        var states: [Bool] = []
        for item in fullNameArr {
            states.append(lowcaseText.contains(item))
        }
        return states.contains(true)
    }
    
    private func setupTableView() {
        tableView.register(type: TemplateListTableCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func showActivity() {
        activityView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivity() {
        activityView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func addShadow(_ view: UIView) {
        UIView.animate(withDuration: 0.2) { 
            view.layer.shadowColor = UIColor.gray.cgColor
            view.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            view.layer.masksToBounds = false
            view.layer.shadowRadius = 2.0
            view.layer.shadowOpacity = 0.5
        }
    }
    
    private func deleteShadow(_ view: UIView) {
        UIView.animate(withDuration: 0.2) { 
            view.layer.shadowOffset = CGSize(width: 0, height: 0.0)
            view.layer.shadowRadius = 0
            view.layer.shadowOpacity = 0
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
    
    func showDeleteAlert(indexPath: IndexPath) {
        SwiftEntryKit.dismiss()
        var attributes = EKAttributes()
        attributes.fillAppConfigure(height: 50.0)
        removeAlertPresetsView.fillView(delegate: self, index: indexPath)
        blockedView.isHidden = false
        SwiftEntryKit.display(entry: removeAlertPresetsView, using: attributes)
    }
    
    private func showСonfirmationOfDeletion(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        guard let view = BasketAlertView.fromXib() else { return }
        view.titleImageView.image = #imageLiteral(resourceName: "templat_4445")
        view.descriptionLabel.text = LS(key: .CREATE_STEP_TITLE_40)
        alertController.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 15).isActive = true
        view.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        view.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        view.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let removeAction = UIAlertAction(title: LS(key: .DELETE), style: .default) { [weak self] (alert) in
            guard let strongSelf = self else { return }
            strongSelf.showDeleteAlert(indexPath: indexPath)
        }
        let cancelAction = UIAlertAction(title: LS(key: .CANCEL), style: .cancel)
        cancelAction.setValue(#colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), forKey: "titleTextColor")
        removeAction.setValue(#colorLiteral(red: 0.9231546521, green: 0.3429711461, blue: 0.342156291, alpha: 1), forKey: "titleTextColor")
        
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

extension TemplateViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelSearchButton.showAnimated(in: generalStackView)
    }
}

extension TemplateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTemplate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateListTableCell") as? TemplateListTableCell else { fatalError() } 
        cell.fillCell(filteredTemplate[indexPath.row], delegate: self, indexPath: indexPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y > 0 ? addShadow(searchContainerView) : deleteShadow(searchContainerView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredTemplate.indices.contains(indexPath.row) {
            performSegue(withIdentifier: "sequeTemplateDetailsScreen", sender: filteredTemplate[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001 
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001 
    }
}

extension TemplateViewController: TemplateViewDelegate {
    
    func moreClicked(indexPath: IndexPath) {
        showСonfirmationOfDeletion(indexPath: indexPath)
    }
}

extension TemplateViewController {
    
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

extension TemplateViewController: BasketDelegate {
    
    func removeProduct(indexPath: IndexPath) {
        guard let key = allTemplate[indexPath.row].generalKey else { return }
        FirebaseDBManager.removeTemplate(key: key, handler: {
            SwiftEntryKit.dismiss()
            self.allTemplate.remove(at: indexPath.row)
            self.filteredTemplate = self.allTemplate
            self.emptyView.isHidden = !self.allTemplate.isEmpty
            self.removeRow(indexPath)
            self.blockedView.isHidden = true
        })
    }
    
    func cancelRemoveProduct(indexPath: IndexPath) {
        SwiftEntryKit.dismiss()
        blockedView.isHidden = true
    }
    
    func replaceProduct(newCount: Int, _ selectedPortionId: Int?) {}
}
