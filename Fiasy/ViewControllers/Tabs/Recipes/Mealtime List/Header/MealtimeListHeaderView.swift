//
//  MealtimeListHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/6/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MealtimeListHeaderView: UITableViewHeaderFooterView {

    //MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Properties -
    static let headerHeight: CGFloat = 70.0
    
    //MARK: - Interface -
    func fillHeader() {
        titleLabel.text = UserInfo.sharedInstance.selectedMealtimeHeaderTitle
    }
}
