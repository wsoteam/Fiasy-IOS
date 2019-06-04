//
//  RecipesViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS

protocol RecipesDelegate {
    func showMoreClicked(title: String)
}

class RecipesViewController: UIViewController {
    
    //MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    private let allRecipes: [Listrecipe] = UserInfo.sharedInstance.allRecipes
    private var breakfasts: [Listrecipe] = []
    private var lunches: [Listrecipe] = []
    private var dinners: [Listrecipe] = []
    private var snacks: [Listrecipe] = []
    
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecipes()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserInfo.sharedInstance.paymentComplete {
            UserInfo.sharedInstance.paymentComplete = false
            if let _ = UserInfo.sharedInstance.selectedRecipes {
                performSegue(withIdentifier: "sequeRecipeMealtime", sender: nil)
            }
        }
        DispatchQueue.global().async {
            UserInfo.sharedInstance.purchaseIsValid = SubscriptionService.shared.checkValidPurchases()
        }
        Amplitude.instance().logEvent("view_all_recipes")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    //MARK: - Privates -
    private func setupTableView() {
        tableView.register(RecipesHeaderView.nib, forHeaderFooterViewReuseIdentifier: RecipesHeaderView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchRecipes() {
        for item in allRecipes {
            if let arrays = item.eating {
                for secondItem in arrays {
                    switch secondItem {
                    case .breakfast:
                        breakfasts.append(item)
                    case .lunch:
                        lunches.append(item)
                    case .dinner:
                        dinners.append(item)
                    case .snack:
                        snacks.append(item)
                    }
                }
            }
        }
    }
}

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesRow") as? RecipesRow else { fatalError() }
        
        switch indexPath.section {
            case 0:
                if breakfasts.indices.contains(indexPath.row) {
                    cell.fillRow(by: breakfasts)
                }
            case 1:
                if lunches.indices.contains(indexPath.row) {
                    cell.fillRow(by: lunches)
                }
            case 2:
                if dinners.indices.contains(indexPath.row) {
                    cell.fillRow(by: dinners.reversed())
                }
            case 3:
                if snacks.indices.contains(indexPath.row) {
                    cell.fillRow(by: snacks)
                }
            default:
                break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecipesHeaderView.reuseIdentifier) as? RecipesHeaderView else {
            return UITableViewHeaderFooterView()
        }
        header.fillHeader(by: section, delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RecipesHeaderView.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RecipesRow.rowHeight
    }
}

extension RecipesViewController: RecipesDelegate {
    
    func showMoreClicked(title: String) {
        UserInfo.sharedInstance.selectedMealtimeHeaderTitle = title
        switch title {
        case "Завтрак":
            UserInfo.sharedInstance.selectedMealtimeData = breakfasts
        case "Обед":
            UserInfo.sharedInstance.selectedMealtimeData = lunches
        case "Ужин":
            UserInfo.sharedInstance.selectedMealtimeData = dinners
        case "Перекус":
            UserInfo.sharedInstance.selectedMealtimeData = snacks
        default:
            break
        }
        performSegue(withIdentifier: "sequeRecipeMealtime", sender: nil)
    }
}
