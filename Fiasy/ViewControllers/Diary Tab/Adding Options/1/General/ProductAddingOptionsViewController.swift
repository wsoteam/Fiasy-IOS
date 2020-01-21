//
//  ProductAddingOptionsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/4/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Swinject
import SwiftEntryKit

enum ProductAddingState {
    case list
    case search
    case suggest
}

protocol ProductSearchDelegate {
    func searchSuggestionItem(text: String)
    func changeScreenState(state: ProductAddingState)
    func searchItem(text: String)
}

protocol ProductBasketDelegate {
    func productsShipped()
    func removeBasketProduct(indexPath: IndexPath)
    func changeMenuSelected(indexPath: IndexPath)
}

protocol ProductAddingDelegate {
    func showBasket()
    func arrowClicked(by index: IndexPath)
    func showProgress(back: Bool)
    func portionClicked(portion: MeasurementUnits, product: SecondProduct, state: Bool)
    func openPortionDetails(by product: SecondProduct)
    func productSelected(_ item: SecondProduct, state: Bool)
    func likeClicked(product: SecondProduct, likeImage: UIImageView)
}

class ProductAddingOptionsViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var addProductTitleLabel: UILabel!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var progressView: CircularProgress!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    var diaryDelegate: DiaryViewDelegate?
    var keyboardHeight: CGFloat = 50.0
    private var dontShowView: Bool = false
    private var contentOffsetY: Int = 0
    private var pagination: PaginationProduct?
    private var products: [SecondProduct] = []
    private var screenState: ProductAddingState = .list
    private var interactor: SearchProductInteractorInput?
    lazy var dropdownView: LMDropdownView = LMDropdownView()
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var selectedProducts: [[SecondProduct]] = [[], [], [], []]
    private var openCells: [IndexPath] = []
    private var suggestList: [ProductInfo] = []
    private var selectedTitle: String = ""
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
        
        addProductTitleLabel.text = LS(key: .ADD_PRODUCT_IN_JOURNAL)
        tableView.tag = 0
        menuTableView.tag = 1
        setupTableView()
        setupInteractor()
        dropdownView.delegate = self
        fillTitleNavigation(index: UserInfo.sharedInstance.selectedMealtimeIndex)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuTableView.frame = CGRect(x: menuTableView.frame.minX,
                                  y: menuTableView.frame.minY,
                              width: view.bounds.width,
                             height: min(view.bounds.height, CGFloat(200)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dontShowView = false
        productPresetsView.delegate = self
        configurationKeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !SwiftEntryKit.isCurrentlyDisplaying() && selectedProducts.joined().count > 0 {
            if dontShowView { return }
            var attributes = EKAttributes()
            attributes.fillAppConfigure(height: keyboardHeight)
            self.productPresetsView.fillView(count: selectedProducts.joined().count)
            SwiftEntryKit.display(entry: self.productPresetsView, using: attributes)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        dontShowView = true
        SwiftEntryKit.dismiss()
        if selectedProducts.joined().count > 0 {
            showBackAlert()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func titleButtonClicked(_ sender: Any) {
        menuTableView.reloadData()
        showDropdownView(fromDirection: .top)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SwiftEntryKit.dismiss()
        if segue.identifier == "showBasketScreen" {
            if let vc = segue.destination as? BasketViewController {
                vc.fillProducts(selectedProducts, self, productPresetsView)
            }
        } else if segue.identifier == "sequeProductDetails" {
            if let vc = segue.destination as? ProductDetailsViewController, let product = sender as? SecondProduct {
                SwiftEntryKit.dismiss()
                vc.fillSelectedProduct(product: product, title: selectedTitle, basketProduct: false)
            }
        } else if segue.identifier == "showFavoriteProductScreen" {
            if let vc = segue.destination as? FavoriteProductViewController {
                vc.fillTitle(selectedTitle, diaryDelegate: diaryDelegate)
            }
        }
    }
    
    func reloadBottomView() {
        guard !dontShowView else { return }
        if SwiftEntryKit.isCurrentlyDisplaying() {
            var attributes = EKAttributes()
            attributes.fillAppConfigure(height: keyboardHeight)
            productPresetsView.fillView(count: selectedProducts.joined().count)
            SwiftEntryKit.display(entry: productPresetsView, using: attributes)
        }
    }
    
    // MARK: - Privates -
    private func showBackAlert() {
        SwiftEntryKit.dismiss()
        let alert = UIAlertController(title: LS(key: .ATTENTION), message: LS(key: .ALERT_BASKET), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LS(key: .ALERT_ADD), style: .default, handler: { action in
            SwiftEntryKit.dismiss()
            self.showProgress(back: true)
        }))
        alert.addAction(UIAlertAction(title: LS(key: .ALERT_NO), style: .default, handler: { action in
            SwiftEntryKit.dismiss()
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    private func showDevelopmentAlert() {
        let alert = UIAlertController(title: LS(key: .ATTENTION), message: LS(key: .ALERT_DEVELOPMENT), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(type: ProductResizeSearchCell.self)
        tableView.register(type: SearchSuggestProductCell.self)
        tableView.register(type: ProductAddingSearchCell.self)
        tableView.register(type: ProductAddingOptionsCell.self)
        tableView.register(type: ProductSearchEmptyCell.self)
        tableView.register(ProductSearchHeaderView.nib, forHeaderFooterViewReuseIdentifier: ProductSearchHeaderView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
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
        if selectedProducts.joined().count == 0 {
            SwiftEntryKit.dismiss()
        } else {
            if SwiftEntryKit.isCurrentlyDisplaying() {
                productPresetsView.fillView(count: selectedProducts.joined().count)
            } else {
                var attributes = EKAttributes()
                attributes.fillAppConfigure(height: keyboardHeight)
                productPresetsView.fillView(count: selectedProducts.joined().count)
                SwiftEntryKit.display(entry: productPresetsView, using: attributes)
            }
        }
    }
    
    private func fillTitleNavigation(index: Int) {
        switch index {
        case 0:
            selectedTitle = LS(key: .BREAKFAST)
        case 1:
            selectedTitle = LS(key: .LUNCH)
        case 2:
            selectedTitle = LS(key: .DINNER)
        case 3:
            selectedTitle = LS(key: .SNACK)
        default:
            break
        }
        titleButton.setTitle("\(selectedTitle) ", for: .normal)
    }
}

extension ProductAddingOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            if screenState == .search {
               return products.isEmpty ? 1 : products.count
            } else if screenState == .suggest {
                return suggestList.count
            } else {
               return 4
            }
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            if screenState == .search {
                if products.isEmpty {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSearchEmptyCell") as? ProductSearchEmptyCell else { fatalError() }
                    return cell
                } else {
                    let product = products[indexPath.row]
                    if product.measurementUnits.isEmpty {
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductAddingSearchCell") as? ProductAddingSearchCell else { fatalError() }
                        cell.fillCell(indexPath.row == 0, product: products[indexPath.row], delegate: self, selectedProducts, title: selectedTitle)
                        return cell
                    } else {
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductResizeSearchCell") as? ProductResizeSearchCell else { fatalError() }
                        cell.fillCell(product: products[indexPath.row], delegate: self, isOpen: openCells.contains(indexPath), indexPath: indexPath, selectedProduct: selectedProducts, title: selectedTitle)
                        return cell
                    }
                }
            } else if screenState == .suggest {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchSuggestProductCell") as? SearchSuggestProductCell else { fatalError() }
                if let header = tableView.headerView(forSection: 0) as? ProductSearchHeaderView, let text = header.textField.text {
                    cell.fillCell(product: suggestList[indexPath.row], searchText: text, indexPath: indexPath)
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductAddingOptionsCell") as? ProductAddingOptionsCell else { fatalError() }
                cell.fillCell(indexPath)
                return cell
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? MenuCell else { fatalError() }
            cell.fillCell(indexPath, selectedTitle: self.selectedTitle, delegate: nil)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            fillTitleNavigation(index: indexPath.row)
            if dropdownView.isOpen {
                dropdownView.hide()
            }
            self.tableView.reloadData()
        } else if screenState == .list {
            //showDevelopmentAlert()
            switch indexPath.row {
//            case 0:
//                performSegue(withIdentifier: "showBarCodeScreen", sender: nil)
            case 0:
                performSegue(withIdentifier: "showFavoriteProductScreen", sender: nil)
            case 1:
                performSegue(withIdentifier: "sequeTemplateScreen", sender: nil)
            case 2:
                performSegue(withIdentifier: "sequeDishScreen", sender: nil)
            case 3:
                performSegue(withIdentifier: "sequeMyСreatedProductsScreen", sender: nil)
            default:
                break
            }
        } else if screenState == .suggest {
            if suggestList.indices.contains(indexPath.row) {
                if let header = tableView.headerView(forSection: 0) as? ProductSearchHeaderView {
                    header.textField.text = suggestList[indexPath.row].name
                }
                let name = suggestList[indexPath.row].name ?? ""
                self.suggestList.removeAll()
                self.pagination = nil
                self.interactor?.searchProduct(search: name)
            }
        } else if screenState == .search {
            if !products.isEmpty {
                if products.indices.contains(indexPath.row) {
                    performSegue(withIdentifier: "sequeProductDetails", sender: products[indexPath.row])
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductSearchHeaderView.reuseIdentifier) as? ProductSearchHeaderView else {
            return nil
        }
        header.fillHeader(delegate: self)
//        header.textField.placeholder = "Поиск"
//        header.textField.tintColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
        return header
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.backgroundView?.backgroundColor = .white
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductSearchHeaderView.reuseIdentifier) as? ProductSearchHeaderView else {
            return 0.0001
        }
        return ProductSearchHeaderView.height
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
        if let header = tableView.headerView(forSection: 0) as? ProductSearchHeaderView {
            if scrollView.contentOffset.y > 0 {
                addShadow(header.searchContainerView)
            } else {
                deleteShadow(header.searchContainerView)
            }
        }
    }
}

// MARK: - LMDropdownViewDelegate
extension ProductAddingOptionsViewController: LMDropdownViewDelegate {
    
    func showDropdownView(fromDirection direction: LMDropdownViewDirection) {
        guard let _ = navigationController else { return }
        dropdownView.direction = direction
        
        if dropdownView.isOpen {
            dropdownView.hide()
        }
        else {
            switch direction {
            case .top:
                dropdownView.contentBackgroundColor = UIColor(red: 40.0/255, green: 196.0/255, blue: 80.0/255, alpha: 1)
                dropdownView.show(menuTableView, containerView: listContainerView)
            case .bottom:
                dropdownView.contentBackgroundColor = .white
            }
        }
    }
    
    func dropdownViewWillShow(_ dropdownView: LMDropdownView) {
        titleButton.setImage(#imageLiteral(resourceName: "Polygon (2)"), for: .normal)
    }
    
    func dropdownViewDidShow(_ dropdownView: LMDropdownView) {
        listContainerView.isUserInteractionEnabled = true
    }
    
    func dropdownViewWillHide(_ dropdownView: LMDropdownView) {}
    func dropdownViewDidHide(_ dropdownView: LMDropdownView) {
        titleButton.setImage(#imageLiteral(resourceName: "Polygon (1)"), for: .normal)
        listContainerView.isUserInteractionEnabled = false
    }
}

extension ProductAddingOptionsViewController: SearchProductInteractorOutput {
    
    func didLoadSuggest(list: [ProductInfo]) {
        if let header = tableView.headerView(forSection: 0) as? ProductSearchHeaderView, let text = header.textField.text, text.isEmpty {
            suggestList.removeAll()
            return
        }
        suggestList = list
        screenState = list.isEmpty ? .search : .suggest
        tableView.reloadData()
    }
    
    func didLoadBySearch(_ pagination: PaginationProduct) {
        self.screenState = .search
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

extension ProductAddingOptionsViewController: ProductSearchDelegate {
    
    func searchSuggestionItem(text: String) {
        if text.isEmpty {
            if self.screenState == .search {
                self.products.removeAll()
                self.tableView.reloadData()
            } else if self.screenState == .suggest {
                self.screenState = .search
                self.tableView.reloadData()
            }
        } else { 
            self.interactor?.loadSuggest(by: text)
        }
    }
    
    func changeScreenState(state: ProductAddingState) {
        guard state != screenState else { return }
        screenState = state
        tableView.reloadData()
    }
    
    func searchItem(text: String) {
        if text.isEmpty {
            self.products.removeAll()
            self.tableView.reloadData()
        } else {
            self.pagination = nil
            self.interactor?.searchProduct(search: text)
        }
    }
}

extension ProductAddingOptionsViewController: ProductAddingDelegate  {
    
    func likeClicked(product: SecondProduct, likeImage: UIImageView) {}
    func openPortionDetails(by product: SecondProduct) {
        performSegue(withIdentifier: "sequeProductDetails", sender: product)
    }
    
    func portionClicked(portion: MeasurementUnits, product: SecondProduct, state: Bool) {
        let filled = SecondProduct(second: product, portion: portion)
        if state {
            filled.divisionBasketTitle = selectedTitle
            switch selectedTitle {
            case LS(key: .BREAKFAST):
                selectedProducts[0].append(filled)
            case LS(key: .LUNCH):
                selectedProducts[1].append(filled)
            case LS(key: .DINNER):
                selectedProducts[2].append(filled)
            case LS(key: .SNACK):
                selectedProducts[3].append(filled)
            default:
                selectedProducts[0].append(filled)
            }
        } else {
            var findIndex: Int?
            var productList: [SecondProduct] = []
            switch selectedTitle {
            case LS(key: .BREAKFAST):
                findIndex = 0
                productList = selectedProducts[0]
            case LS(key: .LUNCH):
                findIndex = 1
                productList = selectedProducts[1]
            case LS(key: .DINNER):
                findIndex = 2
                productList = selectedProducts[2]
            case LS(key: .SNACK):
                findIndex = 3
                productList = selectedProducts[3]
            default:
                findIndex = 0
                productList = selectedProducts[0]
            }
            
            for (index, second) in productList.enumerated() where second.id == filled.id {
                if let find = findIndex {
                    if second.selectedPortion?.amount == portion.amount {
                        if selectedProducts[find].indices.contains(index) {
                            selectedProducts[find].remove(at: index)
                            break
                        }
                    }
                }
            }
        }
        displayPresets()
    }
    
    func arrowClicked(by index: IndexPath) {
        if openCells.contains(index) {
            for (ind, item) in openCells.enumerated() where item.row == index.row && item.section == index.section {
                openCells.remove(at: ind)
                break
            }
        } else {
            openCells.append(index)
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [index], with: .fade)
        tableView.endUpdates()
    }
    
    func showProgress(back: Bool) {
        view.endEditing(true)
        diaryDelegate?.reloadMealtime()
        SwiftEntryKit.dismiss()
        FirebaseDBManager.saveProductList(selectedProducts)
        products.removeAll()
        selectedProducts = [[], [], [], []]
        
        screenState = .list
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
    
    func showBasket() {
        view.endEditing(true)
        performSegue(withIdentifier: "showBasketScreen", sender: nil)
    }
    
    func productSelected(_ item: SecondProduct, state: Bool) {
        let filled = SecondProduct(second: item)
        if state {
            filled.divisionBasketTitle = selectedTitle
            switch selectedTitle {
            case LS(key: .BREAKFAST):
                selectedProducts[0].append(filled)
            case LS(key: .LUNCH):
                selectedProducts[1].append(filled)
            case LS(key: .DINNER):
                selectedProducts[2].append(filled)
            case LS(key: .SNACK):
                selectedProducts[3].append(filled)
            default:
                selectedProducts[0].append(filled)
            }
        } else {
            var findIndex: Int?
            var productList: [SecondProduct] = []
            switch selectedTitle {
            case LS(key: .BREAKFAST):
                findIndex = 0
                productList = selectedProducts[0]
            case LS(key: .LUNCH):
                findIndex = 1
                productList = selectedProducts[1]
            case LS(key: .DINNER):
                findIndex = 2
                productList = selectedProducts[2]
            case LS(key: .SNACK):
                findIndex = 3
                productList = selectedProducts[3]
            default:
                findIndex = 0
                productList = selectedProducts[0]
            }
            
            for (index, second) in productList.enumerated() where second.id == filled.id {
                if let find = findIndex {
                    if selectedProducts[find].indices.contains(index) {
                        selectedProducts[find].remove(at: index)
                    }
                }
            }
        }
        displayPresets()
    }
}

extension ProductAddingOptionsViewController: ProductBasketDelegate {
    
    func productsShipped() {
        view.endEditing(true)
        selectedProducts = [[], [], [], []]
        products.removeAll()
        diaryDelegate?.reloadMealtime()
        
        screenState = .list
        tableView.reloadData()
    }
    
    func changeMenuSelected(indexPath: IndexPath) {
        fillTitleNavigation(index: indexPath.row)
    }
    
    func removeBasketProduct(indexPath: IndexPath) {
        if selectedProducts.indices.contains(indexPath.section) {
            if selectedProducts[indexPath.section].indices.contains(indexPath.row) {
                selectedProducts[indexPath.section].remove(at: indexPath.row)
            }
        }
        if selectedProducts.joined().count <= 0 {
            SwiftEntryKit.dismiss()
        }
        tableView.reloadData()
    }
}
