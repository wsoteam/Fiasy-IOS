//
//  AddProductFourthStepViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import Amplitude_iOS

class AddProductFourthStepViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    private var flow = UserInfo.sharedInstance.productFlow
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        finishButton.setTitle(LS(key: .DONE).uppercased(), for: .normal)
        navigationTitleLabel.text = LS(key: .VERIFICATION_OF_INFORMATION)
        
        var servings: [Serving] = []
        for item in flow.allServingSize where item.selected == true {
            servings.append(item)
        }
        flow.allServingSize = servings
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        showCloseAlert()
    }

    @IBAction func finishClicked(_ sender: Any) {
        if let uid = Auth.auth().currentUser?.uid {
            UserInfo.sharedInstance.reloadFavoriteScreen = true
            flow.calories = flow.calories?.replacingOccurrences(of: ",", with: ".")
            flow.fat = flow.fat?.replacingOccurrences(of: ",", with: ".")
            flow.carbohydrates = flow.carbohydrates?.replacingOccurrences(of: ",", with: ".")
            flow.protein = flow.protein?.replacingOccurrences(of: ",", with: ".")

            var calories: Double = -1
            if let calor = flow.calories, let count = Double(calor), !calor.isEmpty {
                calories = (count).displayOnly(count: 1)
            }
            var fats: Double = -1
            if let fat = flow.fat, let count = Double(fat), !fat.isEmpty {
                fats = (count).displayOnly(count: 1)
            }
            var carbohydrates: Double = -1
            if let carbohydrate = flow.carbohydrates, let count = Double(carbohydrate), !carbohydrate.isEmpty {
                carbohydrates = (count).displayOnly(count: 1)
            }
            var proteins: Double = -1
            if let protein = flow.protein, let count = Double(protein), !protein.isEmpty {
                proteins = (count).displayOnly(count: 1)
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
    
            var listDictionary: [Any] = []
            if !flow.allServingSize.isEmpty {
                for item in flow.allServingSize where item.name != LS(key: .CREATE_STEP_TITLE_16) && item.servingSize != 100 {
                    let dictionary: [String : Any] = ["name": "\(item.name ?? "")", "amount": "\(Int(item.servingSize ?? 0))", "unit" : "\(item.unitMeasurement ?? "0")"]
                    listDictionary.append(dictionary)
                }
            }
            
            let userData = ["brand": productBrend, "barcode": flow.barCode, "name": productName, "calories": calories, "carbohydrates": carbohydrates, "fats": fats, "proteins": proteins, "measurement_units" : listDictionary, "is_Liquid" : flow.productType == .product ? false : true] as [String : Any]
            
            if let key = UserInfo.sharedInstance.productFlow.selectedFavorite?.key {
//                if flow.showAll {
//                    Database.database().reference().child("LIST_CUSTOM_FOOD").child("\(key)").setValue(userData)
//                }
                Database.database().reference().child("USER_LIST").child(uid).child("customFoods").child("\(key)").setValue(userData)
                Database.database().reference().child("USER_LIST").child(uid).child("undeletableCustomFoods").child("\(key)").setValue(userData)
                UserInfo.sharedInstance.productFlow = AddProductFlow()
                popBack(5)
            } else {
//                if flow.showAll {
//                    Database.database().reference().child("LIST_CUSTOM_FOOD").childByAutoId().setValue(userData)
//                }
            Database.database().reference().child("USER_LIST").child(uid).child("customFoods").childByAutoId().setValue(userData)
                Database.database().reference().child("USER_LIST").child(uid).child("undeletableCustomFoods").childByAutoId().setValue(userData)
                UserInfo.sharedInstance.productFlow = AddProductFlow()
                showConfirmAlert()
            }
        }
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 80, right: 0)
        tableView.register(type: AddProductSecondStepCell.self)
        tableView.register(AddProductFourthStepHeaderView.nib, forHeaderFooterViewReuseIdentifier: AddProductFourthStepHeaderView.reuseIdentifier)
    }
    
    private func showCloseAlert() {
        let refreshAlert = UIAlertController(title: LS(key: .CREATE_STEP_TITLE_1), message: "", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: LS(key: .ALERT_YES), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard let strongSelf = self else { return }
            let viewControllers: [UIViewController] = strongSelf.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is MyСreatedProductsViewController {
                    strongSelf.navigationController?.popToViewController(aViewController, animated: true)
                }
            }
        }))
        refreshAlert.addAction(UIAlertAction(title: LS(key: .ALERT_NO), style: .default, handler: nil))
        present(refreshAlert, animated: true)
    }
    
    private func showConfirmAlert() {
        let refreshAlert = UIAlertController(title: LS(key: .CREATE_STEP_TITLE_35), message: "", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: LS(key: .ALERT_YES), style: .default, handler: { [weak self] (action: UIAlertAction!) in
            guard let strongSelf = self else { return }
            
            var productName: String = ""
            let fullNameArr = (strongSelf.flow.name ?? "").split{$0 == " "}.map(String.init)
            for item in fullNameArr where !item.isEmpty {
                productName = productName.isEmpty ? item : productName + " \(item)"
            }
            Amplitude.instance()?.logEvent("custom_product_success", withEventProperties: ["product_id" : productName, "product_from" : strongSelf.flow.productFrom]) // +
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
        return section == 0 ? (3 + flow.allServingSize.count) : 4
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

extension Dictionary where Key == String, Value == Any {
    
    mutating func append(anotherDict:[String:Any]) {
        for (key, value) in anotherDict {
            self.updateValue(value, forKey: key)
        }
    }
}
