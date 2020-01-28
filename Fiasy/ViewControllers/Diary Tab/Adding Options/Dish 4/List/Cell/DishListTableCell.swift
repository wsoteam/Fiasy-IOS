//
//  DishListTableCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/13/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit
import DropDown
import Kingfisher

class DishListTableCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    private var dropDown = DropDown()
    private var removeKey: String?
    private var delegate: DishListDelegate?
    
    // MARK: - Interface -
    func fillCell(_ item: Dish, delegate: DishListDelegate, indexPath: IndexPath) {
        fillDropDown()
        self.removeKey = item.generalKey
        self.delegate = delegate
        nameLabel.text = item.name
        
        if let path = item.imageUrl, let url = try? path.asURL() {
            let resource = ImageResource(downloadURL: url)
            dishImageView.kf.setImage(with: resource)
            dishImageView.contentMode = .scaleAspectFill
        } else {
            dishImageView.image = #imageLiteral(resourceName: "Dish_234")
            dishImageView.contentMode = .scaleAspectFit
        }
        
        var calories: Double = 0.0
        var isLiquid: Bool = false
        for item in item.products {
            calories += item.calories ?? 0.0
            isLiquid = item.isLiquid ?? false
        }
        countLabel.text = "\(Int(Double(calories * 100).displayOnly(count: 0))) \(LS(key: .CALORIES_UNIT)) • 100 \(isLiquid == true ? LS(key: .LIG_PRODUCT) : LS(key: .GRAMS_UNIT))."
    }
    
    //MARK: - Private -
    private func fillDropDown() {
        DropDown.appearance().IBcornerRadius = 10
        DropDown.appearance().textFont = UIFont.sfProTextMedium(size: 15)
        if dropDown.dataSource.isEmpty {
            dropDown.dataSource.append("     \(LS(key: .CREATE_STEP_TITLE_36))")
            dropDown.dataSource.append("     \(LS(key: .DELETE))")
        }
        
        dropDown.anchorView = containerView
        dropDown.textColor = #colorLiteral(red: 0.2431066334, green: 0.2431548834, blue: 0.2431036532, alpha: 1)
        dropDown.selectedTextColor = #colorLiteral(red: 0.2431066334, green: 0.2431548834, blue: 0.2431036532, alpha: 1)
        dropDown.selectionBackgroundColor = .clear
        dropDown.backgroundColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
        dropDown.shadowColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 0.7022146451)
        DropDown.appearance().cellHeight = 50
        dropDown.bottomOffset = CGPoint(x: 0, y: 50)
        
        dropDown.cornerRadius = 8.0
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let strongSelf = self, let removeKey = strongSelf.removeKey else { return }
            switch index {
            case 0:
                strongSelf.delegate?.editProduct(removeKey)
            case 1:
                strongSelf.delegate?.removeProduct(removeKey)
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

