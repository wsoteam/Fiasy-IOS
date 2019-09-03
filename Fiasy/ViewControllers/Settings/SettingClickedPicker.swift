//
//  SettingClickedPicker.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Intercom
import Amplitude_iOS

class SettingClickedPicker: NSObject, UINavigationControllerDelegate {
    
    var targetVC: UIViewController?
    
    //private let amplitude = Amplitude()
    
    internal var signOut: (() -> Void)?
    
    func showPicker() {
        guard let target = targetVC else { return }
        
        let refreshAlert = UIAlertController(title: nil,
                                        message: nil,
                                 preferredStyle: .actionSheet)
        
        let signOut = UIAlertAction(title: "Выйти",
                                  style: .default,
                                  handler: { [weak self] _ in
                                    guard let `self` = self else { return }
                                    Intercom.logEvent(withName: "profile_logout") //
                                    Amplitude.instance()?.logEvent("profile_logout") //
                                    self.signOut?()
        })
        signOut.setValue(#colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), forKey: "titleTextColor")

        refreshAlert.addAction(signOut)
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        cancel.setValue(#colorLiteral(red: 0.9231601357, green: 0.3388705254, blue: 0.3422900438, alpha: 1), forKey: "titleTextColor")
        refreshAlert.addAction(cancel)
        
        target.present(refreshAlert, animated: true)
    }
}
