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
    func showPrivacyScreen()
    func showSubscriptions(_ selectedIndex: Int)
}

class PremiumDetailsViewController: UIViewController {

    // MARK: - Outlet -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var statusContainerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    var isAutorization: Bool = true
    var trialFrom: String = "onboarding"
    var state: PremiumColorState = .black
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return state == .black ? .lightContent : .default
    }
    
    deinit {
        removeObserver()
    }
    
    // MARK: - Life cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        applyColorState(state: .black)
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
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
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
    
    // MARK: - Private -
    func applyColorState(state: PremiumColorState) {
        switch state {
        case .black:
            backButton.tintColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
            closeButton.tintColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
            titleLabel.textColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
            statusContainerView.backgroundColor = #colorLiteral(red: 0.1725074947, green: 0.1764294505, blue: 0.1805890203, alpha: 1)
            navigationView.backgroundColor = #colorLiteral(red: 0.1725074947, green: 0.1764294505, blue: 0.1805890203, alpha: 1)
            tableView.backgroundColor = #colorLiteral(red: 0.1019451842, green: 0.1018963829, blue: 0.1060404405, alpha: 1)
            navigationView.shadowColor = nil
        case .white:
            backButton.tintColor = #colorLiteral(red: 0.3372145891, green: 0.3372780979, blue: 0.3372106552, alpha: 1)
            closeButton.tintColor = #colorLiteral(red: 0.3372145891, green: 0.3372780979, blue: 0.3372106552, alpha: 1)
            statusContainerView.backgroundColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
            titleLabel.textColor = #colorLiteral(red: 0.3372145891, green: 0.3372780979, blue: 0.3372106552, alpha: 1)
            navigationView.backgroundColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
            navigationView.shadowColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
            tableView.backgroundColor = #colorLiteral(red: 0.9881281257, green: 0.9882970452, blue: 0.9881176353, alpha: 1)
        }
    }
}

extension PremiumDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PremiumDetailsCell") as? PremiumDetailsCell else { fatalError() }
        cell.fillCell(delegate: self, state: self.state)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PremiumDetailsViewController: PremiumDetailsDelegate {
    
    func showPrivacyScreen() {
        performSegue(withIdentifier: "sequePrivacyScreen", sender: nil)
    }
    
    func showSubscriptions(_ selectedIndex: Int) {
        SubscriptionService.shared.purchase(index: selectedIndex)
    }
}
