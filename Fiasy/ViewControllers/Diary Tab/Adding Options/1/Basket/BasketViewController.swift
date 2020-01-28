//
//  BasketViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/5/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol BasketDelegate {
    func showDeleteAlert(indexPath: IndexPath)
    func removeProduct(indexPath: IndexPath)
    func cancelRemoveProduct(indexPath: IndexPath)
    func replaceProduct(newCount: Int, _ selectedPortionId: Int?)
}

class BasketViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var addProductTitleLabel: UILabel!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var blockedView: UIView!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: CircularProgress!
    @IBOutlet weak var progressContainerView: UIView!
    
    // MARK: - Properties -
    private var editIndexPath: IndexPath?
    private var selectedTitle: String = ""
    private var delegate: ProductBasketDelegate?
    private var selectedProducts: [[SecondProduct]] = []
    private var productPresetsView: ProductPresetsView?
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    lazy var removeAlertPresetsView: BasketAlertRemoveView = {
        guard let view = BasketAlertRemoveView.fromXib() else { return BasketAlertRemoveView() }
        return view
    }()
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addProductTitleLabel.text = LS(key: .ADD_PRODUCT_IN_JOURNAL)
        titleButton.setTitle(LS(key: .SELECTED_PRODUCT_TITLE), for: .normal)
        blockedView.isHidden = true
        tableView.tag = 0
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !SwiftEntryKit.isCurrentlyDisplaying() {
            if let view = self.productPresetsView {
                var attributes = EKAttributes()
                attributes.fillAppConfigure(height: 50.0)
                view.fillView(count: selectedProducts.joined().count)
                SwiftEntryKit.display(entry: view, using: attributes)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        SwiftEntryKit.dismiss()
        if let model = sender as? Product, segue.identifier == "sequeProductDetails" && segue.destination is ProductDetailsViewController {
            let vc = segue.destination as? ProductDetailsViewController
            vc?.fillSelectedProduct(product: model, title: model.divisionBasketTitle ?? "", basketProduct: true, delegate: nil)
            vc?.delegate = self
        }
    }
    
    func fillProducts(_ list: [[SecondProduct]], _ delegate: ProductBasketDelegate, _ productPresetsView: ProductPresetsView) {
        self.delegate = delegate
        
        self.selectedProducts = list
        self.productPresetsView = productPresetsView
        self.productPresetsView?.delegate = self
        var attributes = EKAttributes()
        attributes.fillAppConfigure(height: 50.0)
        productPresetsView.fillView(count: list.joined().count)
        if let view = self.productPresetsView {
            SwiftEntryKit.display(entry: view, using: attributes)
        }
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Privates -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:  150, right: 0)
        tableView.register(type: BasketCell.self)
        tableView.register(BasketHeaderView.nib, forHeaderFooterViewReuseIdentifier: BasketHeaderView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    private func showPresetsView() {
//        if !selectedProduct.isEmpty {
//            var attributes = EKAttributes()
//            attributes.fillAppConfigure(height: 80.0)
//            productPresetsView?.fillView(count: selectedProduct.count)
//            if let view = self.productPresetsView {
//                SwiftEntryKit.display(entry: view, using: attributes)
//            }
//        }
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
    
    private func filterArray(_ list: [SecondProduct]) -> [[SecondProduct]] {
        var result: [[SecondProduct]] = [[], [], [], []]
        for item in list {
            switch item.divisionBasketTitle {
            case "Завтрак":
                result[0].append(item)
            case "Обед":
                result[1].append(item)
            case "Ужин":
                result[2].append(item)
            case "Перекус":
                result[3].append(item)
            default:
                result[0].append(item)
            }
        }
        return result
    }
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedProducts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedProducts[section].count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SwiftEntryKit.dismiss()
        let item = selectedProducts[indexPath.section][indexPath.row]
        item.brend = item.brand?.name
        editIndexPath = indexPath
        performSegue(withIdentifier: "sequeProductDetails", sender: item)    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BasketCell") as? BasketCell else { fatalError() }
        cell.fillCell(product: selectedProducts[indexPath.section][indexPath.row],
                      indexPath: indexPath, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if selectedProducts[section].isEmpty { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BasketHeaderView.reuseIdentifier) as? BasketHeaderView else {
            return nil
        }
        if let first = selectedProducts[section].first {
            header.fillHeader(by: first.divisionBasketTitle ?? "")
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return selectedProducts[section].isEmpty ? 0.0001 : BasketHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

extension BasketViewController: ProductAddingDelegate {
    func likeClicked(product: SecondProduct, likeImage: UIImageView) {}
    func openPortionDetails(by product: SecondProduct) {}
    func portionClicked(portion: MeasurementUnits, product: SecondProduct, state: Bool) {}
    func showBasket() {}
    func arrowClicked(by index: IndexPath) {}
    func productSelected(_ item: SecondProduct, state: Bool) {}
    
    func showProgress(back: Bool) {
        view.endEditing(true)
        SwiftEntryKit.dismiss()
        FirebaseDBManager.saveProductList(selectedProducts)
        progressView.trackColor = .clear
        progressView.progressColor = #colorLiteral(red: 0.9344636798, green: 0.5902308822, blue: 0.1663158238, alpha: 1)
        progressContainerView.fadeIn(duration: 0.0)
        
        if let nv = navigationController {
            for vc in nv.viewControllers where vc is DiaryViewController {
                if let diary = vc as? DiaryViewController {
                    diary.getItemsInDataBase()
                }
            }  
        }
        
        delegate?.productsShipped()
        progressView.setProgressWithAnimation(duration: 2, value: 2) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.progressContainerView.fadeOut(duration: 0.0)
            strongSelf.navigationController?.popViewController(animated: true)
        }
    }
}

extension BasketViewController: BasketDelegate {
    
    func removeProduct(indexPath: IndexPath) {
        if selectedProducts.indices.contains(indexPath.section) {
            if selectedProducts[indexPath.section].indices.contains(indexPath.row) {
                delegate?.removeBasketProduct(indexPath: indexPath)
                selectedProducts[indexPath.section].remove(at: indexPath.row)
//                removeRow(indexPath)
                if selectedProducts.joined().count <= 0 {
                    SwiftEntryKit.dismiss()
                    navigationController?.popViewController(animated: true)
                } else {
                    tableView.reloadData()
                    SwiftEntryKit.dismiss()
                    var attributes = EKAttributes()
                    attributes.fillAppConfigure(height: 50.0)
                    productPresetsView?.fillView(count: selectedProducts.joined().count)
                    if let view = self.productPresetsView {
                        blockedView.isHidden = true
                        SwiftEntryKit.display(entry: view, using: attributes)
                    }
                }
            }
        }
    }
    
    func cancelRemoveProduct(indexPath: IndexPath) {
        SwiftEntryKit.dismiss()
        if let cell = tableView.cellForRow(at: indexPath) as? BasketCell {
            cell.checkMark.setOn(true, animated: false)
        }
        var attributes = EKAttributes()
        attributes.fillAppConfigure(height: 50.0)
        productPresetsView?.fillView(count: selectedProducts.joined().count)
        if let view = self.productPresetsView {
            blockedView.isHidden = true
            SwiftEntryKit.display(entry: view, using: attributes)
        }
    }
    
    func showDeleteAlert(indexPath: IndexPath) {
        SwiftEntryKit.dismiss()
        var attributes = EKAttributes()
        attributes.fillAppConfigure(height: 50.0)
        removeAlertPresetsView.fillView(delegate: self, index: indexPath)
        blockedView.isHidden = false
        SwiftEntryKit.display(entry: removeAlertPresetsView, using: attributes)
    }

    func replaceProduct(newCount: Int, _ selectedPortionId: Int?) {
        guard let editIndex = self.editIndexPath else { return }
        if selectedProducts.indices.contains(editIndex.section) {
            if selectedProducts[editIndex.section].indices.contains(editIndex.row) {
                selectedProducts[editIndex.section][editIndex.row].weight = newCount
                selectedProducts[editIndex.section][editIndex.row].portionId = selectedPortionId
                if let id = selectedPortionId, !selectedProducts[editIndex.section][editIndex.row].measurementUnits.isEmpty {
                    for item in selectedProducts[editIndex.section][editIndex.row].measurementUnits where item.id == id {
                        selectedProducts[editIndex.section][editIndex.row].selectedPortion = item
                    }
                }
                tableView.reloadData()
            }
        }
    }
}
