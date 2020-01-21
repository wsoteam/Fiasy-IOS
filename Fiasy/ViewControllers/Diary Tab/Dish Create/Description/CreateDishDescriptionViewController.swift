//
//  CreateDishDescriptionViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/8/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit

class CreateDishDescriptionViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var titleDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //titleDescriptionLabel.text = LS(key: .MEASURING_TITLE6).capitalizeFirst
        setupTableView()
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.register(type: CreateDishDescriptionCell.self)
    }
    
    // MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension CreateDishDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreateDishDescriptionCell") as? CreateDishDescriptionCell else { fatalError() }
        //cell.fillCell(delegate: self)
        return cell
    }
}
