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
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var titleNameLabel: UILabel!
    
    // MARK: - Properties -
    static var height: CGFloat = 40.0
    private var section: Int?
    private var tagIndex: Int = 0
    private var delegate: DiaryDisplayManagerDelegate?
    
    // MARK: - Interface -
    func fillHeader(delegate: DiaryDisplayManagerDelegate, section: Int, state: Bool, _ hasItems: Bool) {
        self.section = section
        self.delegate = delegate
        
        switch section {
        case 1:
            tagIndex = 0
            titleNameLabel.text = "Завтрак"
        case 2:
            tagIndex = 1
            titleNameLabel.text = "Обед"
        case 3:
            tagIndex = 2
            titleNameLabel.text = "Ужин"
        case 4:
            tagIndex = 3
            titleNameLabel.text = "Перекус"
        default:
            break
        }
        if hasItems {
            arrowImageView.isHidden = false
            arrowImageView.image = state ? #imageLiteral(resourceName: "Arrow_top-1") : #imageLiteral(resourceName: "Arrow_down-1")
        } else {
            arrowImageView.isHidden = true
        }
    }
    
    // MARK: - Action -
    @IBAction func headerClicked(_ sender: Any) {
        guard let id = self.section else { return }
        delegate?.headerClicked(section: id)
    }
    
    @IBAction func plusClicked(_ sender: Any) {
        UserInfo.sharedInstance.selectedMealtimeIndex = tagIndex
        delegate?.showProductTab()
    }
}
