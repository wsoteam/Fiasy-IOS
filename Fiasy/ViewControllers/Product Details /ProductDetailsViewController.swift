//
//  ProductDetailsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS

protocol ProductDetailsDelegate {
    func closeModule()
    func showAlert(message: String)
    func showSendError()
    func showEmptyTextAlert()
    func showZeroAlert()
}

class ProductDetailsViewController: UIViewController {
    
    // MARK: - Outlets -
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var mealTimeTitleLabel: UILabel!
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var isMakeRecipe: Bool = false
    private var isOwnRecipe: Bool = false
    private var selectedProduct = UserInfo.sharedInstance.selectedProduct
    private var editProduct: Mealtime?
    private var isEditState: Bool = false
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
                  
        isMakeRecipe = ((backViewController() as? ProductSearchListViewController) != nil)
        if let editMealTime = FirebaseDBManager.fetchEditMealtime() {
            self.editProduct = editMealTime
            self.isEditState = true
            UserInfo.sharedInstance.editMealtime = nil
            if let selected = SQLDatabase.shared.getEditProduct(by: editMealTime) {
                selectedProduct = selected
            } else {
                tableView.alpha = 0
                FirebaseDBManager.fetchUndeletableCustomFoodsInDataBase { [weak self] (allFavorites) in
                    guard let `self` = self else { return }
                    for item in allFavorites where item.name?.lowercased() == editMealTime.name?.lowercased() {
                        self.selectedProduct = Product(favorite: item)
                        self.setupInitialState()
                        self.tableView.alpha = 1
                        self.tableView.reloadData()
                        break
                    }
                }
            }
        }
        setupInitialState()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardWhenTappedAround()
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    func fillOwnRecipe() {
        isOwnRecipe = true
    }
    
    // MARK: - Private -
    private func setupInitialState() {
        guard let selectedProduct = selectedProduct else { return }
        productNameLabel.attributedText = fillName(product: selectedProduct)
        mealTimeTitleLabel.text = "   \(UserInfo.sharedInstance.getTitleMealtime(text: UserInfo.sharedInstance.getTitleMealtimeForFirebase()))   "
    }
    
    private func fillName(product: Product) -> NSMutableAttributedString {
        let mutableAttrString = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoMedium(size: isIphone5 ? 20.0 : 24.0),
                                                  color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: product.name))
        if let brend = product.brend, !brend.isEmpty {
            mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoRegular(size: isIphone5 ? 16.0 : 20.0), color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: "\n(\(brend))"))
        }
        mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
        return mutableAttrString
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Хорошо", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tableView.register(type: ProductDetailsCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        
    }
}

extension ProductDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDetailsCell") as? ProductDetailsCell else { fatalError() }
        cell.fillCell(product: selectedProduct, delegate: self, editProduct: editProduct, isEditState, isMakeRecipe, isOwnRecipe: isOwnRecipe)
        return cell
    }
}

extension ProductDetailsViewController: ProductDetailsDelegate {
    
    func closeModule() {
        navigationController?.popViewController(animated: true)
    }
    
    func showSendError() {
        performSegue(withIdentifier: "sequeSendErrorScreen", sender: nil)
    }
    
    func showAlert(message: String) {
        self.showAlert(title: "Внимание", message: message)
    }
    
    func showZeroAlert() {
        self.showAlert(title: "Внимание", message: "Вес не должен состоять из нулей")
    }
    
    func showEmptyTextAlert() {
        self.showAlert(title: "Внимание", message: "Введите вес продукта")
    }
}
