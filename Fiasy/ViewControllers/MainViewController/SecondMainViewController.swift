//
//  SecondMainViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol SecondMainManagerDelegate {
    func showMoreDescription(state: Bool, indexPath: IndexPath)
}

class SecondMainViewController: UIViewController {
    
    //MARK: - Outlets -
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    private var states = Array<Bool>()
    private let fakeCells = [SecondMainCell.self, SecondMainCell.self, SecondMainCell.self, SecondMainCell.self, SecondMainCell.self, SecondMainCell.self, SecondMainCell.self, SecondMainCell.self]
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.states = [Bool](repeating: false, count: fakeCells.count)
        setupTableView()
    }
    
    func fillDate(date: Date) {
        //dateLabel.text = DateFormatters.shortDateFormatter.string(from: date)
    }
    
    private func setupTableView() {
        tableView.register(SecondMainCell.nib, forCellReuseIdentifier: SecondMainCell.reuseIdentifier)
    }
}

extension SecondMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: fakeCells[indexPath.row].className) else { fatalError() }
        
        if let cell = cell as? SecondMainCell {
            if states.indices.contains(indexPath.row) {
                cell.fillCell(state: states[indexPath.row], indexCell: indexPath, delegate: self)
            }
        }
        return cell
    }
}

extension SecondMainViewController: SecondMainManagerDelegate {
    
    func showMoreDescription(state: Bool, indexPath: IndexPath) {
        states[indexPath.row] = !state
        self.tableView.reloadData()
    }
}
