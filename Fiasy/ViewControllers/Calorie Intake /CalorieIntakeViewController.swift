//
//  CalorieIntakeViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/27/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import Amplitude_iOS
import Intercom
import FirebaseStorage

protocol CalorieIntakeDelegate {
    func fillField(by tag: Int, text: String)
    func showActivity()
    func showTarget()
    func saveAllFields()
}

class CalorieIntakeViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var finishButton: LoadingButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private var allFields: [String] = ["","",""]
    private var currentUser: User? = UserInfo.sharedInstance.currentUser
    private var target: Int = UserInfo.sharedInstance.currentUser?.target ?? 0
    private var activity: CGFloat = UserInfo.sharedInstance.currentUser?.targetActivity ?? 0.0
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserInfo.sharedInstance.editTarget = target
        UserInfo.sharedInstance.editActivity = activity
        setupTableView()
        finishButton.activityColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
        if let age = currentUser?.age, age != 0 {
            allFields[2] = "\(age)"
        }
        if let weight = currentUser?.weight, weight != 0 {
            allFields[1] = "\(weight)"
        }
        if let height = currentUser?.height, height != 0 {
            allFields[0] = "\(height)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if target != UserInfo.sharedInstance.editTarget || activity != UserInfo.sharedInstance.editActivity {
            finishButton.isEnabled = true
            target = UserInfo.sharedInstance.editTarget
            activity = UserInfo.sharedInstance.editActivity
            tableView.reloadRows(at: [IndexPath(row: 3, section: 0), IndexPath(row: 4, section: 0)], with: .none)
        }
        
        hideKeyboardWhenTappedAround()
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.register(type: CalorieIntakeTableViewCell.self)
        tableView.register(EditProfileFooterView.nib, forHeaderFooterViewReuseIdentifier: EditProfileFooterView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    private func saveFields() {
        if allFields[0].isEmpty {
            showAlert(message: "Введите ваш рост")
        } else if allFields[1].isEmpty {
            showAlert(message: "Введите ваш вес")
        } else if allFields[2].isEmpty {
            showAlert(message: "Введите ваш возраст")
        }
        
        guard let age = Int(allFields[2]), !allFields[2].hasSpecialCharacters(), age <= 200 && age >= 12, age != 0 else {
            return showAlert(message: "Проверьте ваш возраст")
        }
        guard let weight = Double(allFields[1].replacingOccurrences(of: ",", with: ".")), weight <= 200.0 && weight > 30.0 else {
            return showAlert(message: "Проверьте введенный вес")
        }
        guard let growth = Int(allFields[0]), !allFields[0].hasSpecialCharacters(), growth <= 300 && growth >= 100, growth != 0 else {
            return showAlert(message: "Проверьте введенный рост")
        }
        
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("USER_LIST").child(uid).child("profile").child("age").setValue(age)
            ref.child("USER_LIST").child(uid).child("profile").child("height").setValue(growth)
            ref.child("USER_LIST").child(uid).child("profile").child("weight").setValue(weight)
            ref.child("USER_LIST").child(uid).child("profile").child("target").setValue(self.target)
            ref.child("USER_LIST").child(uid).child("profile").child("target_Activity").setValue(self.activity)
            
            let identify = AMPIdentify()
            identify.set("age", value: age as NSObject)
            identify.set("height", value: growth as NSObject)
            identify.set("weight", value: weight as NSObject)
            identify.set("active", value: (Int(self.activity) + 1).fetchUserActive() as NSObject)
            identify.set("goal", value: ((self.target) + 1).fetchUserGoal() as NSObject)
            Amplitude.instance()?.identify(identify)
            
            let userAttributes = [
                "height": growth,
                "weight": weight,
                "age": age,
                "active": Int(self.activity) + 1,
                "goal": (self.target) + 1] as [String : Any]
            
            let attributed = ICMUserAttributes()
            attributed.customAttributes = userAttributes
            Intercom.updateUser(attributed)
            
            UserInfo.sharedInstance.currentUser?.age = age
            UserInfo.sharedInstance.currentUser?.height = growth
            UserInfo.sharedInstance.currentUser?.weight = weight
            UserInfo.sharedInstance.currentUser?.target = self.target
            UserInfo.sharedInstance.currentUser?.targetActivity = self.activity
            
            let female = UserInfo.sharedInstance.currentUser?.female
            let height: Int = growth
            let weight: Double = weight
            
            var BMR: Double = 0.0
            let secondAge = Double(age)
            if UserInfo.sharedInstance.currentUser?.female == true {
                BMR = (10 * weight) + (6.25 * Double(growth)) - (5 * secondAge) - 161
            } else {
                BMR = (10 * weight) + (6.25 * Double(growth)) - (5 * secondAge) + 5
            }
            
            let target: Int = UserInfo.sharedInstance.currentUser?.target ?? 0
            let targetActivity: CGFloat = UserInfo.sharedInstance.currentUser?.targetActivity ?? 0.0
            let activity = (BMR * RegistrationFlow.fetchActivityCoefficient(value: targetActivity))
            let result = RegistrationFlow.fetchResultByAdjustmentCoefficient(target: target, count: activity).displayOnly(count: 0)
            
            var fat: Int = 0
            var protein: Int = 0
            var carbohydrates: Int = 0
            
            if UserInfo.sharedInstance.currentUser?.female == true {
                fat = (Int((result * 0.25).displayOnly(count: 0))/9) + 16
                protein = (Int((result * 0.4).displayOnly(count: 0))/4) - 16
                carbohydrates = (Int((result * 0.35).displayOnly(count: 0))/4) - 16
            } else {
                fat = (Int((result * 0.25).displayOnly(count: 0))/9) + 36
                protein = (Int((result * 0.4).displayOnly(count: 0))/4) - 36
                carbohydrates = (Int((result * 0.35).displayOnly(count: 0))/4) - 36
            }
            
            ref.child("USER_LIST").child(uid).child("profile").child("maxFat").setValue(fat)
            ref.child("USER_LIST").child(uid).child("profile").child("maxProt").setValue(protein)
            ref.child("USER_LIST").child(uid).child("profile").child("maxCarbo").setValue(carbohydrates)
            ref.child("USER_LIST").child(uid).child("profile").child("maxKcal").setValue(result)
            
            UserInfo.sharedInstance.currentUser?.maxKcal = Int(result)
            UserInfo.sharedInstance.currentUser?.maxFat = fat
            UserInfo.sharedInstance.currentUser?.maxProt = protein
            UserInfo.sharedInstance.currentUser?.maxCarbo = carbohydrates
            post("reloadProfile")
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func showAlert(message: String) {
        AlertComponent.sharedInctance.showAlertMessage(message: message, vc: self)
    }
    
    // MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishClicked(_ sender: Any) {
        finishButton.showLoading()
        saveFields()
        delayWithSeconds(1) {
            self.finishButton.hideLoading()
        }
    }
}

extension CalorieIntakeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntakeTableViewCell") as? CalorieIntakeTableViewCell else { fatalError() }
        cell.fillCell(indexCell: indexPath, currentUser: currentUser, delegate: self, target: target, activity: activity)
        return cell
    }
}

extension CalorieIntakeViewController: CalorieIntakeDelegate {
    
    func showActivity() {
        performSegue(withIdentifier: "sequeChangePurpose", sender: nil)
    }
    
    func showTarget() {
        performSegue(withIdentifier: "sequeTargetScreen", sender: nil)
    }
    
    func saveAllFields() {

    }
    
    func fillField(by tag: Int, text: String) {
        if allFields.indices.contains(tag) {
            self.finishButton.isEnabled = true
            allFields[tag] = text
        }
    }
}
