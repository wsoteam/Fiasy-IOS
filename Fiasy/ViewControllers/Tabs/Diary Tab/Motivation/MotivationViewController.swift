//
//  MotivationViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/9/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MotivationViewController: UIViewController {
    
    //MARK: - Outlets -
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var count: Int = UserInfo.sharedInstance.dayCount.count
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    //MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.register(type: MotivationTopCell.self)
        tableView.register(type: MotivationBottomCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MotivationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MotivationTopCell") as? MotivationTopCell else { fatalError() }
            cell.fillCell(count: self.count)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MotivationBottomCell") as? MotivationBottomCell else { fatalError() }
            
            return cell
        }
    }
}
