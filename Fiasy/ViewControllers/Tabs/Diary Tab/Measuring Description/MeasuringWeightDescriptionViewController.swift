//
//  MeasuringWeightDescriptionViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/23/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MeasuringWeightDescriptionViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var titleDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleDescriptionLabel.text = LS(key: .MEASURING_TITLE6).capitalizeFirst
        setupTableView()
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.register(type: MeasuringWeightDescriptionCell.self)
    }
    
    // MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension MeasuringWeightDescriptionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MeasuringWeightDescriptionCell") as? MeasuringWeightDescriptionCell else { fatalError() }
        //cell.fillCell(delegate: self)
        return cell
    }
}
