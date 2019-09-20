//
//  WaterCollectionCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class WaterCollectionCell: UICollectionViewCell {

    // MARK: - Outlet -
    @IBOutlet weak var buttleImageView: UIImageView!
    @IBOutlet weak var fillView: CustomView!
    @IBOutlet weak var filledWaterContainerView: UIImageView!
    
    // MARK: - Properties -
    private var indexPath: IndexPath?
    private var isSelectedBottle: Bool = false
    
    // MARK: - Interface -
    func fillCell(state: Bool, indexPath: IndexPath) {
        self.indexPath = indexPath
        
        isSelectedBottle = state
        fillView.isHidden = true
        buttleImageView.image = state ? #imageLiteral(resourceName: "bottle-of-water-40 (1)") : #imageLiteral(resourceName: "bottle-of-water-40")
        filledWaterContainerView.isHidden = true
    }
    
    func fetchSelectedState() -> Bool {
        return isSelectedBottle
    }
}
