//
//  MeasuringListViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/23/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class MeasuringListViewController: UIViewController {
    
    enum ScreenState: Int {
        case weight = 0
        case waist = 1
        case chest = 2
        case hips = 3
    }
    
    // MARK: - Outlet -
    @IBOutlet weak var emptySectionsView: UIView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var backgroundListVIews: [UIView]!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties -
    private var selectedIndex: Int = 0
    private var allMeasurings: [Measuring] = []
    private var selectedMeasurings: [Measuring] = []
    private var selectedScreenState: ScreenState = .weight
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeIndex(index: 0)
        showActivity()
        setupTableView()
        fetchMeasuring()
    }
    
    // MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterClicked(_ sender: UIButton) {
        changeIndex(index: sender.tag)
        applyScreenMeasuring(state: ScreenState(rawValue: sender.tag) ?? .weight)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: MeasuringListTableViewCell.self)
    }
    
    private func fetchMeasuring() {
        FirebaseDBManager.fetchMyMeasuringInDataBase { [weak self] (list) in
            guard let strongSelf = self else { return }
            for item in list {
                var isContains: Bool = false
                for (index, secondItem) in strongSelf.allMeasurings.enumerated() where secondItem.type == item.type && (Calendar.current.component(.day, from: secondItem.date ?? Date()) == Calendar.current.component(.day, from: item.date ?? Date()) && Calendar.current.component(.month, from: secondItem.date ?? Date()) == Calendar.current.component(.month, from: item.date ?? Date()) && Calendar.current.component(.year, from: secondItem.date ?? Date()) == Calendar.current.component(.year, from: item.date ?? Date())) {
                    isContains = true
                    if secondItem.timeInMillis < item.timeInMillis {
                        strongSelf.allMeasurings[index] = item
                    }
                    break
                }
                if !isContains {
                    strongSelf.allMeasurings.append(item)
                }
            }

            strongSelf.setupTableView()
            strongSelf.applyScreenMeasuring(state: .weight)
            strongSelf.hideActivity()
        }
    }

    private func showActivity() {
        activityView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivity() {
        activityView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func changeIndex(index: Int) {
        for item in backgroundListVIews {
            if item.tag == index {
                item.backgroundColor = #colorLiteral(red: 0.9344636798, green: 0.5902308822, blue: 0.1663158238, alpha: 1)
            } else {
                item.backgroundColor = #colorLiteral(red: 0.8783355355, green: 0.8784865737, blue: 0.8783260584, alpha: 1)
            }
        }
    }
    
    private func applyScreenMeasuring(state: ScreenState) {
        var list: [Measuring] = []
        switch state {
        case .weight:
            for item in allMeasurings where item.type == .weight {
                list.append(item)
            }
            selectedMeasurings = list
        case .waist:
            for item in allMeasurings where item.type == .waist {
                list.append(item)
            }
            selectedMeasurings = list
        case .chest:
            for item in allMeasurings where item.type == .chest {
                list.append(item)
            }
            selectedMeasurings = list
        case .hips:
            for item in allMeasurings where item.type == .hips {
                list.append(item)
            }
            selectedMeasurings = list
        }
        
        selectedMeasurings = selectedMeasurings.sorted (by: {$0.timeInMillis > $1.timeInMillis})

        if list.isEmpty {
            emptySectionsView.isHidden = false
        } else {
            emptySectionsView.isHidden = true
            tableView.reloadData()
        }
    }
}

extension MeasuringListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedMeasurings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MeasuringListTableViewCell") as? MeasuringListTableViewCell else { fatalError() }
        cell.fillCell(measuring: selectedMeasurings[indexPath.row])
        return cell
    }
}
