//
//  ArticlesExpertsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ArticlesExpertsViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var navigationView: UIView?
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var showBottomContainer: Bool = true
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        guard let _ = self.navigationView else { 
            if let _ = navigationController?.viewControllers.first as? ArticlesViewController {
                self.navigationController?.viewControllers.remove(at: 0)
            }
            return 
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ListExpertArticlesViewController, (segue.identifier == "sequeListExpertArticles") {
            vc.hiddenBackButton(hidden: true)
        }
    }
    
    func hiddenBottomContainer() {
        self.showBottomContainer = false
    }
    
    // MARK: - Privates -
    private func setupTableView() {
        tableView.register(type: ArticlesExpertsTableCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        guard let _ = self.navigationView else {
            tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
            return 
        }
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

extension ArticlesExpertsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticlesExpertsTableCell") as? ArticlesExpertsTableCell else { fatalError() }
        cell.fillCell(show: showBottomContainer)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigation = self.navigationView else { return }
        if scrollView.contentOffset.y > 0 {
            addShadow(navigation)
        } else {
            deleteShadow(navigation)
        }
    }
}
