//
//  EditProfileDisplayManager.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/14/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
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
    private var temporaryPicture: UIImage?
    private var allFields: [String] = ["","","","","",""]
    
    // MARK: - Interface -
    init(_ tableView: UITableView, _ delegate: EditProfileDelegate, _ currentUser: User) {
        self.tableView = tableView
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
        }
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(type: EditProfileTableViewCell.self)
        tableView.register(EditProfileHeaderView.nib, forHeaderFooterViewReuseIdentifier: EditProfileHeaderView.reuseIdentifier)
        tableView.register(EditProfileFooterView.nib, forHeaderFooterViewReuseIdentifier: EditProfileFooterView.reuseIdentifier)
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
        if let age = currentUser.age, age != 0 {
            allFields[3] = "\(age)"
        }
        if let weight = currentUser.weight, weight != 0 {
            allFields[4] = "\(weight)"
        }
        if let height = currentUser.height, height != 0 {
            allFields[5] = "\(height)"
        }
    }
    
    private func saveFields() {
        if allFields[0].isEmpty {
            delegate.showAlert(message: "Введите вашe имя")
        } else if allFields[1].isEmpty {
            delegate.showAlert(message: "Введите вашу фамилию")
        } else if allFields[2].isEmpty {
            delegate.showAlert(message: "Введите вашу почту")
        } else if allFields[3].isEmpty {
            delegate.showAlert(message: "Введите ваш возраст")
        } else if allFields[4].isEmpty {
            delegate.showAlert(message: "Введите ваш вес")
        } else if allFields[5].isEmpty {
            delegate.showAlert(message: "Введите ваш рост")
        }
        guard !allFields[0].hasSpecialCharacters() else {
            return delegate.showAlert(message: "Проверьте ваше имя")
        }
        guard !allFields[1].hasSpecialCharacters() else {
            return delegate.showAlert(message: "Проверьте вашу фамилию")
        }
        guard isValidEmail(emailStr: allFields[2]) else {
            return delegate.showAlert(message: "Проверьте вашу почту")
        }
        guard let age = Int(allFields[3]), !allFields[3].hasSpecialCharacters(), age <= 200 && age >= 12, age != 0 else {
            return delegate.showAlert(message: "Проверьте ваш возраст")
        }
        guard let weight = Int(allFields[4]), !allFields[4].hasSpecialCharacters(), weight <= 500, weight != 0 else {
            return delegate.showAlert(message: "Проверьте введенный вес")
        }
        guard let growth = Int(allFields[5]), !allFields[5].hasSpecialCharacters(), growth <= 300 && growth >= 100, growth != 0 else {
            return delegate.showAlert(message: "Проверьте введенный рост")
        }
        
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("USER_LIST").child(uid).child("profile").child("firstName").setValue(allFields[0])
            ref.child("USER_LIST").child(uid).child("profile").child("lastName").setValue(allFields[1])
            ref.child("USER_LIST").child(uid).child("profile").child("email").setValue(allFields[2])
            ref.child("USER_LIST").child(uid).child("profile").child("age").setValue(age)
            ref.child("USER_LIST").child(uid).child("profile").child("height").setValue(growth)
            ref.child("USER_LIST").child(uid).child("profile").child("weight").setValue(weight)
            
            UserInfo.sharedInstance.currentUser?.age = age
            UserInfo.sharedInstance.currentUser?.firstName = allFields[0]
            UserInfo.sharedInstance.currentUser?.lastName = allFields[1]
            UserInfo.sharedInstance.currentUser?.email = allFields[2]
            UserInfo.sharedInstance.currentUser?.height = growth
            UserInfo.sharedInstance.currentUser?.weight = weight
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
        return 6
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: EditProfileFooterView.reuseIdentifier) as? EditProfileFooterView else {
            return nil
        }
        footer.fillFooter(delegate: self)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return EditProfileHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return EditProfileFooterView.height
    }
}

extension EditProfileDisplayManager: EditProfileDisplayDelegate {
    
    func saveAllFields() {
        saveFields()
    }
    
    func fillField(by tag: Int, text: String) {
        if allFields.indices.contains(tag) {
            allFields[tag] = text
        }
    }
}
