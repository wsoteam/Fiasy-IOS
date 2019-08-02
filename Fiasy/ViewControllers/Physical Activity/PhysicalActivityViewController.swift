//
//  PhysicalActivityViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/20/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol PhysicalActivityDelegate {
    func closeModule()
}

class PhysicalActivityViewController: UIViewController {
    
    //MARK: - Outlet's -
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(type: PhysicalActivityCell.self)
    }
    
    //MARK: - Private -
    @IBAction func closeModule(_ sender: Any) {
        dismiss(animated: false)
    }
}

extension PhysicalActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhysicalActivityCell") as? PhysicalActivityCell else { fatalError() }
        cell.fillCell(indexPath: indexPath, delegate: self)
        return cell
    }
}

extension PhysicalActivityViewController: PhysicalActivityDelegate {
    func closeModule() {
        post("reloadContent")
        dismiss(animated: false)
    }
}
