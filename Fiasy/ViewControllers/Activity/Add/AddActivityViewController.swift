//
//  AddActivityViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/12/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol AddActivityUIDelegate {
    func updateTableView()
    func addNewActivity(_ activity: ActivityElement)
}

class AddActivityViewController: UIViewController {

    // MARK: - Outlet -
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var listDelegate: ActivityManagerDelegate?
    
    // MARK: - Interface -
    func fillByDelegate(_ delegate: ActivityManagerDelegate) {
        self.listDelegate = delegate
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.register(type: AddActivityTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    // MARK: - Actions -
    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension AddActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddActivityTableViewCell") as? AddActivityTableViewCell else { fatalError() }
        cell.fillCell(delegate: self)
        return cell
    }
}

extension AddActivityViewController: AddActivityUIDelegate {
    
    func addNewActivity(_ activity: ActivityElement) {
        self.listDelegate?.addNewActivity(activity)
    }

    func updateTableView() {
        UIView.performWithoutAnimation {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}
