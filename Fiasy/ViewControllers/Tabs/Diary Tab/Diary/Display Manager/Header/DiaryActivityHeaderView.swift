//
//  DiaryActivityHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class DiaryActivityHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Outlet -
    //article_next
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    // MARK: - Properties -
    private var section: Int?
    private var tagIndex: Int = 0
    static var height: CGFloat = 60.0
    private var delegate: DiaryDisplayManagerDelegate?
    
    // MARK: - Interface -
    func fillHeader(_ delegate: DiaryDisplayManagerDelegate, _ section: Int, _ state: Bool, _ isEmpty: Bool) {
        self.delegate = delegate
        self.section = section
        
        leftButton.isHidden = false
        rightButton.setTitle("\(LS(key: .ALL)) ", for: .normal)
        titleLabel.text = LS(key: .ACTIVITY)
        if isEmpty {
            arrowImageView.isHidden = true
        } else {
            arrowImageView.isHidden = false
            arrowImageView.image = state ? #imageLiteral(resourceName: "Arrow_top-1") : #imageLiteral(resourceName: "Arrow_down-1")
        }
    }
    
    func fillHeaderByMeasurement() {
        rightButton.isHidden = true

        titleLabel.text = LS(key: .DIARY_MES_9)
        leftButton.isHidden = true
        arrowImageView.isHidden = true
    }
    
    // MARK: - Action -
    @IBAction func headerClicked(_ sender: Any) {
        guard let id = self.section else { return }
        delegate?.headerClicked(section: id)
    }

    @IBAction func showActivityClicked(_ sender: Any) {
        if let vc = UIApplication.getTopMostViewController() {
            vc.performSegue(withIdentifier: "sequeActivityList", sender: nil)
        }
    }
}
