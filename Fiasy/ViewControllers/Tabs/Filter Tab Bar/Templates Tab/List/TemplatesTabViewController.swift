//
//  TemplatesTabViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TemplatesTabViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var bottomTableConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var isEditSequeShow: Bool = false
    private var itemInfo = IndicatorInfo(title: "Шаблоны")
    private var selectedTemplate: Template?
    private var allTemplates: [Template] = []
    private var filteredTemplates: [Template] = []
    private lazy var picker: FavoritePickerService = {
        let picker = FavoritePickerService()
        picker.targetVC = self
        picker.edit = { [weak self] in
            self?.isEditSequeShow = true
            self?.performSegue(withIdentifier: "AddTemplatesScreen", sender: nil)
        }
        picker.remove = { [weak self] in
            guard let key = self?.selectedTemplate?.generalKey else { return }
            FirebaseDBManager.removeTemplate(key: key, handler: {
                self?.removeTemplate(by: key)
            })
        }
        return picker
    }()
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showActivity()
        setupTableView()
        fetchItemsInDataBase()
        setupLongPressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
        hideKeyboardWhenTappedAround()
        
        addObserver(for: self, #selector(searchByText), "searchClicked")
        if UserInfo.sharedInstance.reloadTemplate {
            UserInfo.sharedInstance.reloadTemplate = false
            showActivity()
            fetchItemsInDataBase()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTemplatesScreen" && isEditSequeShow {
            if let vc = segue.destination as? AddTemplateViewController {
                guard let selected = self.selectedTemplate else { return }
                vc.fillTemplate(template: selected)
            }
        }
    }
    
    @objc func searchByText() {
        if UserInfo.sharedInstance.searchProductText.isEmpty {
            filteredTemplates = allTemplates
        } else {
            var firstItems: [Template] = []
            for item in allTemplates where self.isContains(pattern: UserInfo.sharedInstance.searchProductText, in: "\(item.name ?? "")") {
                firstItems.append(item)
            }
            filteredTemplates = firstItems
        }
        tableView.reloadData()
        if filteredTemplates.isEmpty && !UserInfo.sharedInstance.searchProductText.isEmpty {
            AlertComponent.sharedInctance.showAlertMessage(message: "Шаблон не найден", vc: self)
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
        return states.contains(true)
    }
    
    // MARK: - Action's -
    @IBAction func addTemplatesClicked(_ sender: Any) {
        UserInfo.sharedInstance.templateArray.removeAll()
        isEditSequeShow = false
        performSegue(withIdentifier: "AddTemplatesScreen", sender: nil)
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.register(type: TemplatesListCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchItemsInDataBase() {
        FirebaseDBManager.fetchTemplateInDataBase { [weak self] (result) in
            guard let `self` = self else { return }
//            self.allTemplates = result
//            self.filteredTemplates = result
//            self.emptyView.isHidden = !result.isEmpty
//            self.hideActivity()
//            self.tableView.reloadData()
        }
    }
    
    private func removeTemplate(by key: String) {
        if allTemplates.count == filteredTemplates.count {
            var indexPath: IndexPath?
            for (index,item) in allTemplates.enumerated() where item.generalKey == key {
                allTemplates.remove(at: index)
                indexPath = IndexPath(item: index, section: 0)
            }
            filteredTemplates = allTemplates
            if let index = indexPath {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [index], with: .right)
                    self.tableView.endUpdates()
                    self.emptyView.isHidden = !self.allTemplates.isEmpty
                })
                CATransaction.commit()
            }
        } else {
            for (index,item) in allTemplates.enumerated() where item.generalKey == key {
                allTemplates.remove(at: index)
            }
            var indexPath: IndexPath?
            for (index,item) in filteredTemplates.enumerated() where item.generalKey == key {
                filteredTemplates.remove(at: index)
                indexPath = IndexPath(item: index, section: 0)
            }
            if let index = indexPath {
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [index], with: .right)
                    self.tableView.endUpdates()
                    self.emptyView.isHidden = !self.allTemplates.isEmpty
                })
                CATransaction.commit()
            }
        }
    }
    
    private func setupLongPressGesture() {
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint),
                let cell = tableView.cellForRow(at: indexPath) as? TemplatesListCell {
                self.selectedTemplate = cell.fetchTemplate()
                picker.showPicker()
            }
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
}

extension TemplatesTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTemplates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TemplatesListCell") as? TemplatesListCell else { fatalError() }
        cell.fillCell(filteredTemplates[indexPath.row])
        return cell
    }
}

extension TemplatesTabViewController: IndicatorInfoProvider {
    
    // MARK: - IndicatorInfoProvider
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}

extension TemplatesTabViewController {
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomTableConstraint.constant = keyboardHeight - (tabBarController?.tabBar.frame.height ?? 49.0)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        self.bottomTableConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
