//
//  TemplatesTabViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TemplatesTabViewController: UIViewController {
    
    // MARK: - Properties -
    private var itemInfo = IndicatorInfo(title: "Шаблоны")
    
    // MARK: - Action's -
    @IBAction func addTemplatesClicked(_ sender: Any) {
        post("AddTemplatesScreen")
    }
}

extension TemplatesTabViewController: IndicatorInfoProvider {
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
