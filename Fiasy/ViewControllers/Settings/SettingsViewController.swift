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
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as? SettingCell else { fatalError() }
        cell.fillCell(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let url = URL(string: "http://fiasy.com/PrivacyPolice.html") {
                UIApplication.shared.open(url, options: [:])
            }
        } else if indexPath.row == 2 {
            UserInfo.sharedInstance.removeRegistrationFields()
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error while signing out!")
            }
            post(Constant.LOG_OUT)
        }
    }
}
