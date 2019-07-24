//
//  IngredientPickerService.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/19/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class IngredientPickerService: NSObject, UINavigationControllerDelegate {
    
    var targetVC: UIViewController?
    
    internal var remove: (() -> Void)?
    
    func showPicker() {
        guard let target = targetVC else { return }
        
        let refreshAlert = UIAlertController(title: nil,
                                        message: nil,
                                 preferredStyle: .actionSheet)
        
        let remove = UIAlertAction(title: "Удалить", style: .default,
                                   handler: { [weak self] _ in
                                    guard let `self` = self else { return }
                                    self.remove?()
        })
        remove.setValue(#colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), forKey: "titleTextColor")
        refreshAlert.addAction(remove)
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        cancel.setValue(#colorLiteral(red: 0.6156174541, green: 0.6157259941, blue: 0.6156106591, alpha: 1), forKey: "titleTextColor")
        
        refreshAlert.addAction(cancel)
        
        target.present(refreshAlert, animated: true)
    }
}
