//
//  DiaryHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class DiaryHeaderView: UITableViewHeaderFooterView {

    // MARK: - Outlet -
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    // MARK: - Properties -
    static var height: CGFloat = 50.0
    private var section: Int?
    private var delegate: DiaryDisplayManagerDelegate?
    
    // MARK: - Interface -
    func fillHeader(mealTimes: [Mealtime], delegate: DiaryDisplayManagerDelegate, section: Int, state: Bool) {
        self.section = section
        self.delegate = delegate
        
        arrowImageView.image = state ? #imageLiteral(resourceName: "arrow_top") : #imageLiteral(resourceName: "arrow_bottom")
        
        if let first = mealTimes.first {
            titleNameLabel.text = UserInfo.sharedInstance.getTitleMealtime(text: first.parentKey ?? "")
        }
        countLabel.text = "\(mealTimes.count) шт."
    }
    
    // MARK: - Action -
    @IBAction func headerClicked(_ sender: Any) {
        guard let id = self.section else {
            return
        }
        delegate?.headerClicked(section: id)
    }
}
