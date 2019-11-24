//
//  ListExpertArticlesViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ListExpertArticlesViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Privates -
    private func setupTableView() {
        //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(type: ListExpertArticlesTableCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    private func addShadow(_ view: UIView) {
        UIView.animate(withDuration: 0.1) { 
            view.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5030455508).cgColor
        }
    }
    
    private func deleteShadow(_ view: UIView) {
        UIView.animate(withDuration: 0.1) { 
            view.layer.shadowColor = UIColor.clear.cgColor
        }
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension ListExpertArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListExpertArticlesTableCell") as? ListExpertArticlesTableCell else { fatalError() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            addShadow(navigationView)
        } else {
            deleteShadow(navigationView)
        }
    }
}
