//
//  MeasuringViewController.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 10/22/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol MeasuringDelegate {
    func showMiddleWeightDescriptionScreen()
}

class MeasuringViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.register(type: MeasuringTableViewCell.self)
        tableView.register(type: MeasuringPremiumTableViewCell.self)
        tableView.register(MeasuringHeaderView.nib, forHeaderFooterViewReuseIdentifier: MeasuringHeaderView.reuseIdentifier)
    }
    
    // MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension MeasuringViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MeasuringTableViewCell") as? MeasuringTableViewCell else { fatalError() }
            cell.fillCell(delegate: self)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MeasuringPremiumTableViewCell") as? MeasuringPremiumTableViewCell else { fatalError() }
            cell.fillCell(index: indexPath.row)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MeasuringHeaderView.reuseIdentifier) as? MeasuringHeaderView else {
            return nil
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.00001 : MeasuringHeaderView.height
    }
}

extension MeasuringViewController: MeasuringDelegate {
    
    func showMiddleWeightDescriptionScreen() {
        performSegue(withIdentifier: "sequeMiddleWeightDescription", sender: nil)
    }
}

