//
//  SearchTabViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Swinject
import RxSwift
import Amplitude_iOS
import XLPagerTabStrip

protocol SearchTabInteractorInput {
    func loadProducts()
    func searchProduct(search: String)
    func loadMoreProducts(pagination: PaginationProduct)
}

protocol SearchTabInteractorOutput: class {
    func didLoadProducts(_ pagination: PaginationProduct)
    func didLoadBySearch(_ pagination: PaginationProduct)
    func didLoadMoreProducts(_ products: [SecondProduct])
}

class SearchTabViewController: UIViewController, Assembly, SwinjectInitAssembler {
    
    func assemble(container: Container) {}
    
    // MARK: - Outlets -
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!
    @IBOutlet weak var emptySearchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    var interactor: SearchTabInteractorInput?
    private var needReload: Bool = true
    private var contentOffsetY: Int = 0
    private var pagination: PaginationProduct?
    private var itemInfo = IndicatorInfo(title: "Поиск")
    private var products: [SecondProduct] = []
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityView.startAnimating()
        setupInteractor()
        fetchProducts()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
        addObserver(for: self, #selector(searchByText), "searchClicked")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
        if needReload {
            interactor?.loadProducts()
        } else {
            needReload = true
        }
    }
    
    @objc func searchByText() {
        activityView.startAnimating()
        if UserInfo.sharedInstance.searchProductText.isEmpty {
            interactor?.loadProducts()
        } else {
            interactor?.searchProduct(search: UserInfo.sharedInstance.searchProductText)
        }
        tableView.reloadData()
    }

    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: SearchCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    private func setupInteractor() {
        let container = assembler.resolver as! Container
        let profileService = container.resolve(ProfileServiceProtocol.self)!
        let interactor = SearchTabInteractor(profileService: profileService)
        interactor.output = self
        self.interactor = interactor
    }
    
    private func fetchProducts() {
        self.interactor?.loadProducts()
    }
    
    // MARK: - Actions -
    @IBAction func addProductClicked(_ sender: UIButton) {}
}

extension SearchTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell else { fatalError() }
        if products.indices.contains(indexPath.row) {
            cell.fillCell(info: products[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if products.indices.contains(indexPath.row) {
            let f = products[indexPath.row]
            UserInfo.sharedInstance.selectedProduct = products[indexPath.row]
            needReload = false
            performSegue(withIdentifier: "sequeProductDetails", sender: nil)
        }
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

extension SearchTabViewController: IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

class SearchTabInteractor: SearchTabInteractorInput {
    
    weak var output: SearchTabInteractorOutput?
    private let profileService: ProfileServiceProtocol
    private var dispose = DisposeBag()

    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    func loadProducts() {
        profileService.loadProducts().subscribe(onNext: { [weak self] (response) in
            guard let strongSelf = self else { return }
            strongSelf.output?.didLoadProducts(response)
        }).disposed(by: dispose)
    }
    
    func loadMoreProducts(pagination: PaginationProduct) {
        guard let link = pagination.next, !link.isEmpty else { return }
        profileService.loadMoreProducts(link: link).subscribe(onNext: { [weak self] (response) in
            guard let strongSelf = self else { return }
            strongSelf.output?.didLoadMoreProducts(response.results)
        }).disposed(by: dispose)
    }
    
    func searchProduct(search: String) {
        profileService.searchProduct(search: search).subscribe(onNext: { [weak self] (response) in
            guard let strongSelf = self else { return }
            Amplitude.instance()?.logEvent("search_success", withEventProperties: ["search_item" : search]) // +
            strongSelf.output?.didLoadBySearch(response)
        }).disposed(by: dispose)
    }
}

extension SearchTabViewController: SearchTabInteractorOutput {
    
    func didLoadProducts(_ pagination: PaginationProduct) {
        self.pagination = pagination
        self.activityView.stopAnimating()
        self.products = pagination.results
        
        self.emptySearchView.isHidden = !products.isEmpty
        self.tableView.reloadData()
    }
    
    func didLoadMoreProducts(_ products: [SecondProduct]) {
        for item in products {
            self.products.append(item)
        }
        self.tableView.reloadData()
    }
    
    func didLoadBySearch(_ pagination: PaginationProduct) {
        self.pagination = pagination
        self.emptySearchView.isHidden = !pagination.results.isEmpty
        self.products = pagination.results
        self.activityView.stopAnimating()
        self.tableView.reloadData()
    }
}
