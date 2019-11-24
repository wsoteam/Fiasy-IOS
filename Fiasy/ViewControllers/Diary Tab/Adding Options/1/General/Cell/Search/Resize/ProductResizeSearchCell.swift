//
//  ProductResizeSearchCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/14/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ProductResizeSearchCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var insertStackView: UIStackView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    // MARK: - Properties -
    private var indexCell: IndexPath?
    private var delegate: ProductAddingDelegate?
    private var product: SecondProduct?
    
    // MARK: - Life Cicle -
    override func prepareForReuse() {
        super.prepareForReuse()
        
        insertStackView.removeAllSubviews()
    }
    
    // MARK: - Interface -
    func fillCell(product: SecondProduct, delegate: ProductAddingDelegate, isOpen: Bool, indexPath: IndexPath, selectedProduct: [[SecondProduct]], title: String) {
        self.indexCell = indexPath
        self.delegate = delegate
        self.product = product
        
        insertStackView.isHidden = !isOpen
        arrowButton.setImage(isOpen ? #imageLiteral(resourceName: "Arrow_top-1") : #imageLiteral(resourceName: "Arrow_down-1"), for: .normal)
        self.product?.measurementUnits.sort { $0.amount < $1.amount }
        if let product = self.product {
            fillName(product: product)
            fillPortion(product: product)
            
            if insertStackView.subviews.isEmpty {
                for item in product.measurementUnits {
                    guard let view = ProductResizeView.fromXib() else { return }
                    view.fillView(portion: item, product: product, delegate: delegate, selectedProduct: selectedProduct, title)
                    insertStackView.addArrangedSubview(view)
                }
            }
        }
    }
    
    // MARK: - Private -
    private func fillName(product: SecondProduct) { 
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(NSAttributedString(string: product.name, attributes: [.font: UIFont.sfProTextSemibold(size: 15), .foregroundColor: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
        if let name = product.brand?.name {
            mutableAttrString.append(NSAttributedString(string: " (\(name))", attributes: [.font: UIFont.sfProTextMedium(size: 13), .foregroundColor: #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)]))
        }
        productNameLabel.attributedText = mutableAttrString
    }
    
    private func fillPortion(product: SecondProduct) { 
        let mutableAttrString = NSMutableAttributedString()
        var range: String = ""
        var calorie: String = ""
        let unit = product.isLiquid == true ? "мл" : "г"
        if product.measurementUnits.count > 1 {
            if let first = product.measurementUnits.first, let last = product.measurementUnits.last {
                range = "\(first.amount) - \(last.amount) \(unit)."
            }
            if let calor = product.calories {
                let first = calor * Double(product.measurementUnits.first?.amount ?? 0)
                let last = calor * Double(product.measurementUnits.last?.amount ?? 0)
                calorie = "\(Int(first.rounded(toPlaces: 1).displayOnly(count: 0))) - \(Int(last.rounded(toPlaces: 1).displayOnly(count: 0))) ккал"
            }
        } else {
            range = "\(product.measurementUnits.first?.amount ?? 0) \(unit)."
            if let calor = product.calories {
                let count = calor * Double(product.measurementUnits.first?.amount ?? 0)
                calorie = "\(Int(count.rounded(toPlaces: 1).displayOnly(count: 0))) ккал"
            }
        }
        mutableAttrString.append(NSAttributedString(string: "\(product.measurementUnits.count) \(getPrefixTitle(count: product.measurementUnits.count)): \(range) • \(calorie)", attributes: [.font: UIFont.sfProTextSemibold(size: 11), .foregroundColor: #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)]))
        productDescriptionLabel.attributedText = mutableAttrString
    }
    
    private func getPrefixTitle(count: Int) -> String {
        switch count {
        case 1:
            return "порция"
        case 2,3,4:
            return "порции"
        default:
            return "порций"
        }
    }
    
    // MARK: - Actions -
    @IBAction func arrowClicked(_ sender: Any) {
        guard let index = self.indexCell else { return }
        delegate?.arrowClicked(by: index)
    }
}
