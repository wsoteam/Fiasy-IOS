//
//  EditProfileViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/20/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import AVFoundation
import Amplitude_iOS

class EditProfileViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private var imagePickerController: UIImagePickerControllerImpl?
    private var displayManager: EditProfileDisplayManager?
    lazy var picker: EditProfileClickedPicker = {
        let picker = EditProfileClickedPicker()
        picker.targetVC = self
        picker.photoAction = { [weak self] in
            guard let `self` = self else { return }
            self.selectTakePhoto()
        }
        picker.imageAction = { [weak self] in
            guard let `self` = self else { return }
            self.selectTakeImage()
        }
        return picker
    }()
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
        Amplitude.instance().logEvent("edit_profile")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupInitialState()
        hideKeyboardWhenTappedAround()
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }

    //MARK: - Private -
    private func setupInitialState() {
        guard let user = UserInfo.sharedInstance.currentUser else { return }
        displayManager = EditProfileDisplayManager(tableView, self, user)
    }

    //MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension EditProfileViewController: EditProfileDelegate {
    
    func closeModule() {
        post("reloadProfile")
        UserInfo.sharedInstance.reloadDiariContent = true
        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(message: String) {
        AlertComponent.sharedInctance.showAlertMessage(message: message, vc: self)
    }
    
    func showImagePicker() {
        picker.showImagePicker()
    }
}

extension EditProfileViewController {
    
    private func selectTakePhoto() {
        if mayOpenCamera() {
            showTakeImage(complete: { [weak self] (image) in
                guard let `self` = self else { return }
                if let image = image {
                    self.displayManager?.applyImage(image: image)
                }
            }, style: .TakePhoto)
        } else {
//            self.router?.showNoEnableAccessCamera(delegate: self)
        }
    }

    private func selectTakeImage() {
        if mayOpenCamera() {
            showTakeImage(complete: { [weak self] (image) in
                guard let `self` = self else { return }
                if let image = image {
                    self.displayManager?.applyImage(image: image)
                }
            }, style: .SelectPhoto)
        } else {
            //            self.router?.showNoEnableAccessCamera(delegate: self)
        }
    }
    
    private func mayOpenCamera() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        return status ==  .authorized || status == .notDetermined
    }
    
    private func showTakeImage(complete: @escaping ((UIImage?) -> ()), style: UIImagePickerControllerStyleImpl) {
        imagePickerController = UIImagePickerControllerImpl(style: style, allowsEditing: true)
        imagePickerController?.complete = { [weak self] (image) in
            self?.imagePickerController = nil
            complete(image)
        }
        if let controller = imagePickerController?.controller {
            present(controller, animated: true)
        }
    }
}
