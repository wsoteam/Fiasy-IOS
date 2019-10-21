//
//  ProductAddingOptionsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/4/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ProductAddingOptionsViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties -
    lazy var dropdownView: LMDropdownView = LMDropdownView()
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var selectedTitle: String = ""
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        dropdownView.delegate = self
        fillTitleNavigation(index: UserInfo.sharedInstance.selectedMealtimeIndex)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuTableView.frame = CGRect(x: menuTableView.frame.minX,
                                     y: menuTableView.frame.minY,
                                     width: view.bounds.width,
                                     height: min(view.bounds.height, CGFloat(200)))
//        moreBottomView.frame = CGRect(x: moreBottomView.frame.minX,
//                                      y: moreBottomView.frame.minY,
//                                      width: view.bounds.width,
//                                      height: moreBottomView.bounds.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configurationKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func titleButtonClicked(_ sender: Any) {
        menuTableView.reloadData()
        showDropdownView(fromDirection: .top)
    }
    
    // MARK: - Privates -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(type: ProductAddingOptionsCell.self)
        tableView.register(RecipesSearchHeaderView.nib, forHeaderFooterViewReuseIdentifier: RecipesSearchHeaderView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    private func fillTitleNavigation(index: Int) {
        switch index {
        case 0:
            selectedTitle = "Завтрак"
        case 1:
            selectedTitle = "Обед"
        case 2:
            selectedTitle = "Ужин"
        case 3:
            selectedTitle = "Перекус"
        default:
            break
        }
        titleButton.setTitle("\(selectedTitle)  ", for: .normal)
    }
}

extension ProductAddingOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductAddingOptionsCell") as? ProductAddingOptionsCell {
            cell.fillCell(indexPath)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? MenuCell else { fatalError() }
            cell.fillCell(indexPath, selectedTitle: self.selectedTitle)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let first = tableView.visibleCells.first, let _ = first as? MenuCell {
            for (index, item) in tableView.visibleCells.enumerated() {
                if let cell = item as? MenuCell {
                    if index == indexPath.row {
                        cell.radioButton.isOn = true
                        fillTitleNavigation(index: indexPath.row)
                    } else {
                        cell.radioButton.isOn = false
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecipesSearchHeaderView.reuseIdentifier) as? RecipesSearchHeaderView else {
            return nil
        }
        //header.fillHeader(delegate: self)
        header.textField.placeholder = "Поиск"
        header.textField.tintColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecipesSearchHeaderView.reuseIdentifier) as? RecipesSearchHeaderView else {
            return 0.0001
        }
        return RecipesSearchHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}

// MARK: - LMDropdownViewDelegate
extension ProductAddingOptionsViewController: LMDropdownViewDelegate {
    
    func showDropdownView(fromDirection direction: LMDropdownViewDirection) {
        
        guard let navigationController = navigationController else { return }
        
        // Customize Dropdown style
        dropdownView.direction = direction
        
        // Show/hide dropdown view
        if dropdownView.isOpen {
            dropdownView.hide()
        }
        else {
            switch direction {
            case .top:
                dropdownView.contentBackgroundColor = UIColor(red: 40.0/255, green: 196.0/255, blue: 80.0/255, alpha: 1)
                dropdownView.show(menuTableView, containerView: listContainerView)
            case .bottom:
                dropdownView.contentBackgroundColor = .white
//                let origin = CGPoint(x: 0, y: navigationController.view.bounds.height - moreBottomView.bounds.height)
//                dropdownView.show(moreBottomView, inView: navigationController.view, origin: origin)
            }
        }
    }
    
    func dropdownViewWillShow(_ dropdownView: LMDropdownView) {
        titleButton.setImage(#imageLiteral(resourceName: "Polygon (2)"), for: .normal)
    }
    
    func dropdownViewDidShow(_ dropdownView: LMDropdownView) {
        listContainerView.isUserInteractionEnabled = true
        NSLog("Dropdown view did show")
    }
    
    func dropdownViewWillHide(_ dropdownView: LMDropdownView) {
        //
    }
    
    func dropdownViewDidHide(_ dropdownView: LMDropdownView) {
        titleButton.setImage(#imageLiteral(resourceName: "Polygon (1)"), for: .normal)
        listContainerView.isUserInteractionEnabled = false
        NSLog("Dropdown view did hide")
    }
}
