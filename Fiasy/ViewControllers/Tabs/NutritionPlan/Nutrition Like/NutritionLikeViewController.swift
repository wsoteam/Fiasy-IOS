//
//  NutritionLikeViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/26/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol NutritionLikeDelegate {
    func searchRecipes(name: String)
    func removeSomeNutrition(nutrition: NutritionDetail, _ button: UIButton)
}

class NutritionLikeViewController: UIViewController {

    //MARK: - Outlet -
    @IBOutlet weak var blockedView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    private var activeButton = UIButton()
    var recipes: [[SecondRecipe]] = [[]]
    private var allNutritions: [NutritionDetail] = []
    private var filterNutritions: [NutritionDetail] = []
    lazy var removeAlertPresetsView: TemplateAlertPresetsView = {
        guard let view = TemplateAlertPresetsView.fromXib() else { return TemplateAlertPresetsView() }
        view.removeButton.setTitle(" Статья удалена из списка", for: .normal)
        return view
    }()
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivity()
        navigationTitleLabel.text = "Избранное"
        FirebaseDBManager.fetchLikeNutritionInDataBase { [weak self] (list) in
            guard let strongSelf = self else { return }
            strongSelf.allNutritions = list
            strongSelf.filterNutritions = list
            strongSelf.setupTableView()
            strongSelf.hideActivity()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NutritionDetailsViewController, let details = sender as? NutritionDetail {
            vc.fillScreen(details, recipes: self.recipes)
        }
    }
    
    //MARK: - Privates -
    private func setupTableView() {
        tableView.register(type: NutritionLikeTableCell.self)
        tableView.register(MealtimeListHeaderView.nib, forHeaderFooterViewReuseIdentifier: MealtimeListHeaderView.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    private func showActivity() {
        progressView.isHidden = false
        activity.startAnimating()
    }
    
    private func hideActivity() {
        progressView.isHidden = true
        activity.stopAnimating()
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
    
    private func isContains(pattern: String, in text: String?) -> Bool {
        guard let text = text else { return false }
        let lowcasePattern = pattern.lowercased()
        let lowcaseText = text.lowercased()
        
        let fullNameArr = lowcasePattern.split{$0 == " "}.map(String.init)
        var states: [Bool] = []
        for item in fullNameArr {
            states.append(lowcaseText.contains(item))
        }
        return !states.contains(false)
    }
    
    private func removeRow(_ indexPath: IndexPath) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .left)
            self.tableView.endUpdates()
        })
        CATransaction.commit()
    }
    
    internal func showDeleteAlert(indexPath: IndexPath) {
        SwiftEntryKit.dismiss()
        var attributes = EKAttributes()
        attributes.fillAppConfigure(height: 50.0)
        removeAlertPresetsView.fillView(delegate: self, index: indexPath)
        blockedView.isHidden = false
        SwiftEntryKit.display(entry: removeAlertPresetsView, using: attributes)
    }
    
    //MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension NutritionLikeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterNutritions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionLikeTableCell") as? NutritionLikeTableCell else { fatalError() }
        cell.fillRow(nutrition: filterNutritions[indexPath.row], delegate: self, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MealtimeListHeaderView.reuseIdentifier) as? MealtimeListHeaderView else {
            return nil
        }
        header.fillSecondHeader(delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filterNutritions.indices.contains(indexPath.row) {
            performSegue(withIdentifier: "showNutritionDetails", sender: filterNutritions[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MealtimeListHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 203.0 : 210.0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let header = tableView.headerView(forSection: 0) as? MealtimeListHeaderView {
            if scrollView.contentOffset.y > 0 {
                addShadow(header.searchContainerView)
            } else {
                deleteShadow(header.searchContainerView)
            }
        }
    }
}

extension NutritionLikeViewController: NutritionLikeDelegate, BasketDelegate {
    
    func removeProduct(indexPath: IndexPath) {
        SwiftEntryKit.dismiss()
        self.blockedView.isHidden = true
        if let key = filterNutritions[indexPath.row].removeKey {
            FirebaseDBManager.saveDislikeNutritionInDataBase(key: key)
            if let vc = UIApplication.getTopMostViewController(), let previous = vc.navigationController?.viewControllers.previous as? NutritionPlanViewController {
                previous.removeLikeByPrevious(nutrition: filterNutritions[indexPath.row])
            }
            filterNutritions.remove(at: indexPath.row)
            for (index, item) in allNutritions.enumerated() where item.removeKey == key {
                allNutritions.remove(at: index)
            }
            removeRow(indexPath)
        }
    }
    
    func cancelRemoveProduct(indexPath: IndexPath) {
        SwiftEntryKit.dismiss()
        blockedView.isHidden = true
        activeButton.setImage(#imageLiteral(resourceName: "someLike"), for: .normal)
    }
    
    func replaceProduct(newCount: Int, _ selectedPortionId: Int?) {
        //
    }
    
    func removeSomeNutrition(nutrition: NutritionDetail, _ button: UIButton) {
        var indexItem: IndexPath?
        for (index,item) in filterNutritions.enumerated() where nutrition.name == item.name {
            indexItem = IndexPath(row: index, section: 0)
        }
        if let index = indexItem {
            activeButton = button
            showDeleteAlert(indexPath: index)
        }
    }
    
    func searchRecipes(name: String) {
        guard !name.isEmpty else {
            filterNutritions = allNutritions
            return tableView.reloadData()
        }
        var newList: [NutritionDetail] = []
        for item in allNutritions where self.isContains(pattern: name, in: "\(item.name ?? "")") {
            newList.append(item)
        }
        filterNutritions = newList
        tableView.reloadData()
    }
}
