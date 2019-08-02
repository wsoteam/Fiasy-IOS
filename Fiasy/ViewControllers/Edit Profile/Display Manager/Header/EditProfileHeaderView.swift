//
//  EditProfileHeaderView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/14/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class EditProfileHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Outlet -
    @IBOutlet weak var avatarImageView: UIImageView!
    
    // MARK: - Properties -
    static var height: CGFloat = 115.0
    private var delegate: EditProfileDelegate?
    
    // MARK: - Interface -
    func fillHeader(delegate: EditProfileDelegate, currentUser: User) {
        self.delegate = delegate
        
        if let image = currentUser.temporaryPicture {
            avatarImageView.image = image
        } else {
            if let path = currentUser.photoUrl, let url = try? path.asURL(), path != "default" {
                let resource = ImageResource(downloadURL: url)
                avatarImageView.kf.setImage(with: resource)
            }
        }
    }
    
    func fillImage(image: UIImage) {
        avatarImageView.image = image
    }
    
    // MARK: - Actions -
    @IBAction func showPickerClicked(_ sender: Any) {
        self.delegate?.showImagePicker()
    }
}
