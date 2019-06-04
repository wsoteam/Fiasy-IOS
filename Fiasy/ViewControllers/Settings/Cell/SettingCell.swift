//
//  SettingCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import MaterialControls

class SettingCell: UITableViewCell {
    
    //MARK: - Outlet -
    @IBOutlet weak var mdSwitch: MDSwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomContainer: UIView!
    
    //MARK: - Interface -
    func fillCell(indexPath: IndexPath) {
        mdSwitch.isOn = UserInfo.sharedInstance.currentUser?.updateOfIndicator ?? false
        bottomContainer.isHidden = true
        switch indexPath.row {
        case 0:
            titleLabel.text = "Политика конфидециальности"
//        case 1:
//            titleLabel.text = "Оцените нас"
//        case 2:
//            titleLabel.text = "Поделиться с друзьями"
//        case 3:
//            titleLabel.text = "Настроить оповещения"
        case 1:
            titleLabel.text = "Обновление основных показателей"
            bottomContainer.isHidden = false
        case 2:
            titleLabel.text = "Выйти"
        default:
            break
        }
    }
    
    @IBAction func switchClicked(_ sender: Any) {
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            UserInfo.sharedInstance.currentUser?.updateOfIndicator = mdSwitch.isOn
            ref.child("USER_LIST").child(uid).child("profile").child("updateOfIndicator").setValue(mdSwitch.isOn)
        }
    }
}
