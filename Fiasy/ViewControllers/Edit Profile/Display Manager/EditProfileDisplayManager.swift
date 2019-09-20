//
//  EditProfileDisplayManager.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/14/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import Amplitude_iOS
import FirebaseStorage

protocol EditProfileDelegate {
    func closeModule()
    func showAlert(message: String)
    func showImagePicker()
}

protocol EditProfileDisplayDelegate {
    func saveAllFields()
    func fillField(by tag: Int, text: String)
}

class EditProfileDisplayManager: NSObject {
    
    // MARK: - Properties -
    private let tableView: UITableView
    private let delegate: EditProfileDelegate
    private var currentUser: User
    private var header: EditProfileHeaderView?
    private let finishButton: LoadingButton
    private var temporaryPicture: UIImage?
    private var allFields: [String] = ["","","","","",""]
    
    // MARK: - Interface -
    init(_ tableView: UITableView, _ delegate: EditProfileDelegate, _ currentUser: User, _ finishButton: LoadingButton) {
        self.tableView = tableView
        self.finishButton = finishButton
        self.currentUser = currentUser
        self.delegate = delegate
        super.init()
        
        fillFields(currentUser: currentUser)
        setupTableView()
    }
    
    func applyImage(image: UIImage) {
        if let myHeaderView = self.header {
            temporaryPicture = image
            myHeaderView.fillImage(image: image)
            self.finishButton.isEnabled = true
        }
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(type: EditProfileTableViewCell.self)
        tableView.register(EditProfileHeaderView.nib, forHeaderFooterViewReuseIdentifier: EditProfileHeaderView.reuseIdentifier)
        tableView.register(EditProfileFooterView.nib, forHeaderFooterViewReuseIdentifier: EditProfileFooterView.reuseIdentifier)
        tableView.register(DiaryFooterView.nib, forHeaderFooterViewReuseIdentifier: DiaryFooterView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fillFields(currentUser: User) {
        if let name = currentUser.firstName, !name.isEmpty && name != "default" {
            allFields[0] = name
        }
        if let name = currentUser.lastName, !name.isEmpty && name != "default" {
            allFields[1] = name
        }
        if let email = currentUser.email, !email.isEmpty && email != "default" {
            allFields[2] = email
        }
    }
    
    func saveFields() {
        var firstName: String = ""
        let fullNameArr = allFields[0].split{$0 == " "}.map(String.init)
        for item in fullNameArr where !item.isEmpty {
            firstName = firstName.isEmpty ? item : firstName + " \(item)"
        }
        var lastName: String = ""
        let fullNameLastArr = allFields[1].split{$0 == " "}.map(String.init)
        for item in fullNameLastArr where !item.isEmpty {
            lastName = lastName.isEmpty ? item : lastName + " \(item)"
        }
//        if firstName.isEmpty {
//            delegate.showAlert(message: "Введите вашe имя")
//        }
//
//        guard !allFields[0].hasSpecialCharacters() else {
//            return delegate.showAlert(message: "Проверьте ваше имя")
//        }
//        guard !allFields[1].hasSpecialCharacters() else {
//            return delegate.showAlert(message: "Проверьте вашу фамилию")
//        }
        guard isValidEmail(emailStr: allFields[2]) else {
            return delegate.showAlert(message: "Проверьте вашу почту")
        }

        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("USER_LIST").child(uid).child("profile").child("firstName").setValue(firstName)
            ref.child("USER_LIST").child(uid).child("profile").child("lastName").setValue(lastName)
            ref.child("USER_LIST").child(uid).child("profile").child("email").setValue(allFields[2])

            UserInfo.sharedInstance.currentUser?.firstName = allFields[0]
            UserInfo.sharedInstance.currentUser?.lastName = allFields[1]
            UserInfo.sharedInstance.currentUser?.email = allFields[2]
        }
        guard let image = temporaryPicture else { return delegate.closeModule() }
        currentUser.temporaryPicture = image
        UserInfo.sharedInstance.currentUser?.temporaryPicture = image
        let resizeNewImage = resizeImage(image: image, targetSize: CGSize(width: 300, height: 300))
        uploadMedia(image: resizeNewImage)
        delegate.closeModule()
    }
    
    private func uploadMedia(image: UIImage) {
        let uuid = UUID().uuidString
        let storageRef = Storage.storage().reference().child("AVATARS/").child("\(uuid).png")
        if let uploadData = image.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                } else {
                    let ref = Database.database().reference()
                    if let uid = Auth.auth().currentUser?.uid, let url = metadata?.downloadURL()?.absoluteString {
                        ref.child("USER_LIST").child(uid).child("profile").child("photoUrl").setValue(url)
                    }
                }
            }
        }
    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func isValidEmail(emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
}

extension EditProfileDisplayManager: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileTableViewCell") as? EditProfileTableViewCell else { fatalError() }
        cell.fillCell(indexCell: indexPath, currentUser: currentUser, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: EditProfileHeaderView.reuseIdentifier) as? EditProfileHeaderView else {
            return nil
        }
        self.header = header
        header.fillHeader(delegate: delegate, currentUser: currentUser)
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return EditProfileHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

extension EditProfileDisplayManager: EditProfileDisplayDelegate {
    
    func saveAllFields() {
        saveFields()
    }
    
    func fillField(by tag: Int, text: String) {
        if allFields.indices.contains(tag) {
            self.finishButton.isEnabled = true
            allFields[tag] = text
        }
    }
}
