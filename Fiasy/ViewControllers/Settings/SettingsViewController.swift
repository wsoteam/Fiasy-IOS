//
//  SettingsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import Intercom
import Amplitude_iOS

class SettingsViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var purchaseIsValid: Bool = false
    lazy var picker: SettingClickedPicker = {
        let picker = SettingClickedPicker()
        picker.targetVC = self
        picker.signOut = { [weak self] in
            guard let `self` = self else { return }
            UserInfo.sharedInstance.removeRegistrationFields()
            Intercom.logout()
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
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(type: SettingCell.self)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        Amplitude.instance().logEvent("view_settings") // +
        Intercom.logEvent(withName: "view_settings") // +
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        purchaseIsValid = UserInfo.sharedInstance.purchaseIsValid
        tableView.reloadData()
        DispatchQueue.global().async {
            UserInfo.sharedInstance.purchaseIsValid = SubscriptionService.shared.checkValidPurchases()
        }
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        if let vc = viewControllerToPresent as? NotificationsAlertViewController {
            vc.completionHandler = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.registerForPushNotifications()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PremiumQuizViewController {
            let vc = segue.destination as? PremiumQuizViewController
            vc?.isAutorization = false
            vc?.trialFrom = "settings"
        }
    }
    
    // MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseIsValid ? 4 : 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as? SettingCell else { fatalError() }
        cell.fillCell(indexPath: indexPath, purchaseIsValid: purchaseIsValid)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if purchaseIsValid {
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "sequeEditProfile", sender: nil)
            case 1:
                performSegue(withIdentifier: "sequeCaloriesIntake", sender: nil)
            case 2:
                performSegue(withIdentifier: "sequeHelpScreen", sender: nil)
            case 3:
                picker.showPicker()
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "sequePremiumScreen", sender: nil)
            case 1:
                performSegue(withIdentifier: "sequeEditProfile", sender: nil)
            case 2:
                performSegue(withIdentifier: "sequeCaloriesIntake", sender: nil)
            case 3:
                performSegue(withIdentifier: "sequeHelpScreen", sender: nil)
            case 4:
                picker.showPicker()
            default:
                break
            }
        }
    }
}
