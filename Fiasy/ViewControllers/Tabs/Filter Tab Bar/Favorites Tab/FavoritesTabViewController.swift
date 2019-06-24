//
//  FavoritesTabViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FavoritesTabViewController: UIViewController {
    
    // MARK: - Properties -
    private var itemInfo = IndicatorInfo(title: "Избранное")
    
    // MARK: - Action's -
    @IBAction func addProductClicked(_ sender: Any) {
        
    }
}

extension FavoritesTabViewController: IndicatorInfoProvider {
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
