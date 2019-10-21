//
//  PromotionalCodeViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class PromotionalCodeViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var activeButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var bottomCodeConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var writeCodeContainerView: UIView!
    @IBOutlet weak var bottomCornerContainerView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var defaultLabel: UILabel!

    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupBottomContainer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeContainerClicked(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func activateClicked(_ sender: Any) {
        guard let text = self.codeTextField.text else { return }
        FirebaseDBManager.checkValidPromo(text: text) { [weak self] (state) in
            guard let strongSelf = self else { return }
            if state {
                UserInfo.sharedInstance.purchaseIsValid = true
                strongSelf.performSegue(withIdentifier: "sequePremiumSuccess", sender: nil)
            } else {
                strongSelf.defaultLabel.text = "Неверный промокод"
                strongSelf.defaultLabel.textColor = #colorLiteral(red: 0.9624153972, green: 0.3719615936, blue: 0.2682288289, alpha: 1)
                strongSelf.separatorView.backgroundColor = #colorLiteral(red: 0.9624153972, green: 0.3719615936, blue: 0.2682288289, alpha: 1)
            }
        }
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        defaultLabel.text = "Введите ваш промокод"
        defaultLabel.textColor = #colorLiteral(red: 0.6313020587, green: 0.6314132214, blue: 0.6312951446, alpha: 1)
        separatorView.backgroundColor = #colorLiteral(red: 0.9293106198, green: 0.9294700027, blue: 0.9293007255, alpha: 1)
        activeButton.backgroundColor = (codeTextField.text?.isEmpty ?? true) ? #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1) : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
        activeButton.isEnabled = (codeTextField.text?.isEmpty ?? true) ? false : true
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: PromotionalCodeTableViewCell.self)
    }
    
    private func setupBottomContainer() {
        bottomCornerContainerView.clipsToBounds = true
        bottomCornerContainerView.layer.cornerRadius = 20
        bottomCornerContainerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}

extension PromotionalCodeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionalCodeTableViewCell") as? PromotionalCodeTableViewCell else { fatalError() }
        //cell.fillCell(indexPath: indexPath, purchaseIsValid: purchaseIsValid)
        return cell
    }
}
