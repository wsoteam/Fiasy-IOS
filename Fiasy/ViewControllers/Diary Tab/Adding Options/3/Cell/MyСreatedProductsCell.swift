//
//  MyСreatedProductsCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import DropDown

class MyСreatedProductsCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    private var dropDown = DropDown()
    private var indexPath: IndexPath?
    private var delegate: MyСreatedProductsDelegate?
    
    // MARK: - Interface -
    func fillCell(_ item: Favorite, delegate: MyСreatedProductsDelegate, indexPath: IndexPath) {
        fillDropDown()
        self.indexPath = indexPath
        self.delegate = delegate
        nameLabel.text = item.name
        countLabel.text = "\(Int(Double(Double(item.calories ?? 0.0) * 100).displayOnly(count: 0))) ккал • 100 \(item.isLiquid == true ? "мл" : "г")."
    }
    
    //MARK: - Private -
    private func fillDropDown() {
        DropDown.appearance().textFont = UIFont.fontRobotoMedium(size: 15)
        if dropDown.dataSource.isEmpty {
            dropDown.dataSource.append("   Редактировать     ")
            dropDown.dataSource.append("   Удалить")
        }
        
        dropDown.anchorView = containerView
        dropDown.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        dropDown.selectedTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        dropDown.selectionBackgroundColor = .clear
        dropDown.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dropDown.bottomOffset = CGPoint(x: 0, y: 50)
//        dropDown.translatesAutoresizingMaskIntoConstraints = false
//        dropDown.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 20).isActive = true
//        dropDown.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
//        dropDown.topAnchor.constraint(equalTo: containerView.bottomAnchor , constant: 10).isActive = true
//        dropDown.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: containerView.frame.size.height).isActive = true
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let strongSelf = self, let indexPath = strongSelf.indexPath else { return }
            switch index {
            case 0:
                strongSelf.delegate?.editProduct(indexPath)
            case 1:
                strongSelf.delegate?.removeProduct(indexPath)
            default:
                break
            }
        }
    }
    
    // MARK: - Actions -
    @IBAction func dotsClicked(_ sender: Any) {
        dropDown.show()
    }
}
