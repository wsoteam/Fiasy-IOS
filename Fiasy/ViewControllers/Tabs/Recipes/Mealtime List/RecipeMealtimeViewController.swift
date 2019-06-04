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
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        Amplitude.instance().logEvent("view_group_recipes")
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
    }
    
    //MARK: - Privates -
    private func setupTableView() {
        tableView.register(type: RecipeMealtimeCell.self)
        tableView.register(MealtimeListHeaderView.nib, forHeaderFooterViewReuseIdentifier: MealtimeListHeaderView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension RecipeMealtimeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(round(Double(UserInfo.sharedInstance.selectedMealtimeData.count/2)))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeMealtimeCell") as? RecipeMealtimeCell else { fatalError() }
        cell.fillCell(recipes: UserInfo.sharedInstance.selectedMealtimeData,
                    delegate: self,
                   indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MealtimeListHeaderView.reuseIdentifier) as? MealtimeListHeaderView else {
            return UITableViewHeaderFooterView()
        }
        header.fillHeader()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MealtimeListHeaderView.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

extension RecipeMealtimeViewController: RecipeMealtimeDelegate {
    func showMealtimeDetails() {
        if UserInfo.sharedInstance.purchaseIsValid {
            performSegue(withIdentifier: "sequeRecipeMealtime", sender: nil)
        } else {
            performSegue(withIdentifier: "sequePremiumScreen", sender: nil)
        }
    }
}
