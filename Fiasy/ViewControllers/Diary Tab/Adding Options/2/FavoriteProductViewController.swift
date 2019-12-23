//
//  FavoriteProductViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/7/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Swinject
import SwiftEntryKit

class FavoriteProductViewController: UIViewController {
    
    enum FavoriteProductState {
        case list
        case search
    }
    
    // MARK: - Outlet -
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var emptyContainerView: UIView!
    @IBOutlet weak var generalStackView: UIStackView!
    @IBOutlet weak var emptyBottomLabel: UILabel!
    @IBOutlet weak var emptyTopLabel: UILabel!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var addProductTitleLabel: UILabel!
    @IBOutlet weak var cancelSearchButton: UIButton!
    @IBOutlet weak var textField: DesignableUITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: CircularProgress!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    var keyboardHeight: CGFloat = 80.0
    private var searchProducts: [SecondProduct] = []
    private var pagination: PaginationProduct?
    private var screenState: FavoriteProductState = .list
    private var interactor: SearchProductInteractorInput?
    private var selectedProducts: [SecondProduct] = []
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    private lazy var productPresetsView: ProductPresetsView = {
        guard let view = ProductPresetsView.fromXib() else { return ProductPresetsView() }
        view.delegate = self
        return view
    }()
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupInteractor()
        navigationTitleLabel.text = LS(key: .FAVORITES)
        addProductTitleLabel.text = LS(key: .ADD_PRODUCT_IN_JOURNAL)
        textField.placeholder = LS(key: .SEARCH)
        
        emptyTopLabel.text = LS(key: .CREATE_STEP_TITLE_37)
        
        let fullString = NSMutableAttributedString(string: LS(key: .CREATE_STEP_TITLE_38))
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = #imageLiteral(resourceName: "favorite_button")
        let image1String = NSAttributedString(attachment: image1Attachment)
        fullString.append(image1String)
        emptyBottomLabel.attributedText = fullString
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
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        view.endEditing(true)
        cancelSearchButton.hideAnimated(in: generalStackView)
    }
    
    @IBAction func searchValueChange(_ sender: Any) {
        guard let text = textField.text else { return }
        interactor?.searchProduct(search: text)
    }
    
    // MARK: - Privates -
    private func setupTableView() {
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(type: FavoriteProductTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupInteractor() {
        let container = assembler.resolver as! Container
        let profileService = container.resolve(ProfileServiceProtocol.self)!
        let interactor = SearchProductInteractor(profileService: profileService)
        interactor.output = self
        self.interactor = interactor
    }
    
    private func displayPresets() {
        if selectedProducts.isEmpty {
            SwiftEntryKit.dismiss()
        } else {
            if SwiftEntryKit.isCurrentlyDisplaying() {
                productPresetsView.fillView(count: selectedProducts.count)
            } else {
                var attributes = EKAttributes()
                attributes.fillAppConfigure(height: keyboardHeight)
                productPresetsView.fillView(count: selectedProducts.count)
                SwiftEntryKit.display(entry: productPresetsView, using: attributes)
            }
        }
    }
}

extension FavoriteProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteProductTableViewCell") as? FavoriteProductTableViewCell else { fatalError() }
        cell.fillCell(product: searchProducts[indexPath.row], delegate: self, selectedProducts)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

extension FavoriteProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        //self.delegate?.searchItem(text: text)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelSearchButton.showAnimated(in: generalStackView)
    }
}

extension FavoriteProductViewController: SearchProductInteractorOutput {
    
    func didLoadSuggest(list: [ProductInfo]) {}
    func didLoadBySearch(_ pagination: PaginationProduct) {
        self.screenState = .search
        self.pagination = pagination
        
        self.searchProducts = pagination.secondResults
        self.separatorView.isHidden = self.searchProducts.isEmpty
        self.emptyContainerView.isHidden = !self.searchProducts.isEmpty
        self.tableView.reloadData()
    }
    
    func didLoadMoreProducts(_ products: [SecondProduct]) {
        //
    }
}

extension FavoriteProductViewController: ProductAddingDelegate {
    
    func showBasket() {
        //
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
        if state {
            selectedProducts.append(filled)
        } else {
            for (index, second) in selectedProducts.enumerated() where second.id == filled.id {
                if selectedProducts.indices.contains(index) {
                    selectedProducts.remove(at: index)
                }
            }
        }
        displayPresets()
    }
}
