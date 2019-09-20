//
//  WaterDetailsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/4/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class WaterDetailsViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
//    private let ref = Database.database().reference()
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.register(type: WaterDetailsTableViewCell.self)
        tableView.register(EditProfileFooterView.nib, forHeaderFooterViewReuseIdentifier: EditProfileFooterView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension WaterDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WaterDetailsTableViewCell") as? WaterDetailsTableViewCell else { fatalError() }
        //cell.fillCell(indexCell: indexPath, currentUser: currentUser, delegate: self, target: target, activity: activity)
        return cell
    }
}
