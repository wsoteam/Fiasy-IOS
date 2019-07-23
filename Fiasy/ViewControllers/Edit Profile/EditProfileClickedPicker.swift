//
//  EditProfileClickedPicker.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/14/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class EditProfileClickedPicker: NSObject, UINavigationControllerDelegate {
    
    var targetVC: UIViewController?
    
    internal var imageAction: (() -> Void)?
    internal var photoAction: (() -> Void)?
    
    func showImagePicker() {
        guard let target = targetVC else { return }
        
        let refreshAlert = UIAlertController(title: nil,
                                        message: nil,
                                 preferredStyle: .actionSheet)
        
        let image = UIAlertAction(title: "Галерея",
                                style: .default,
                              handler: { [weak self] _ in
                                    guard let `self` = self else { return }
                                    self.imageAction?()
        })
        image.setValue(#colorLiteral(red: 0.9501459002, green: 0.6092506051, blue: 0.3090541661, alpha: 1), forKey: "titleTextColor")
        
        let photo = UIAlertAction(title: "Сделать фото",
                                style: .default,
                              handler: { [weak self] _ in
                                    guard let `self` = self else { return }
                                    self.photoAction?()
        })
        photo.setValue(#colorLiteral(red: 0.9501459002, green: 0.6092506051, blue: 0.3090541661, alpha: 1), forKey: "titleTextColor")
        
        refreshAlert.addAction(image)
        refreshAlert.addAction(photo)
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        cancel.setValue(#colorLiteral(red: 0.6156174541, green: 0.6157259941, blue: 0.6156106591, alpha: 1), forKey: "titleTextColor")
        refreshAlert.addAction(cancel)
        
        target.present(refreshAlert, animated: true)
    }
}
