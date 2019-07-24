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
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private var flow = UserInfo.sharedInstance.productFlow
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        if let _ = UserInfo.sharedInstance.productFlow.selectedFavorite {
           finishButton.setImage(#imageLiteral(resourceName: "Group (16)"), for: .normal)
        } else {
            finishButton.setImage(#imageLiteral(resourceName: "Group (10)"), for: .normal)
        }
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated:
            true)
    }

    @IBAction func finishClicked(_ sender: Any) {
        if let uid = Auth.auth().currentUser?.uid {
            UserInfo.sharedInstance.reloadFavoriteScreen = true
            flow.calories = flow.calories?.replacingOccurrences(of: ",", with: ".")
            flow.fat = flow.fat?.replacingOccurrences(of: ",", with: ".")
            flow.carbohydrates = flow.carbohydrates?.replacingOccurrences(of: ",", with: ".")
            flow.protein = flow.protein?.replacingOccurrences(of: ",", with: ".")
            flow.cellulose = flow.cellulose?.replacingOccurrences(of: ",", with: ".")
            flow.sugar = flow.sugar?.replacingOccurrences(of: ",", with: ".")
            flow.saturatedFats = flow.saturatedFats?.replacingOccurrences(of: ",", with: ".")
            flow.monounsaturatedFats = flow.monounsaturatedFats?.replacingOccurrences(of: ",", with: ".")
            flow.polyunsaturatedFats = flow.polyunsaturatedFats?.replacingOccurrences(of: ",", with: ".")
            flow.cholesterol = flow.cholesterol?.replacingOccurrences(of: ",", with: ".")
            flow.sodium = flow.sodium?.replacingOccurrences(of: ",", with: ".")
            flow.potassium = flow.potassium?.replacingOccurrences(of: ",", with: ".")
            
            var calories: Double = -1
            if let calor = flow.calories, let count = Double(calor), !calor.isEmpty {
                calories = (count/100).displayOnly(count: 3)
            }
            var fats: Double = -1
            if let fat = flow.fat, let count = Double(fat), !fat.isEmpty {
                fats = (count/100).displayOnly(count: 3)
            }
            var carbohydrates: Double = -1
            if let carbohydrate = flow.carbohydrates, let count = Double(carbohydrate), !carbohydrate.isEmpty {
                carbohydrates = (count/100).displayOnly(count: 3)
            }
            var proteins: Double = -1
            if let protein = flow.protein, let count = Double(protein), !protein.isEmpty {
                proteins = (count/100).displayOnly(count: 3)
            }
            var celluloses: Double = -1
            if let cellulose = flow.cellulose, let count = Double(cellulose), !cellulose.isEmpty {
                celluloses = (count/100).displayOnly(count: 3)
            }
            var sugars: Double = -1
            if let sugar = flow.sugar, let count = Double(sugar), !sugar.isEmpty {
                sugars = (count/100).displayOnly(count: 3)
            }
            var saturatedFats: Double = -1
            if let saturatedFat = flow.saturatedFats, let count = Double(saturatedFat), !saturatedFat.isEmpty {
                saturatedFats = (count/100).displayOnly(count: 3)
            }
            var monounsaturatedFats: Double = -1
            if let monounsaturatedFat = flow.monounsaturatedFats, let count = Double(monounsaturatedFat), !monounsaturatedFat.isEmpty {
                monounsaturatedFats = (count/100).displayOnly(count: 3)
            }
            var polyunsaturatedFats: Double = -1
            if let polyunsaturatedFat = flow.polyunsaturatedFats, let count = Double(polyunsaturatedFat), !polyunsaturatedFat.isEmpty {
                polyunsaturatedFats = (count/100).displayOnly(count: 3)
            }
            var cholesterols: Double = -1
            if let cholesterol = flow.cholesterol, let count = Double(cholesterol), !cholesterol.isEmpty {
                cholesterols = (count/100).displayOnly(count: 3)
            }
            var sodiums: Double = -1
            if let sodium = flow.sodium, let count = Double(sodium), !sodium.isEmpty {
                sodiums = (count/100).displayOnly(count: 3)
            }
            var potassiums: Double = -1
            if let potassium = flow.potassium, let count = Double(potassium), !potassium.isEmpty {
                potassiums = (count/100).displayOnly(count: 3)
            }
            
            var productName: String = ""
            let fullNameArr = (flow.name ?? "").split{$0 == " "}.map(String.init)
            for item in fullNameArr where !item.isEmpty {
                productName = productName.isEmpty ? item : productName + " \(item)"
            }
            
            var productBrend: String = ""
            let fullNameArr2 = (flow.brend ?? "").split{$0 == " "}.map(String.init)
            for item in fullNameArr2 where !item.isEmpty {
                productBrend = productBrend.isEmpty ? item : productBrend + " \(item)"
            }
            
            let userData = ["brand": productBrend, "barcode": flow.barCode, "name": productName, "calories": calories, "carbohydrates": carbohydrates, "cellulose": celluloses, "cholesterol": cholesterols, "fats": fats, "monoUnSaturatedFats": monounsaturatedFats, "polyUnSaturatedFats" : polyunsaturatedFats, "pottassium": potassiums, "proteins": proteins, "saturatedFats": saturatedFats, "sodium": sodiums, "sugar": sugars] as [String : Any]
            if let key = UserInfo.sharedInstance.productFlow.selectedFavorite?.key {
                if flow.showAll {
                    Database.database().reference().child("LIST_CUSTOM_FOOD").child("\(key)").setValue(userData)
                }
                Database.database().reference().child("USER_LIST").child(uid).child("customFoods").child("\(key)").setValue(userData)
                Database.database().reference().child("USER_LIST").child(uid).child("undeletableCustomFoods").child("\(key)").setValue(userData)
                popBack(5)
            } else {
                if flow.showAll {
                    Database.database().reference().child("LIST_CUSTOM_FOOD").childByAutoId().setValue(userData)
                }
            Database.database().reference().child("USER_LIST").child(uid).child("customFoods").childByAutoId().setValue(userData)
                Database.database().reference().child("USER_LIST").child(uid).child("undeletableCustomFoods").childByAutoId().setValue(userData)
                showConfirmAlert()
            }
        }
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 30, right: 0)
        tableView.register(type: AddProductSecondStepCell.self)
        tableView.register(AddProductFourthStepHeaderView.nib, forHeaderFooterViewReuseIdentifier: AddProductFourthStepHeaderView.reuseIdentifier)
    }
    
    private func showConfirmAlert() {
        let refreshAlert = UIAlertController(title: "Ваш продукт добавлен в Избранное", message: "", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard let strongSelf = self else { return }
            strongSelf.popBack(5)
        }))
        present(refreshAlert, animated: true)
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
