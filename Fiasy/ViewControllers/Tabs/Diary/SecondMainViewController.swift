//
//  SecondMainViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase

protocol SecondMainManagerDelegate {
    func showMoreDescription(state: Bool, indexPath: IndexPath)
    func showDeletePicker(indexInStack: Int, indexPath: IndexPath)
    func showEditMealtime(by indexInStack: Int, indexPath: IndexPath)
    func selectedMealtime(by index: Int)
}

class SecondMainViewController: UIViewController {
    
    //MARK: - Outlets -
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    var date = Date()
    private var states = Array<Bool>()
    private var indexInStack: Int?
    private var indexPath: IndexPath?
    private var picker = DiaryClickedPicker()
    private let fakeCells = [SecondMainCell.self, SecondMainCell.self, SecondMainCell.self, SecondMainCell.self]
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.states = [Bool](repeating: false, count: fakeCells.count)
        setupTableView()
        configurePicker()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50.0, right: 0)
    }

    private func setupTableView() {
        tableView.register(SecondMainCell.nib, forCellReuseIdentifier: SecondMainCell.reuseIdentifier)
    }
    
    private func configurePicker() {
        picker.targetVC = self
        picker.removeMealtime = { [weak self] in
            guard let indexStack = self?.indexInStack, let indexCell = self?.indexPath else {
                return
            }
            FirebaseDBManager.removeItem(indexStack: indexStack, indexCell: indexCell) { [weak self]  in
                self?.post(Constant.RELOAD_DIARY)
            }
        }
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
                cell.fillCell(state: states[indexPath.row], indexCell: indexPath, delegate: self, selectedDate: date)
            }
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0.0 {
            tableView.isScrollEnabled = true
        } else {
            tableView.isScrollEnabled = false
        }
    }
}

extension SecondMainViewController: SecondMainManagerDelegate {
    
    func showEditMealtime(by indexInStack: Int, indexPath: IndexPath) {
        UserInfo.sharedInstance.indexInStack = indexInStack
        UserInfo.sharedInstance.indexPath = indexPath
        performSegue(withIdentifier: "sequeEditScreen", sender: nil)
    }
    
    func showDeletePicker(indexInStack: Int, indexPath: IndexPath) {
        self.indexInStack = indexInStack
        self.indexPath = indexPath
        picker.showPicker()
    }
    
    func selectedMealtime(by index: Int) {
        UserInfo.sharedInstance.selectedMealtimeIndex = index
        performSegue(withIdentifier: "sequeSearchScreen", sender: nil)
    }

    func showMoreDescription(state: Bool, indexPath: IndexPath) {
        states[indexPath.row] = !state
        tableView.reloadData()
    }
}
