//
//  DiaryHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Intercom
import Amplitude_iOS

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
    func fillHeader(delegate: DiaryDisplayManagerDelegate, section: Int, state: Bool, _ isEmpty: Bool) {
        self.section = section
        self.delegate = delegate
        
        switch section {
        case 2:
            tagIndex = 0
            titleNameLabel.text = "Завтрак"
        case 3:
            tagIndex = 1
            titleNameLabel.text = "Обед"
        case 4:
            tagIndex = 2
            titleNameLabel.text = "Ужин"
        case 5:
            tagIndex = 3
            titleNameLabel.text = "Перекус"
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
    
    @IBAction func plusClicked(_ sender: Any) {
        
        var name: String = ""
        switch tagIndex {
        case 0:
            name = "breakfast"
        case 1:
            name = "lunch"
        case 2:
            name = "dinner"
        default:
            name = "snack"
        }
        Intercom.logEvent(withName: "diary_next", metaData: ["add_intake" : name]) // +
        Amplitude.instance()?.logEvent("diary_next", withEventProperties: ["add_intake" : name]) // +
        
        UserInfo.sharedInstance.selectedMealtimeIndex = tagIndex
        delegate?.showProductTab()
    }
}
