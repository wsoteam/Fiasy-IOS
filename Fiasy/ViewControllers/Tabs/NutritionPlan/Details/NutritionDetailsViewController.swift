//
//  NutritionDetailsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/27/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit
import Kingfisher

class NutritionDetailsViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var premiumContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    
    // MARK: - Properties -
    private var details: NutritionDetail?
    private var recipes: [[SecondRecipe]] = [[]]
    private var breakfast: [SecondRecipe] = []
    private var lunch: [SecondRecipe] = []
    private var dinner: [SecondRecipe] = []
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        premiumContainerView.isHidden = UserInfo.sharedInstance.purchaseIsValid
        filteredNutritions(recipes: recipes)
        setupTableView()
        
        nameLabel.text = details?.name
        tableView.contentInsetAdjustmentBehavior = .never
        if let path = details?.urlImage, let url = try? path.asURL() {
            let resource = ImageResource(downloadURL: url)
            topImageView.kf.setImage(with: resource)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RecipesDetailsViewController, let recipe = sender as? SecondRecipe {
            var title: String = LS(key: .BREAKFAST)
            if recipe.isBreakfast {
                title = LS(key: .BREAKFAST)
            } else if recipe.isLunch {
                title = LS(key: .LUNCH)
            } else if recipe.isDinner {
                title = LS(key: .DINNER)
            } else {
                title = LS(key: .SNACK)
            }
            vc.fillScreen(by: recipe, title: title)
        }
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.register(NutritionDetailsHeaderView.nib, forHeaderFooterViewReuseIdentifier: NutritionDetailsHeaderView.reuseIdentifier)
        tableView.register(type: NutritionDetailsTableCell.self)
        tableView.register(type: NutritionDetailsRow.self)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func filteredNutritions(recipes: [[SecondRecipe]]) {
        guard let flag = self.details?.flag else { return }
        
        for item in recipes[0] where item.nutritions.contains(flag) {
            breakfast.append(item)
        }
        for item in recipes[1] where item.nutritions.contains(flag) {
            lunch.append(item)
        }
        for item in recipes[2] where item.nutritions.contains(flag) {
            dinner.append(item)
        }
    }
    
    // MARK: - Interface -
    func fillScreen(_ details: NutritionDetail, recipes: [[SecondRecipe]]) {
        self.details = details
        self.recipes = recipes
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension NutritionDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (details?.countDays ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionDetailsTableCell") as? NutritionDetailsTableCell else { fatalError() }
            cell.fillCell(details: details)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionDetailsRow") as? NutritionDetailsRow else { fatalError() }
            cell.fillRow(recipes: [breakfast, lunch, dinner])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: NutritionDetailsHeaderView.reuseIdentifier) as? NutritionDetailsHeaderView else {
            return nil
        }
        header.titleLabel.text = "День \(section)"
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0001 : NutritionDetailsHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}
