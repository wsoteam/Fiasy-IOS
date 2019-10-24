//
//  PremiumQuizViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import Amplitude_iOS

protocol PremiumQuizDelegate {
    func showPrivacyScreen()
    func showPremiumList()
    func purchedClicked()
    func changeSubscriptionIndex(index: Int)
}

class PremiumQuizViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    var isAutorization: Bool = true
    var trialFrom: String = "onboarding"
    private var subscriptionIndex: Int = 0
    private let isIphone5 = Display.typeIsLike == .iphone5
    private let cells = [PremiumTopTableViewCell.self, PremiumMiddleTableViewCell.self, PremiumBottomTableViewCell.self]
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    @objc func paymentComplete() {
        UserInfo.sharedInstance.paymentComplete = true
        UserInfo.sharedInstance.purchaseIsValid = true
        performSegue(withIdentifier: "sequeFinishPremiumScreen", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PremiumFinishViewController {
            let vc = segue.destination as? PremiumFinishViewController
            vc?.isAutorization = self.isAutorization
        } else if segue.destination is PremiumDetailsViewController {
            let vc = segue.destination as? PremiumDetailsViewController
            vc?.trialFrom = self.trialFrom
            vc?.isAutorization = self.isAutorization
        }
    }
    
    // MARK: - Action's -
    @IBAction func showPrivacyClicked(_ sender: Any) {
        Amplitude.instance()?.logEvent("premium_next", withEventProperties: ["push_button" : "privacy", "from" : trialFrom]) // +
        if let url = URL(string: "http://fiasy.com/privacypolice") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        Amplitude.instance()?.logEvent("onboarding_success", withEventProperties: ["from" : "close"]) // +
        
        let identify = AMPIdentify()
        identify.set("premium_status", value: "free" as NSObject)
        Amplitude.instance()?.identify(identify)

        Amplitude.instance()?.logEvent("premium_next", withEventProperties: ["push_button" : "close", "from" : trialFrom]) // +
        performSegue(withIdentifier: "sequeMenuScreen", sender: nil)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        Amplitude.instance()?.logEvent("premium_next", withEventProperties: ["push_button" : "back", "from" : trialFrom]) // +
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: PremiumTopTableViewCell.self)
        tableView.register(type: PremiumMiddleTableViewCell.self)
        tableView.register(type: PremiumBottomTableViewCell.self)
    }
}

extension PremiumQuizViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row].className) else { fatalError() }
        if let cell = cell as? PremiumTopTableViewCell {
            cell.fillCell(delegate: self)
        } else if let cell = cell as? PremiumMiddleTableViewCell {
            cell.fillCell()
        } else if let cell = cell as? PremiumBottomTableViewCell {
            cell.fillCell(delegate: self)
            cell.adjustTextViewHeight()
        }
        return cell
    }
}

extension PremiumQuizViewController: PremiumQuizDelegate {
    
    func showPrivacyScreen() {
        performSegue(withIdentifier: "sequePrivacyScreen", sender: nil)
    }
    
    func purchedClicked() {
        UserInfo.sharedInstance.trialFrom = trialFrom
        Amplitude.instance()?.logEvent("premium_next", withEventProperties: ["push_button" : "next", "from" : trialFrom]) // +
        SubscriptionService.shared.purchase(index: self.subscriptionIndex)
    }
    
    func changeSubscriptionIndex(index: Int) {
        self.subscriptionIndex = index
    }
    
    func showPremiumList() {
        performSegue(withIdentifier: "sequePremiumDetailsList", sender: nil)
    }
}
