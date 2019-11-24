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
import FirebaseStorage

protocol CalorieIntakeDelegate {
    func reloadTable(allText: [String])
    func fillField(by tag: Int, text: String)
    func showActivity()
    func showTarget()
    func saveAllFields()
}

class CalorieIntakeViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var finishButton: LoadingButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private var defaultFat: Int = 0
    private var defaultCalories: Int = 0
    private var defaultProtein: Int = 0
    private var defaultCarbohydrates: Int = 0
    private var allPremiumFields: [String] = []
    
    private var purchaseIsValid: Bool = UserInfo.sharedInstance.purchaseIsValid
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
        fetchUserLimit()
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
        navigationTitleLabel.text = LS(key: .CALORIE_INTAKE)
        finishButton.setTitle(LS(key: .DONE), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if target != UserInfo.sharedInstance.editTarget || activity != UserInfo.sharedInstance.editActivity {
            finishButton.isEnabled = true
            target = UserInfo.sharedInstance.editTarget
            activity = UserInfo.sharedInstance.editActivity
            tableView.reloadData()
        }
        
        purchaseIsValid = UserInfo.sharedInstance.purchaseIsValid
        tableView.reloadData()
        
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
        tableView.register(type: CalorieIntakePremiumCell.self)
        tableView.register(CalorieIntakeHeaderView.nib, forHeaderFooterViewReuseIdentifier: CalorieIntakeHeaderView.reuseIdentifier)
        tableView.register(DiaryFooterView.nib, forHeaderFooterViewReuseIdentifier: DiaryFooterView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchUserLimit() {
        guard let user = self.currentUser else { return }
        
        let growth: Int = user.height ?? 0
        let weight: Double = user.weight ?? 0
        
        var BMR: Double = 0.0
        let secondAge = Double(user.age ?? 0)
        if user.female == true {
            BMR = (10 * weight) + (6.25 * Double(growth)) - (5 * secondAge) - 161
        } else {
            BMR = (10 * weight) + (6.25 * Double(growth)) - (5 * secondAge) + 5
        }
        let target: Int = UserInfo.sharedInstance.currentUser?.target ?? 0
        let targetActivity: CGFloat = UserInfo.sharedInstance.currentUser?.targetActivity ?? 0.0
        let activity = (BMR * RegistrationFlow.fetchActivityCoefficient(value: targetActivity))
        let result = RegistrationFlow.fetchResultByAdjustmentCoefficient(target: target, count: activity).displayOnly(count: 0)
        
        defaultCalories = Int(result)
        if UserInfo.sharedInstance.currentUser?.female == true {
            defaultFat = (Int((result * 0.25).displayOnly(count: 0))/9) + 16
            defaultProtein = (Int((result * 0.4).displayOnly(count: 0))/4) - 16
            defaultCarbohydrates = (Int((result * 0.35).displayOnly(count: 0))/4) - 16
        } else {
            defaultFat = (Int((result * 0.25).displayOnly(count: 0))/9) + 36
            defaultProtein = (Int((result * 0.4).displayOnly(count: 0))/4) - 36
            defaultCarbohydrates = (Int((result * 0.35).displayOnly(count: 0))/4) - 36
        }
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
        var fillCustom: Bool = false
        if !allPremiumFields.isEmpty && allPremiumFields.count == 4 {
            guard let customCalories = Int("\(allPremiumFields[0])") else {
                return showAlert(message: "Проверьте введенные калории")
            }
            guard let customProtein = Int("\(allPremiumFields[1])") else {
                return showAlert(message: "Белки не могут быть пустыми или состоять из нулей")
            }
            guard let customCarbohydrates = Int("\(allPremiumFields[2])") else {
                return showAlert(message: "Углеводы не могут быть пустыми или состоять из нулей")
            }
            guard let customFat = Int("\(allPremiumFields[3])") else {
                return showAlert(message: "Жиры не могут быть пустыми или состоять из нулей")
            }
            if let uid = Auth.auth().currentUser?.uid {
                fillCustom = true
                let child = ref.child("USER_LIST").child(uid).child("profile")
                
                child.child("maxFat").setValue(customFat)
                child.child("maxProt").setValue(customProtein)
                child.child("maxCarbo").setValue(customCarbohydrates)
                child.child("maxKcal").setValue(customCalories)
            }

            UserInfo.sharedInstance.currentUser?.maxFat = customFat
            UserInfo.sharedInstance.currentUser?.maxProt = customProtein
            UserInfo.sharedInstance.currentUser?.maxKcal = customCalories
            UserInfo.sharedInstance.currentUser?.maxCarbo = customCarbohydrates
        }
        
        if let uid = Auth.auth().currentUser?.uid {
            let child = ref.child("USER_LIST").child(uid).child("profile")
            child.child("age").setValue(age)
            child.child("height").setValue(growth)
            child.child("weight").setValue(weight)
            child.child("target").setValue(self.target)
            child.child("target_Activity").setValue(self.activity)
            
            if UserInfo.sharedInstance.currentUser?.weight != weight {
                var findMeasurings: Measuring?
                for secondItem in UserInfo.sharedInstance.measuringList where (Calendar.current.component(.day, from: secondItem.date ?? Date()) == Calendar.current.component(.day, from: Date()) && Calendar.current.component(.month, from: secondItem.date ?? Date()) == Calendar.current.component(.month, from: Date()) && Calendar.current.component(.year, from: secondItem.date ?? Date()) == Calendar.current.component(.year, from: Date())) {
                    findMeasurings = secondItem
                    break
                }
                if let find = findMeasurings, let key = find.generalKey {
                    Database.database().reference().child("USER_LIST").child(uid).child("weights").child(key).child("weight").setValue(weight)
                } else {
                    let milisecond = Int64((Date().timeIntervalSince1970 * 1000.0).rounded())
                    let userData = ["key": "", "timeInMillis": milisecond, "weight": weight] as [String : Any]
                    Database.database().reference().child("USER_LIST").child(uid).child("weights").child("\(milisecond)").setValue(userData)
                }
            }

            let identify = AMPIdentify()
            identify.set("age", value: age as NSObject)
            identify.set("height", value: growth as NSObject)
            identify.set("weight", value: weight as NSObject)
            identify.set("active", value: (Int(self.activity) + 1).fetchUserActive() as NSObject)
            identify.set("goal", value: ((self.target) + 1).fetchUserGoal() as NSObject)
            
            if !allPremiumFields.isEmpty && allPremiumFields.count == 4 {
                identify.set("calorie", value: "\(allPremiumFields[0])" as NSObject)
                identify.set("proteins", value: "\(allPremiumFields[1])" as NSObject)
                identify.set("fats", value: "\(allPremiumFields[3])" as NSObject)
                identify.set("сarbohydrates", value: "\(allPremiumFields[2])" as NSObject)
            }
            Amplitude.instance()?.identify(identify)
            
            UserInfo.sharedInstance.currentUser?.age = age
            UserInfo.sharedInstance.currentUser?.height = growth
            UserInfo.sharedInstance.currentUser?.weight = weight
            UserInfo.sharedInstance.currentUser?.target = self.target
            UserInfo.sharedInstance.currentUser?.targetActivity = self.activity
            
            if defaultFat == Int(currentUser?.maxFat ?? 0) && defaultCalories == Int(currentUser?.maxKcal ?? 0) && defaultProtein == Int(currentUser?.maxProt ?? 0) && defaultCarbohydrates == Int(currentUser?.maxCarbo ?? 0) {
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
            }
        }
        post("reloadProfile")
        UserInfo.sharedInstance.reloadDiariContent = true
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        AlertComponent.sharedInctance.showAlertMessage(message: message, vc: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PremiumQuizViewController {
            let vc = segue.destination as? PremiumQuizViewController
            vc?.isAutorization = false
            vc?.trialFrom = "custom_calorie"
        }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 6 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntakeTableViewCell") as? CalorieIntakeTableViewCell else { fatalError() }
            cell.fillCell(indexCell: indexPath, currentUser: currentUser, delegate: self, target: target, activity: activity, allFields)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntakePremiumCell") as? CalorieIntakePremiumCell else { fatalError() }
            cell.fillCell(indexPath, currentUser, self, self.purchaseIsValid, [defaultCalories, defaultProtein, defaultCarbohydrates, defaultFat], allPremiumFields)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0.00001 : DiaryFooterView.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if purchaseIsValid {
            return section == 1 ? 100.0 : 0.00001
        } else {
            return section == 0 ? 0.00001 : CalorieIntakeHeaderView.getHeaderHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 { return nil }
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: DiaryFooterView.reuseIdentifier) as? DiaryFooterView else {
            return nil
        }
        return footer
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CalorieIntakeHeaderView.reuseIdentifier) as? CalorieIntakeHeaderView else {
            return nil
        }
        header.fillHeader(self.purchaseIsValid)
        return header
    }
}

extension CalorieIntakeViewController: CalorieIntakeDelegate {
    
    func reloadTable(allText: [String]) {
        allPremiumFields = allText
        finishButton.isEnabled = true
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
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
