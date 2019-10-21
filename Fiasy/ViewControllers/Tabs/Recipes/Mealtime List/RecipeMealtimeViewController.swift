//
//  RecipeMealtimeViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/6/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS

protocol RecipeMealtimeDelegate {
    func showMealtimeDetails()
}

class RecipeMealtimeViewController: UIViewController {

    //MARK: - Outlet -
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    private var allRecipes = UserInfo.sharedInstance.selectedMealtimeData
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        navigationTitleLabel.text = UserInfo.sharedInstance.selectedMealtimeHeaderTitle
        let text = UserInfo.sharedInstance.getAmplitudeTitle(text: UserInfo.sharedInstance.selectedMealtimeHeaderTitle)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserInfo.sharedInstance.paymentComplete {
            UserInfo.sharedInstance.paymentComplete = false
            if let _ = UserInfo.sharedInstance.selectedRecipes {
                performSegue(withIdentifier: "sequeRecipeMealtime", sender: nil)
            }
        }
//        DispatchQueue.global().async {
//            UserInfo.sharedInstance.purchaseIsValid = SubscriptionService.shared.checkValidPurchases()
//        }
        configurationKeyboardNotification()
        hideKeyboardWhenTappedAround()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    //MARK: - Privates -
    private func setupTableView() {
        tableView.register(type: RecipeMealtimeCell.self)
        tableView.register(RecipesSearchHeaderView.nib, forHeaderFooterViewReuseIdentifier: RecipesSearchHeaderView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
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
    
    //MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension RecipeMealtimeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard allRecipes.count > 1 else {
            return allRecipes.count
        }
        return Int(round(Double(allRecipes.count/2)))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeMealtimeCell") as? RecipeMealtimeCell else { fatalError() }
        cell.fillCell(recipes: allRecipes,
                    delegate: self,
                   indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecipesSearchHeaderView.reuseIdentifier) as? RecipesSearchHeaderView else {
            return UITableViewHeaderFooterView()
        }
        header.fillHeader(delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RecipesSearchHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

extension RecipeMealtimeViewController: RecipeMealtimeDelegate {
    
    func showMealtimeDetails() {
        performSegue(withIdentifier: "sequeRecipeMealtime", sender: nil)
    }
}

extension RecipeMealtimeViewController: RecipesSearchDelegate {
    
    func searchItem(text: String) {
        guard !text.isEmpty else {
            allRecipes = UserInfo.sharedInstance.selectedMealtimeData
            return tableView.reloadData()
        }
        
        var firstItems: [Listrecipe] = []
        for item in UserInfo.sharedInstance.selectedMealtimeData where self.isContains(pattern: text, in: "\(item.name ?? "")") {
            firstItems.append(item)
        }

        allRecipes = firstItems
        tableView.reloadData()
    }
}
