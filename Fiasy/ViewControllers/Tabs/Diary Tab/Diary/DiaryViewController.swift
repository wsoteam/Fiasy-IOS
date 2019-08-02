//
//  DiaryViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Parchment
import Amplitude_iOS
import DynamicBlurView
import GradientProgressBar

protocol DiaryViewDelegate {
    func editMealTime()
    func removeMealTime()
}

class DiaryViewController: BaseViewController {
    
    //MARK: - Outlets -
    @IBOutlet weak var endedLabel: UILabel!
    @IBOutlet weak var eatenCaloriesLabel: UILabel!
    @IBOutlet weak var daysCountLabel: UILabel!
    @IBOutlet weak var addProductButton: UIButton!
    @IBOutlet weak var caloriesProgress: GradientProgressBar!
    @IBOutlet weak var proteinProgress: GradientProgressBar!
    @IBOutlet weak var fatProgress: GradientProgressBar!
    @IBOutlet weak var carbohydratesProgress: GradientProgressBar!
    @IBOutlet weak var carbohydratesCountLabel: UILabel!
    @IBOutlet weak var caloriesCountLabel: UILabel!
    @IBOutlet weak var fatCountLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scorchedLabel: UILabel!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var emptyBlurView: DynamicBlurView!
    @IBOutlet weak var blurView: DynamicBlurView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var mountLabel: UILabel!
    @IBOutlet var dateLabels: [UILabel]!
    @IBOutlet weak var eatenLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    
    //MARK: - Properties -
    private var selectedDate: Date = Date()
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    lazy var picker: DiaryClickedPicker = {
        let picker = DiaryClickedPicker()
        
        picker.changeDate = { [weak self] in
            guard let `self` = self else { return }
            self.selectedDate = UserInfo.sharedInstance.selectedDate ?? Date()
            self.setupTopContainer(date: self.selectedDate)
            self.displayManager.changeDate(self.mountLabel, self.dateLabels, self.selectedDate)
            self.blurView.alpha = 0
        }
        
        picker.closeAction = { [weak self] in
            guard let `self` = self else { return }
            self.blurView.alpha = 0
        }
        return picker
    }()
    
    lazy var displayManager: DiaryDisplayManager = {
        return DiaryDisplayManager(tableView: tableView, delegate: self, emptyBlurView, addProductButton)
    }()
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
        getItemsInDataBase()
        UserInfo.sharedInstance.selectedDate = Date()
        Amplitude.instance().logEvent("view_diary")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserInfo.sharedInstance.isReload {
            UserInfo.sharedInstance.isReload = false
            getItemsInDataBase()
        }
        addObserver(for: self, #selector(showProductDetails), Constant.SHOW_PRODUCT_LIST)
        addObserver(for: self, #selector(reloadDiary), Constant.RELOAD_DIARY)

        if UserInfo.sharedInstance.allProducts.isEmpty {
            SQLDatabase.shared.fetchProducts()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
        emptyBlurView.trackingMode = .none
    }
    
    @objc func showProductDetails() {
        emptyBlurView.trackingMode = .none
        performSegue(withIdentifier: "sequeProductsList", sender: nil)
    }
    
    @objc func reloadDiary() {
        getItemsInDataBase()
    }
    
    private func getItemsInDataBase() {
        FirebaseDBManager.getMealtimeItemsInDataBase { [weak self] (error) in
            guard let `self` = self else { return }
            DispatchQueue.main.async(execute: {
                UserInfo.sharedInstance.getDateCount { [weak self] count in
                    guard let `self` = self else { return }
                    self.daysCountLabel.text = "\(count)"
                    self.setupTopContainer(date: self.selectedDate)
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    //MARK: - Actions -
    @IBAction func calendarClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.blurView.alpha = 1
        }
        picker.showDatePicker(date: self.selectedDate)
    }
    
    //MARK: - Private -
    private func setupInitialState() {
        blurView.blurRadius = 3
        blurView.trackingMode = .common
        blurView.quality = .high
        emptyBlurView.blurRadius = 10
        emptyBlurView.trackingMode = .common
        
        activity.startAnimating()
        displayManager.changeDate(mountLabel, dateLabels, Date())
        setupProgres(progress: caloriesProgress)
        setupProgres(progress: proteinProgress)
        setupProgres(progress: fatProgress)
        setupProgres(progress: carbohydratesProgress)
    }
    
    private func setupProgres(progress: GradientProgressBar) {
        progress.backgroundColor = #colorLiteral(red: 0.1235194579, green: 0.338282913, blue: 0.3184858859, alpha: 1)
        progress.gradientColorList = [#colorLiteral(red: 0.9965590835, green: 0.8556515574, blue: 0.3924552202, alpha: 1), #colorLiteral(red: 0.9693543315, green: 0.7608024478, blue: 0.2990708947, alpha: 1), #colorLiteral(red: 0.8953430057, green: 0.5070293546, blue: 0.04407442361, alpha: 1)]
    }
}

extension DiaryViewController: DiaryViewDelegate {
    
    func removeMealTime() {
        let alert = UIAlertController(title: "Внимание", message: "Вы уверены, что хотите удалить продукт?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            self.displayManager.removeMealTime()
            self.getItemsInDataBase()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func editMealTime() {
        performSegue(withIdentifier: "sequeEditScreen", sender: nil)
    }
}
