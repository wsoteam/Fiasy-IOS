//
//  ActivityHeaderTableView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/10/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ActivityHeaderTableView: UITableViewHeaderFooterView {

    // MARK: - Outlet -
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var titleNameLabel: UILabel!
    
    // MARK: - Properties -
    static var height: CGFloat = 40.0
    private var delegate: ActivityManagerDelegate?
    private var section: Int?
    
    // MARK: - Interface -
    func fillHeader(section: Int, delegate: ActivityManagerDelegate, state: Bool, _ isEmpty: Bool) {
        self.section = section
        self.delegate = delegate
        
        switch section {
        case 0:
            titleNameLabel.text = "Мои активности"
        case 1:
            titleNameLabel.text = "Избранное"
        case 2:
            titleNameLabel.text = "Стандартные активности"
        default:
            break
        }
        
        if isEmpty {
            arrowImageView.isHidden = true
        } else {
            arrowImageView.isHidden = false
            arrowImageView.image = state ? #imageLiteral(resourceName: "Arrow_top-1") : #imageLiteral(resourceName: "Arrow_down-1")
        }
    }
    
    // MARK: - Action -
    @IBAction func headerClicked(_ sender: Any) {
        guard let id = self.section else { return }
        delegate?.headerClicked(section: id)
    }
}
