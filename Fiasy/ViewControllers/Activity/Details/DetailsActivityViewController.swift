//
//  DetailsActivityViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/16/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class DetailsActivityViewController: UIViewController {

    // MARK: - Outlet -
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var selectedModel: ActivityElement?
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationTitleLabel.text = LS(key: .ADD_ACTIVITIE)
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Interface -
    func fillScreenByModel(_ model: ActivityElement) {
        self.selectedModel = model
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.register(type: DetailsActivityTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    // MARK: - Actions -
    @IBAction func closeClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension DetailsActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsActivityTableViewCell") as? DetailsActivityTableViewCell else { fatalError() }
        cell.fillCell(selectedModel)
        return cell
    }
}
