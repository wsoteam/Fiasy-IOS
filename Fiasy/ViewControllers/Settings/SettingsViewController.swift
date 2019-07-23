//
//  SettingsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import Amplitude_iOS

class SettingsViewController: UIViewController {
    
    //MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    lazy var picker: SettingClickedPicker = {
        let picker = SettingClickedPicker()
        picker.targetVC = self
        picker.signOut = { [weak self] in
            guard let `self` = self else { return }
            UserInfo.sharedInstance.removeRegistrationFields()
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error while signing out!")
            }
            self.post(Constant.LOG_OUT)
        }
        return picker
    }()
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(type: SettingCell.self)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        Amplitude.instance().logEvent("view_settings")
    }
    
    //MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as? SettingCell else { fatalError() }
        cell.fillCell(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "sequePremiumScreen", sender: nil)
        case 2:
            performSegue(withIdentifier: "sequeEditProfile", sender: nil)
        case 3:
            performSegue(withIdentifier: "sequeNotificationsScreen", sender: nil)
        case 6:
            picker.showPicker()
        default:
            break
        }
    }
}
