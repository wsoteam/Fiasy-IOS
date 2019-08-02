//
//  UIImagePickerControllerImpl.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/14/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

enum UIImagePickerControllerStyleImpl {
    case TakePhoto
    case SelectPhoto
}

class UIImagePickerControllerImpl: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var controller: UIViewController!
    
    var complete: ((_ image: UIImage?)->())?
    
    init(style: UIImagePickerControllerStyleImpl, allowsEditing: Bool = false) {
        
        super.init()
        
        let controller = UIImagePickerController()
        controller.allowsEditing = allowsEditing
        controller.sourceType = sourceType(style: style)
        controller.delegate = self
        
        self.controller = controller
    }
    
    private func sourceType(style: UIImagePickerControllerStyleImpl) -> UIImagePickerController.SourceType {
        switch style {
        case .TakePhoto:
            return .camera
        case .SelectPhoto:
            return .photoLibrary
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage]! as! UIImage
        picker.dismiss(animated: true) { [weak self] () in
            self?.complete?(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        complete?(nil)
    }
}
