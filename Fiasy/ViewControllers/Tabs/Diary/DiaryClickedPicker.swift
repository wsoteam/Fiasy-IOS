//
//  DiaryClickedPicker.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class DiaryClickedPicker: NSObject, UINavigationControllerDelegate {
    
    var targetVC: UIViewController?
    
    internal var removeMealtime: (() -> Void)?
    
    func showPicker() {
        guard let target = targetVC else { return }
        
        let refreshAlert = UIAlertController(title: nil,
                                        message: nil,
                                 preferredStyle: .actionSheet)
        

        refreshAlert.addAction(UIAlertAction(title: "Удалить",
                                          style: .default,
                                        handler: { [weak self] _ in
                                                guard let `self` = self else { return }
                                                self.removeMealtime?()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        target.present(refreshAlert, animated: true)
    }
}

