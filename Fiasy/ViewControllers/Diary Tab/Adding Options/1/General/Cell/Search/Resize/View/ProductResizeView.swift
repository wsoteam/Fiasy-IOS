//
//  ProductResizeView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/14/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import BEMCheckBox

class ProductResizeView: UIView {
    
    // MARK: - Outlet -
    @IBOutlet weak var checkMarkView: BEMCheckBox!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    // MARK: - Properties -
    private var delegate: ProductAddingDelegate?
    private var product: SecondProduct?
    private var portion: MeasurementUnits?
    
    // MARK: - Interface -
    func fillView(portion: MeasurementUnits, product: SecondProduct, delegate: ProductAddingDelegate, selectedProduct: [[SecondProduct]], _ title: String) {
        self.delegate = delegate
        self.product = product
        self.portion = portion
        setupCheckMark()
        checkMarkView.setOn(false, animated: false)
        
        var productList: [SecondProduct] = []
        switch title {
        case "Завтрак":
            productList = selectedProduct[0]
        case "Обед":
            productList = selectedProduct[1]
        case "Ужин":
            productList = selectedProduct[2]
        case "Перекус":
            productList = selectedProduct[3]
        default:
            productList = selectedProduct[0]
        }
        for item in productList where (item.id == product.id) && item.selectedPortion?.amount == portion.amount {
            checkMarkView.setOn(true, animated: false)
            break
        }
        topLabel.text = portion.name
        bottomLabel.text = "\(portion.amount) \(product.isLiquid == true ? "мл" : "ккал")"
    }
    
    // MARK: - Private -
    private func setupCheckMark() {
        checkMarkView.boxType = .square
    }
    
    // MARK: - Actions -
    @IBAction func checkMarkClicked(_ sender: Any) {
        guard let portion = self.portion, let product = self.product else { return }
        checkMarkView.setOn(!checkMarkView.on, animated: true)
        delegate?.portionClicked(portion: portion, product: product, state: checkMarkView.on)
    }
    
    @IBAction func portionClicked(_ sender: Any) {
        guard let portion = self.portion, let product = self.product else { return }
        delegate?.openPortionDetails(by: SecondProduct(second: product, portion: portion))
    }
}
