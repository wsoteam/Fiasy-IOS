//
//  RecipesDetailsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS

class RecipesDetailsViewController: UIViewController {
    
    //MARK: - Outlet's -
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    private let selectedRecipe = UserInfo.sharedInstance.selectedRecipes
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        Amplitude.instance().logEvent("view_detail_food")
        Amplitude.instance().logEvent("view_recipe")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset = UIEdgeInsets(top: -UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: 0, right: 0)
    }
    
    //MARK: - Privates -
    private func setupTableView() {
        tableView.register(type: DishDescriptionCell.self)
        tableView.register(RecipesHeaderDetailsView.nib, forHeaderFooterViewReuseIdentifier: RecipesHeaderDetailsView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension RecipesDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DishDescriptionCell") as? DishDescriptionCell else { fatalError() }

        if let recipe = selectedRecipe {
            cell.fillCell(recipe: recipe)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecipesHeaderDetailsView.reuseIdentifier) as? RecipesHeaderDetailsView else {
            return UITableViewHeaderFooterView()
        }
        header.fillHeader(imageUrl: selectedRecipe?.url)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RecipesHeaderDetailsView.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y > 0 else {
            return scrollView.contentOffset = CGPoint(x: 0, y: 0) }
        
        let offset = scrollView.contentOffset.y / 250
        let isFilled = offset >= 0.8
        let backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
        navigationView.backgroundColor = backgroundColor.withAlphaComponent(offset)
        statusBarView.backgroundColor = backgroundColor.withAlphaComponent(offset)
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.backButton.tintColor = isFilled ? .black : .white
        }
    }
}
