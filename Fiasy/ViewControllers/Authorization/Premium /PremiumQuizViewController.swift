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

enum PremiumColorState {
    case black
    case white
}

class PremiumQuizViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    var isAutorization: Bool = true
    var trialFrom: String = "onboarding"
    private var subscriptionIndex: Int = 0
    var state: PremiumColorState = .black
    private let isIphone5 = Display.typeIsLike == .iphone5
    private let cells = [PremiumTopTableViewCell.self, PremiumMiddleTableViewCell.self, PremiumBottomTableViewCell.self]
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return state == .black ? .lightContent : .default
    }
    
    // MARK: - Life cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dcf = DateComponentsFormatter()
        dcf.allowedUnits = [.day, .hour, .minute]
        dcf.unitsStyle = .full
        
        let df = ISO8601DateFormatter()
        df.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        
        if let future = df.date(from: "2019-12-01") {
            let component = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: future)
            
            if let day = component.day, let hour = component.hour, let minute = component.minute, let second = component.second {
                if day <= 0 && hour <= 0 && minute <= 0 && second <= 0 {
                    state = .white
                } else {
                    state = .black
                }
            }
        }
        
        setupTableView()
        applyColorState(state: state)
        closeButton.isHidden = !isAutorization
        navigationTitleLabel.text = LS(key: .PREMIUM_TITLE)
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
            vc?.state = state
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.register(type: PremiumTopTableViewCell.self)
        tableView.register(type: PremiumMiddleTableViewCell.self)
        tableView.register(type: PremiumBottomTableViewCell.self)
    }
    
    func applyColorState(state: PremiumColorState) {
        switch state {
        case .black:
            backButton.tintColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
            closeButton.tintColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
            navigationTitleLabel.textColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
            statusView.backgroundColor = #colorLiteral(red: 0.1725074947, green: 0.1764294505, blue: 0.1805890203, alpha: 1)
            navigationView.backgroundColor = #colorLiteral(red: 0.1725074947, green: 0.1764294505, blue: 0.1805890203, alpha: 1)
            tableView.backgroundColor = #colorLiteral(red: 0.1019451842, green: 0.1018963829, blue: 0.1060404405, alpha: 1)
            navigationView.shadowColor = nil
        case .white:
            backButton.tintColor = #colorLiteral(red: 0.3372145891, green: 0.3372780979, blue: 0.3372106552, alpha: 1)
            closeButton.tintColor = #colorLiteral(red: 0.3372145891, green: 0.3372780979, blue: 0.3372106552, alpha: 1)
            statusView.backgroundColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
            navigationTitleLabel.textColor = #colorLiteral(red: 0.3372145891, green: 0.3372780979, blue: 0.3372106552, alpha: 1)
            navigationView.backgroundColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
            navigationView.shadowColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
            tableView.backgroundColor = #colorLiteral(red: 0.9881281257, green: 0.9882970452, blue: 0.9881176353, alpha: 1)
        }
    }
}

extension PremiumQuizViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cells[indexPath.row].className) else { fatalError() }
        if let cell = cell as? PremiumTopTableViewCell {
            cell.fillCell(delegate: self, state: self.state)
        } else if let cell = cell as? PremiumMiddleTableViewCell {
            cell.fillCell(state: self.state)
        } else if let cell = cell as? PremiumBottomTableViewCell {
            cell.fillCell(delegate: self, state: self.state)
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
