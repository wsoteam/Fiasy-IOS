//
//  NotificationsListViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/2/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class NotificationsListViewController: UIViewController {

    // MARK: - Outlet's -
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Properties -
    
    // MARK: - Acions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: NotificationsHeaderListCell.self)
    }
}

extension NotificationsListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsHeaderListCell") as? NotificationsHeaderListCell else { fatalError() }
//        cell.fillSecondCell(indexPath: indexPath, delegate: self, UserInfo.sharedInstance.productFlow)
        return cell
    }
}
