//
//  RecipesViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS
import DynamicBlurView
import TagListView
import Intercom
import VisualEffectView

protocol RecipesDelegate {
    func showMoreClicked(title: String)
}

class RecipesViewController: UIViewController {
    
    //MARK: - Outlet -
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var filterStackView: UIStackView!
    @IBOutlet weak var tagContainerView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var blurView: VisualEffectView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    private var breakfasts: [Listrecipe] = []
    private var lunches: [Listrecipe] = []
    private var dinners: [Listrecipe] = []
    private var snacks: [Listrecipe] = []
    
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivity()
        DispatchQueue.background(background: {
            UserInfo.sharedInstance.getAllRecipes()
            self.fetchRecipes(recipes: UserInfo.sharedInstance.allRecipes)
        }, completion: {
            self.setupTableView()
            self.setupInitialState()
            self.hideActivity()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserInfo.sharedInstance.paymentComplete {
            UserInfo.sharedInstance.paymentComplete = false
            if let _ = UserInfo.sharedInstance.selectedRecipes {
                performSegue(withIdentifier: "sequeRecipeMealtime", sender: nil)
            }
        }

        DispatchQueue.global().async {
            UserInfo.sharedInstance.purchaseIsValid = SubscriptionService.shared.checkValidPurchases()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    //MARK: - Action -
    @IBAction func filterClicked(_ sender: Any) {
//        if blur.isHidden {
//            blur.fadeIn(secondView: filterView)
//        } else {
//            blur.fadeOut(secondView: filterView)
//
//        }
        filterView.isHidden = !filterView.isHidden
    }
    
    @IBAction func filterContainerClicked(_ sender: UIButton) {
        if tagContainerView.isHidden {
            sender.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
            tagContainerView.showAnimated(in: filterStackView)
        } else {
            sender.setImage(#imageLiteral(resourceName: "Arrow_down"), for: .normal)
            tagContainerView.hideAnimated(in: filterStackView)
        }
    }
    
    //MARK: - Privates -
    private func setupTableView() {
        tableView.register(RecipesHeaderView.nib, forHeaderFooterViewReuseIdentifier: RecipesHeaderView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    private func setupInitialState() {

        blurView.colorTint = .gray
        blurView.colorTintAlpha = 0.1
        blurView.blurRadius = 5
        blurView.scale = 1
        
        tagList.textColor = .white
        tagList.textFont = UIFont.fontRobotoRegular(size: 12)
        tagList.addTags(["ЗАВТРАК", "ОБЕД", "УЖИН", "ВЫСОКОБЕЛКОВЫЙ", "НИЗКОУГЛЕВОДНЫЙ"])
        tagList.delegate = self
    }
    
    private func fetchRecipes(recipes: [Listrecipe]) {
        for item in recipes {
            if let arrays = item.eating {
                for secondItem in arrays {
                    switch secondItem {
                    case .breakfast:
                        breakfasts.append(item)
                    case .lunch:
                        lunches.append(item)
                    case .dinner:
                        dinners.append(item)
                    case .snack:
                        snacks.append(item)
                    }
                }
            }
        }
    }
    
    private func showActivity() {
        progressView.isHidden = false
        activity.startAnimating()
    }
    
    private func hideActivity() {
        progressView.isHidden = true
        activity.stopAnimating()
    }
}

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesRow") as? RecipesRow else { fatalError() }
        
        switch indexPath.section {
            case 0:
                if breakfasts.indices.contains(indexPath.row) {
                    cell.fillRow(by: breakfasts)
                }
            case 1:
                if lunches.indices.contains(indexPath.row) {
                    cell.fillRow(by: lunches)
                }
            case 2:
                if dinners.indices.contains(indexPath.row) {
                    cell.fillRow(by: dinners.reversed())
                }
            case 3:
                if snacks.indices.contains(indexPath.row) {
                    cell.fillRow(by: snacks)
                }
            default:
                break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecipesHeaderView.reuseIdentifier) as? RecipesHeaderView else {
            return UITableViewHeaderFooterView()
        }
        header.fillHeader(by: section, delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RecipesHeaderView.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RecipesRow.rowHeight
    }
}

extension RecipesViewController: RecipesDelegate {
    
    func showMoreClicked(title: String) {
        UserInfo.sharedInstance.selectedMealtimeHeaderTitle = title
        var item: String = ""
        switch title {
        case "Завтрак":
            item = "breakfast"
            UserInfo.sharedInstance.selectedMealtimeData = breakfasts
        case "Обед":
            item = "lunch"
            UserInfo.sharedInstance.selectedMealtimeData = lunches
        case "Ужин":
            item = "dinner"
            UserInfo.sharedInstance.selectedMealtimeData = dinners
        case "Перекус":
            item = "snack"
            UserInfo.sharedInstance.selectedMealtimeData = snacks
        default:
            break
        }
        Intercom.logEvent(withName: "recipe_category", metaData: ["recipe_category" : item]) // +
        Amplitude.instance()?.logEvent("recipe_category", withEventProperties: ["recipe_category" : item]) // +
        performSegue(withIdentifier: "sequeRecipeMealtime", sender: nil)
    }
}

extension RecipesViewController: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected = !tagView.isSelected
    }
}
