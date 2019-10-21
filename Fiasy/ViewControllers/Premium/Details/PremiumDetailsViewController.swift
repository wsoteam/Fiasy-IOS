//
//  PremiumDetailsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/18/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS

protocol PremiumDetailsDelegate {
    func showSubscriptions(_ selectedIndex: Int)
}

class PremiumDetailsViewController: UIViewController {

    // MARK: - Outlet -
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    var isAutorization: Bool = true
    var trialFrom: String = "onboarding"
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
        removeObserver()
    }
    
    // MARK: - Life cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        closeButton.isHidden = !isAutorization
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver(for: self, #selector(paymentComplete), Constant.PAYMENT_COMPLETE)
    }
    
    @objc func paymentComplete() {
        UserInfo.sharedInstance.paymentComplete = true
        UserInfo.sharedInstance.purchaseIsValid = true
        performSegue(withIdentifier: "sequeFinishPremiumScreen", sender: nil)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.register(type: PremiumDetailsCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    // MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        Amplitude.instance()?.logEvent("onboarding_success", withEventProperties: ["from" : "close"]) // +
        
        let identify = AMPIdentify()
        identify.set("premium_status", value: "free" as NSObject)
        Amplitude.instance()?.identify(identify)
        
        Amplitude.instance()?.logEvent("premium_next", withEventProperties: ["push_button" : "close", "from" : trialFrom]) // +
        performSegue(withIdentifier: "sequeMenuScreen", sender: nil)
    }
}

extension PremiumDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumDetailsCell") as? PremiumDetailsCell else { fatalError() }
        cell.fillCell(index: indexPath.row, delegate: self)
        return cell
    }
}

extension PremiumDetailsViewController: PremiumDetailsDelegate {
    
    func showSubscriptions(_ selectedIndex: Int) {
        SubscriptionService.shared.purchase(index: selectedIndex)
    }
}
