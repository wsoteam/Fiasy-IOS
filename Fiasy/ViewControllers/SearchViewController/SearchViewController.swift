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

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets -
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!
    @IBOutlet weak var foodIntakeTypeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    private var dropDown = DropDown()
    private let backgroundQueue = DispatchQueue(label: "com.app.queue", qos: .background)
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
        
        let fullNameArr = lowcasePattern.characters.split{$0 == " "}.map(String.init)
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
        var firstItems: [Product] = []
        for item in UserInfo.sharedInstance.allProducts where self.isContains(pattern: text, in: "\(item.name ?? "") (\(item.brend ?? ""))") {
            firstItems.append(item)
            
            if firstItems.count == 20 {
                if self.searchTextField.text == text {
                    self.filteredProducts = firstItems
                    self.tableView.reloadData()
                }
                break
            }
        }
        
        var items: [Product] = []
        DispatchQueue.global(qos: .background).async {
            for item in UserInfo.sharedInstance.allProducts where self.isContains(pattern: text, in: "\(item.name ?? "") (\(item.brend ?? ""))") {
                items.append(item)
            }
            
            DispatchQueue.main.async {
                Amplitude.instance().logEvent("view_search_food")
                if text == self.searchTextField.text {
                    self.filteredProducts = items
                    Amplitude.instance().logEvent("view_search_food")
                    self.tableView.reloadData()
                }
            }
        }
        
        
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
