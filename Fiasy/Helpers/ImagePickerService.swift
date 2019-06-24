//
//  ImagePickerService.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/19/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AssetsLibrary

class ImagePickerService: NSObject, UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate {
    
    var targetVC: UIViewController?
    var galleryImagePicker = UIImagePickerController()
    internal var onImageSelected: ((_ image: UIImage) -> Void)?
    
    func showPickAttachment() {
        guard let target = targetVC else { return }
        let refreshAlert = UIAlertController(title: nil,
                                        message: nil,
                                 preferredStyle: .actionSheet)
        
        refreshAlert.addAction(UIAlertAction(title: "Галерея",
                                          style: .default,
                                        handler: { [weak self] _ in
                                                guard let `self` = self else { return }
                                                self.openSingleChoiceInGalleryPicker()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Сделать фото",
                                           style: .default,
                                         handler: { [weak self] _ in
                                                guard let `self` = self else { return }
                                                self.openCameraPicker()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Отменить", style: .cancel))
    
        target.present(refreshAlert, animated: true)
    }
    
    private func openCameraPicker() {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        if UIImagePickerController.isSourceTypeAvailable(.camera) && cameraAuthorizationStatus != .denied {
            guard let target = targetVC else { return }
            galleryImagePicker.delegate = self
            galleryImagePicker.sourceType = UIImagePickerController.SourceType.camera
            galleryImagePicker.allowsEditing = false
            target.present(galleryImagePicker, animated: true)
        } else {
            noCamera()
        }
    }
    
    func noCamera() {
        let alertVC = UIAlertController(
            title: "Доступ к камере запрещен",
            message: "Исправьте это в настройках",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        guard let target = targetVC else { return }
        target.present(alertVC, animated: true)
    }
    
    private func openSingleChoiceInGalleryPicker() {
        guard let target = targetVC else { return }
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            galleryImagePicker.delegate = self
            galleryImagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            galleryImagePicker.allowsEditing = false
            target.present(galleryImagePicker, animated: true)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: { [weak self] () -> Void in
            guard let `self` = self else { return }
            if let chosenImage = info[.originalImage] as? UIImage {
                self.onImageSelected?(chosenImage)
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
