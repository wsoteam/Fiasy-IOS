//
//  ProfileDisplayManager.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/19/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol ProfileDisplayDelegate {
    func arrowButtonClicked(indexPath: IndexPath)
}

protocol ProfileDelegate {
    func editProfile()
    func showComplexityScreen()
}

class ProfileDisplayManager: NSObject {

    // MARK: - Properties -
    private let tableView: UITableView
    private let delegate: ProfileDelegate
    private var isArrowSelected: Bool = false
    
    // MARK: - Interface -
    init(_ tableView: UITableView, _ delegate: ProfileDelegate) {
        self.delegate = delegate
        self.tableView = tableView
        super.init()
        setupTableView()
    }
    
    func reloadCells() {
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
    }
    
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        tableView.register(type: ProfileAvatarTableViewCell.self)
        tableView.register(type: ProfileIndicatorCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
}

extension ProfileDisplayManager: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileAvatarTableViewCell") as? ProfileAvatarTableViewCell else { fatalError() }
            cell.fillCell(delegate: self, indexCell: indexPath, state: isArrowSelected)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileIndicatorCell") as? ProfileIndicatorCell else { fatalError() }
            cell.fillCell()
            //cell.fillCell(delegate: delegate)
            return cell
        }
    }
}

extension ProfileDisplayManager: ProfileDisplayDelegate {
    
    func arrowButtonClicked(indexPath: IndexPath) {
        isArrowSelected = !isArrowSelected
        self.tableView.beginUpdates()
//        if let cell = tableView.cellForRow(at: indexPath) as? ProfileAvatarTableViewCell {
//            cell.bottomContainerView.isHidden = !state
//        }
        self.tableView.endUpdates()
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
}
