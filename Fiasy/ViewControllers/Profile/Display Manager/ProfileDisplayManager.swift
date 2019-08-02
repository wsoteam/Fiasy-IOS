//
//  ProfileDisplayManager.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/19/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol ProfileDelegate {
    func showComplexityScreen()
    func editProfile()
}

class ProfileDisplayManager: NSObject {

    // MARK: - Properties -
    private let tableView: UITableView
    private let delegate: ProfileDelegate
    
    // MARK: - Interface -
    init(tableView: UITableView, delegate: ProfileDelegate) {
        self.delegate = delegate
        self.tableView = tableView
        super.init()
        setupTableView()
    }
    
    func reloadCells() {
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.register(type: DailyValuesCell.self)
        tableView.register(type: ProfileIndicatorCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ProfileDisplayManager: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyValuesCell") as? DailyValuesCell else { fatalError() }
            cell.fillCell(calories: "\(UserInfo.sharedInstance.currentUser?.maxKcal ?? 0)", waters: "\(UserInfo.sharedInstance.currentUser?.waterCount ?? 0) мл")
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileIndicatorCell") as? ProfileIndicatorCell else { fatalError() }
            cell.fillCell(delegate: delegate)
            return cell
        }
    }
}
