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

enum FavoriteProductState {
    case list
    case search
}

class FavoriteProductViewController: UIViewController {
    
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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    
    // MARK: - Properties -
    var keyboardHeight: CGFloat = 50.0
    private var contentOffsetY: Int = 0
    private var searchProducts: [SecondProduct] = []
    private var allFavorites: [SecondProduct] = []
    private var pagination: PaginationProduct?
    private var screenState: FavoriteProductState = .list
    private var interactor: SearchProductInteractorInput?
    private var selectedProducts: [SecondProduct] = []
    private var screenTitle: String?
    private var diaryDelegate: DiaryViewDelegate?
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

        showActivity()
        separatorView.isHidden = true
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
        
        FirebaseDBManager.fetchFavoriteInDataBase { [weak self] (all) in
            guard let strongSelf = self else { return }
            strongSelf.allFavorites = all
            strongSelf.emptyContainerView.isHidden = !strongSelf.allFavorites.isEmpty
            strongSelf.separatorView.isHidden = strongSelf.allFavorites.isEmpty
            strongSelf.hideActivity()
            strongSelf.tableView.reloadData()
        }
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SwiftEntryKit.dismiss()
        if segue.identifier == "showBasketScreen" {
            if let vc = segue.destination as? BasketViewController {
                vc.fillProducts(fetchProductList(), self, productPresetsView)
            }
        } else if segue.identifier == "sequeProductDetails" {
            if let vc = segue.destination as? ProductDetailsViewController, let product = sender as? SecondProduct, let title = self.screenTitle {
                SwiftEntryKit.dismiss()
                vc.fillSelectedProduct(product: product, title: title, basketProduct: false)
            }
        }
    }
    
    func fillTitle(_ title: String, diaryDelegate: DiaryViewDelegate?) {
        self.screenTitle = title
        self.diaryDelegate = diaryDelegate
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        SwiftEntryKit.dismiss()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        view.endEditing(true)
        textField.text?.removeAll()
        cancelSearchButton.hideAnimated(in: generalStackView)
        screenState = .list
        emptyContainerView.isHidden = !allFavorites.isEmpty
        tableView.reloadData()
    }
    
    @IBAction func searchValueChange(_ sender: Any) {
        guard let text = textField.text else { return }
        
        interactor?.searchProduct(search: text)
    }
    
    // MARK: - Privates -
    private func fetchProductList() -> [[SecondProduct]] {
        if let title = self.screenTitle {
            switch title {
            case LS(key: .BREAKFAST):
                return [selectedProducts, [], [], []]
            case LS(key: .LUNCH):
                return [[], selectedProducts, [], []]
            case LS(key: .DINNER):
                return [[], [], selectedProducts, []]
            case LS(key: .SNACK):
                return [[], [], [], selectedProducts]
            default:
                return []
            }
        }
        return []
    }
    
    private func setupTableView() {
        tableView.register(type: ProductSearchEmptyCell.self)
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
    
    private func showActivity() {
        activityView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivity() {
        activityView.isHidden = true
        activityIndicator.stopAnimating()
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
        return screenState == .list ? allFavorites.count : (searchProducts.isEmpty ? 1 : searchProducts.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if screenState == .search && searchProducts.isEmpty {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSearchEmptyCell") as? ProductSearchEmptyCell else { fatalError() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteProductTableViewCell") as? FavoriteProductTableViewCell else { fatalError() }
            let product = screenState == .list ? allFavorites[indexPath.row] : searchProducts[indexPath.row]
            cell.fillCell(product: product, delegate: self, selectedProducts, allFavorites)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if screenState == .list {
            if !allFavorites.isEmpty {
                if allFavorites.indices.contains(indexPath.row) {
                    performSegue(withIdentifier: "sequeProductDetails", sender: allFavorites[indexPath.row])
                }
            }
        } else {
            if !searchProducts.isEmpty {
                if searchProducts.indices.contains(indexPath.row) {
                    performSegue(withIdentifier: "sequeProductDetails", sender: searchProducts[indexPath.row])
                }
            }
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
        emptyContainerView.isHidden = true
        screenState = .search
        tableView.reloadData()
    }
}

extension FavoriteProductViewController: SearchProductInteractorOutput {
    
    func didLoadSuggest(list: [ProductInfo]) {}
    func didLoadBySearch(_ pagination: PaginationProduct) {
        self.screenState = .search
        self.pagination = pagination
        
        separatorView.isHidden = searchProducts.isEmpty
        self.searchProducts = pagination.secondResults
        self.separatorView.isHidden = self.searchProducts.isEmpty
        self.emptyContainerView.isHidden = true
        self.tableView.reloadData()
    }
    
    func didLoadMoreProducts(_ products: [SecondProduct]) {
        for item in products {
            self.searchProducts.append(item)
            tableView.beginUpdates()
            let indexPath: IndexPath = IndexPath(row: self.searchProducts.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

extension FavoriteProductViewController: ProductBasketDelegate {
    
    func productsShipped() {
        //
    }
    
    func removeBasketProduct(indexPath: IndexPath) {
        //
    }
    
    func changeMenuSelected(indexPath: IndexPath) {
        //
    }
}

extension FavoriteProductViewController: ProductAddingDelegate {
    
    func likeClicked(product: SecondProduct, likeImage: UIImageView) {
        var findIndex: Int?
        var generalKey: String?
        for (index, item) in self.allFavorites.enumerated() where item.id == product.id {
            findIndex = index
            generalKey = item.generalKey
            break
        }
        for (index, item) in self.selectedProducts.enumerated() where item.id == product.id {
            selectedProducts.remove(at: index)
            break
        }
        
        if let index = findIndex {
            if let key = generalKey {

                progressView.trackColor = .clear
                progressView.progressColor = #colorLiteral(red: 0.9344636798, green: 0.5902308822, blue: 0.1663158238, alpha: 1)
                progressContainerView.fadeIn(duration: 0.0)
                addProductTitleLabel.text = LS(key: .CREATE_STEP_TITLE_39)
                
                progressView.setProgressWithAnimation(duration: 2, value: 2) { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.progressContainerView.fadeOut(duration: 0.0)
                    FirebaseDBManager.removeFavorite(key: key) { 
                        if strongSelf.selectedProducts.isEmpty {
                            SwiftEntryKit.dismiss()
                        }
                        likeImage.image = #imageLiteral(resourceName: "favorite_button_empty")
                        strongSelf.allFavorites.remove(at: index)
                        strongSelf.emptyContainerView.isHidden = !strongSelf.allFavorites.isEmpty
                        strongSelf.tableView.reloadData()
                    }
                }
            }
        } else {
            likeImage.image = #imageLiteral(resourceName: "favorite_button-1")
            FirebaseDBManager.saveFavoriteProductInDataBase(product: product) { (key) in
                product.generalKey = key
                self.allFavorites.append(product)
            }
        }
        if self.screenState == .list {
            separatorView.isHidden = allFavorites.isEmpty
            emptyContainerView.isHidden = !allFavorites.isEmpty
        }
        tableView.reloadData()
    }
    
    func showBasket() {
        view.endEditing(true)
        performSegue(withIdentifier: "showBasketScreen", sender: nil)
    }
    
    func arrowClicked(by index: IndexPath) {
        //44
    }
    
    func showProgress(back: Bool) {
        view.endEditing(true)
        addProductTitleLabel.text = LS(key: .ADD_PRODUCT_IN_JOURNAL)
        diaryDelegate?.reloadMealtime()
        SwiftEntryKit.dismiss()
        FirebaseDBManager.saveProductList(fetchProductList())
        selectedProducts.removeAll()
        tableView.reloadData()
        
        progressView.trackColor = .clear
        progressView.progressColor = #colorLiteral(red: 0.9344636798, green: 0.5902308822, blue: 0.1663158238, alpha: 1)
        progressContainerView.fadeIn(duration: 0.0)
        
        progressView.setProgressWithAnimation(duration: 2, value: 2) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.progressContainerView.fadeOut(duration: 0.0)
            if back == true {
                SwiftEntryKit.dismiss()
                strongSelf.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func portionClicked(portion: MeasurementUnits, product: SecondProduct, state: Bool) {
        //
    }
    
    func openPortionDetails(by product: SecondProduct) {
        //
    }
    
    func productSelected(_ item: SecondProduct, state: Bool) {
        let filled = SecondProduct(second: item)
        filled.divisionBasketTitle = screenTitle
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
