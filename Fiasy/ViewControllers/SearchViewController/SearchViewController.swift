//
//  SearchViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import DropDown
import Amplitude_iOS
import Intercom

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets -
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!
    @IBOutlet weak var foodIntakeTypeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    private var dropDown = DropDown()
    private var filteredProducts: [Product] = []
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillDropDown()
        filteredProducts = UserInfo.sharedInstance.allProducts
        tableView.register(type: SearchCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    //MARK: - Private -
    private func fillDropDown() {
        DropDown.appearance().textFont = UIFont.fontRobotoLight(size: 12)
        dropDown.dataSource.append("Завтрак")
        dropDown.dataSource.append("Обед")
        dropDown.dataSource.append("Ужин")
        dropDown.dataSource.append("Перекус")
        for (index,item) in dropDown.dataSource.enumerated() where index == UserInfo.sharedInstance.selectedMealtimeIndex {
            foodIntakeTypeButton.setTitle("\(item)   ", for: .normal)
            UserInfo.sharedInstance.selectedMealtimeTitle = item
        }
        
        dropDown.anchorView = foodIntakeTypeButton
        dropDown.selectionBackgroundColor = .clear
        dropDown.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height ?? 0) + 5)
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.foodIntakeTypeButton.setTitle("\(item)   ", for: .normal)
            UserInfo.sharedInstance.selectedMealtimeTitle = item
        }
    }
    
    private func isContains(pattern: String, in text: String?) -> Bool {
        guard let text = text else { return false }
        let lowcasePattern = pattern.lowercased()
        let lowcaseText = text.lowercased()
        
        let fullNameArr = lowcasePattern.split{$0 == " "}.map(String.init)
        var states: [Bool] = []
        for item in fullNameArr {
            states.append(lowcaseText.contains(item))
        }
        return !states.contains(false)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let _ = touch.view as? UITableViewCell {
            return false
        }
        return true
    }
    
    //MARK: - Action -
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dropDownClicked(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func searchProduct(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            self.filteredProducts = UserInfo.sharedInstance.allProducts
            return self.tableView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return false
        }
        self.filteredProducts = SQLDatabase.shared.filter(text: text)
        Intercom.logEvent(withName: "food_search", metaData: ["results" : self.filteredProducts.count])
        Amplitude.instance()?.logEvent("food_search", withEventProperties: ["results" : self.filteredProducts.count])
        self.tableView.reloadData()
        return true
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell else { fatalError() }
        
        if filteredProducts.indices.contains(indexPath.row) {
            cell.fillCell(info: filteredProducts[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredProducts.indices.contains(indexPath.row) {
            UserInfo.sharedInstance.selectedProduct = filteredProducts[indexPath.row]
            performSegue(withIdentifier: "sequeProductDetails", sender: nil)
        }
    }
}
