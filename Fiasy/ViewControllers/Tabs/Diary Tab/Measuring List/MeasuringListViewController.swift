//
//  MeasuringListViewController.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 10/23/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol MeasuringListDelegate {
    func filterClickedByTag(index: Int)
}

class MeasuringListViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var selectedIndex: Int = 0
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: MeasuringListTableViewCell.self)
    }
}

extension MeasuringListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MeasuringListTableViewCell") as? MeasuringListTableViewCell else { fatalError() }
        cell.fillCell(index: selectedIndex, delegate: self)
        return cell
    }
}

extension MeasuringListViewController: MeasuringListDelegate {
    
    func filterClickedByTag(index: Int) {
        //
    }
}
