//
//  DishCreateSearchViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/12/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit
import Swinject
import SwiftEntryKit

class DishCreateSearchViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var generalStackView: UIStackView!
    @IBOutlet weak var textField: DesignableUITextField!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    var keyboardHeight: CGFloat = 50.0
    private var contentOffsetY: Int = 0
    private var dontShowView: Bool = false
    private var pagination: PaginationProduct?
    private var interactor: SearchProductInteractorInput?
    private var products: [SecondProduct] = []
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    private lazy var productPresetsView: TemplateSearchView = {
        guard let view = TemplateSearchView.fromXib() else { return TemplateSearchView() }
        view.delegate = self
        return view
    }()
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupInteractor()
        textField.placeholder = LS(key: .SEARCH)
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    func reloadBottomView() {
        guard !dontShowView else { return }
        if SwiftEntryKit.isCurrentlyDisplaying() {
            var attributes = EKAttributes()
            attributes.fillAppConfigure(height: keyboardHeight)
            productPresetsView.fillView(count: UserInfo.sharedInstance.dishFlow.allProduct.count)
            SwiftEntryKit.display(entry: productPresetsView, using: attributes)
        }
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        dontShowView = true
        SwiftEntryKit.dismiss()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        showCloseAlert()
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        view.endEditing(true)
        textField.text?.removeAll()
        cancelSearchButton.hideAnimated(in: generalStackView)
        products.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func searchValueChange(_ sender: Any) {
        guard let text = textField.text else { return }
        if text.isEmpty {
            products.removeAll()
            tableView.reloadData()
        } else {
            interactor?.searchProduct(search: text)
        }
    }
    
    // MARK: - Privates -
    private func setupTableView() {
        tableView.register(type: ProductAddingSearchCell.self)
        tableView.register(type: ProductSearchEmptyCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    private func showCloseAlert() {
        let refreshAlert = UIAlertController(title: LS(key: .CREATE_STEP_TITLE_1), message: "", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: LS(key: .ALERT_YES), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard let strongSelf = self else { return }
            let viewControllers: [UIViewController] = strongSelf.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is DishViewController {
                    strongSelf.dontShowView = true
                    SwiftEntryKit.dismiss()
                    strongSelf.navigationController?.popToViewController(aViewController, animated: true)
                }
            }
        }))
        refreshAlert.addAction(UIAlertAction(title: LS(key: .ALERT_NO), style: .default, handler: nil))
        present(refreshAlert, animated: true)
    }
    
    private func setupInteractor() {
        let container = assembler.resolver as! Container
        let profileService = container.resolve(ProfileServiceProtocol.self)!
        let interactor = SearchProductInteractor(profileService: profileService)
        interactor.output = self
        self.interactor = interactor
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
    
    private func displayPresets() {
        if UserInfo.sharedInstance.dishFlow.allProduct.isEmpty {
            SwiftEntryKit.dismiss()
        } else {
            if SwiftEntryKit.isCurrentlyDisplaying() {
                productPresetsView.fillView(count: UserInfo.sharedInstance.dishFlow.allProduct.count)
            } else {
                var attributes = EKAttributes()
                attributes.fillAppConfigure(height: keyboardHeight)
                productPresetsView.fillView(count: UserInfo.sharedInstance.dishFlow.allProduct.count)
                SwiftEntryKit.display(entry: productPresetsView, using: attributes)
            }
        }
    }
}

extension DishCreateSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.isEmpty ? 1 : products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if products.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSearchEmptyCell") as? ProductSearchEmptyCell else { fatalError() }
            return cell
        } else {
            let product = products[indexPath.row]
            //if product.measurementUnits.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductAddingSearchCell") as? ProductAddingSearchCell else { fatalError() }
            cell.fillSecondCell(indexPath.row == 0, product: products[indexPath.row], delegate: self, UserInfo.sharedInstance.dishFlow.allProduct)
            return cell
            // }
            //            else {
            //                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductResizeSearchCell") as? ProductResizeSearchCell else { fatalError() }
            //                cell.fillCell(product: products[indexPath.row], delegate: self, isOpen: openCells.contains(indexPath), indexPath: indexPath, selectedProduct: selectedProducts, title: selectedTitle)
            //                return cell
            //            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetYLast: Int = Int(scrollView.contentOffset.y+scrollView.bounds.size.height)
        let heightContentSize = Int(scrollView.contentSize.height)
        if contentOffsetYLast > heightContentSize && contentOffsetY <= heightContentSize {
            if let pagination = self.pagination {
                interactor?.loadMoreProducts(pagination: pagination)
            }
        }
        contentOffsetY = contentOffsetYLast
        scrollView.contentOffset.y > 0 ? addShadow(searchContainerView) : deleteShadow(searchContainerView)
    }
}

extension DishCreateSearchViewController: ProductAddingDelegate  {
    
    func showBasket() {
        dontShowView = true
        SwiftEntryKit.dismiss()
        navigationController?.popViewController(animated: true)
    }
    
    func arrowClicked(by index: IndexPath) {
        //
    }
    
    func showProgress(back: Bool) {
        //
    }
    
    func portionClicked(portion: MeasurementUnits, product: SecondProduct, state: Bool) {
        //
    }
    
    func openPortionDetails(by product: SecondProduct) {
        //
    }
    
    func productSelected(_ item: SecondProduct, state: Bool) {
        let filled = SecondProduct(second: item)
        //filled.divisionBasketTitle = screenTitle
        if state {
            UserInfo.sharedInstance.dishFlow.allProduct.append(filled)
        } else {
            for (index, second) in UserInfo.sharedInstance.dishFlow.allProduct.enumerated() where second.id == filled.id {
                if UserInfo.sharedInstance.dishFlow.allProduct.indices.contains(index) {
                    UserInfo.sharedInstance.dishFlow.allProduct.remove(at: index)
                }
            }
        }
        displayPresets()
    }
    
    func likeClicked(product: SecondProduct, likeImage: UIImageView) {
        //
    }
}

extension DishCreateSearchViewController: SearchProductInteractorOutput {
    
    func didLoadSuggest(list: [ProductInfo]) {}
    func didLoadBySearch(_ pagination: PaginationProduct) {
        self.pagination = pagination
        
        self.products = pagination.secondResults
        self.tableView.reloadData()
    }
    
    func didLoadMoreProducts(_ products: [SecondProduct]) {
        for item in products {
            self.products.append(item)
            tableView.beginUpdates()
            let indexPath: IndexPath = IndexPath(row: self.products.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

extension DishCreateSearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelSearchButton.showAnimated(in: generalStackView)
        //emptyContainerView.isHidden = true
        tableView.reloadData()
    }
}

extension DishCreateSearchViewController {
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyboardHeight = keyboardHeight + 20
            reloadBottomView()
            self.tableBottomConstraint.constant = keyboardHeight
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        self.tableBottomConstraint.constant = 0
        self.keyboardHeight = 50
        reloadBottomView()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
