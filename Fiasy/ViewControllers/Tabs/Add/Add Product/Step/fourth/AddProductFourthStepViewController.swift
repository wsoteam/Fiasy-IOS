//
//  AddProductFourthStepViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase

class AddProductFourthStepViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private var flow = UserInfo.sharedInstance.productFlow
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated:
            true)
    }

    @IBAction func finishClicked(_ sender: Any) {
        if let uid = Auth.auth().currentUser?.uid {
            var calories: Double = -1
            if let calor = flow.calories, let count = Double(calor) {
                calories = count/100
            }
            var fats: Double = -1
            if let fat = flow.fat, let count = Double(fat) {
                fats = count/100
            }
            var carbohydrates: Double = -1
            if let carbohydrate = flow.carbohydrates, let count = Double(carbohydrate) {
                carbohydrates = count/100
            }
            var proteins: Double = -1
            if let protein = flow.protein, let count = Double(protein) {
                proteins = count/100
            }
            var celluloses: Double = -1
            if let cellulose = flow.cellulose, let count = Double(cellulose) {
                celluloses = count/100
            }
            var sugars: Double = -1
            if let sugar = flow.sugar, let count = Double(sugar) {
                sugars = count/100
            }
            var saturatedFats: Double = -1
            if let saturatedFat = flow.saturatedFats, let count = Double(saturatedFat) {
                saturatedFats = count/100
            }
            var monounsaturatedFats: Double = -1
            if let monounsaturatedFat = flow.monounsaturatedFats, let count = Double(monounsaturatedFat) {
                monounsaturatedFats = count/100
            }
            var polyunsaturatedFats: Double = -1
            if let polyunsaturatedFat = flow.polyunsaturatedFats, let count = Double(polyunsaturatedFat) {
                polyunsaturatedFats = count/100
            }
            var cholesterols: Double = -1
            if let cholesterol = flow.cholesterol, let count = Double(cholesterol) {
                cholesterols = count/100
            }
            var sodiums: Double = -1
            if let sodium = flow.sodium, let count = Double(sodium) {
                sodiums = count/100
            }
            var potassiums: Double = -1
            if let potassium = flow.potassium, let count = Double(potassium) {
                potassiums = count/100
            }
            let userData = ["brand": flow.brend, "barcode": flow.barCode, "name": flow.name, "calories": calories, "carbohydrates": carbohydrates, "cellulose": celluloses, "cholesterol": cholesterols, "fats": fats, "monoUnSaturatedFats": monounsaturatedFats, "polyUnSaturatedFats" : polyunsaturatedFats, "pottassium": potassiums, "proteins": proteins, "saturatedFats": saturatedFats, "sodium": sodiums, "sugar": sugars] as [String : Any]
            if flow.showAll {
                Database.database().reference().child("LIST_CUSTOM_FOOD").childByAutoId().setValue(userData)
            }
            Database.database().reference().child("USER_LIST").child(uid).child("customFoods").childByAutoId().setValue(userData)
            UserInfo.sharedInstance.reloadFavoriteScreen = true
            popBack(5)
        }
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 30, right: 0)
        tableView.register(type: AddProductSecondStepCell.self)
        tableView.register(AddProductFourthStepHeaderView.nib, forHeaderFooterViewReuseIdentifier: AddProductFourthStepHeaderView.reuseIdentifier)
    }
}

extension AddProductFourthStepViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddProductSecondStepCell") as? AddProductSecondStepCell else { fatalError() }
        cell.fillCellByLastStep(indexPath: indexPath, flow)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AddProductFourthStepHeaderView.reuseIdentifier) as? AddProductFourthStepHeaderView else {
            return nil
        }
        header.fillHeader(section: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AddProductFourthStepHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0000001
    }
}
