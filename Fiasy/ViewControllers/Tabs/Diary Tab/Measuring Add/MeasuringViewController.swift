//
//  MeasuringViewController.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 10/22/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol MeasuringDelegate {
    func showPremiumScreen()
    func addPremiumMeasuring(tag: Int, measuring: Measuring?)
    func showPicker(date: Date, measuring: Measuring?)
    func showMiddleWeightDescriptionScreen()
}

class MeasuringViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var selectedPicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet weak var progressTitleLabel: UILabel!
    @IBOutlet weak var progressView: CircularProgress!
    
    // MARK: - Properties -
    var delegate: DiaryViewDelegate?
    private var selectedDate: Date?
    private var isPremiumPicker: Bool = false
    private var premiumTag: Int = 0
    private var selectedMeasuring: Measuring?
    private var allMeasurings: [Measuring] = []
    private var pickerData: [[String]] = []
    private var pickerPremiumData: [[String]] = []

    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()

        showActivity()
        fetchMeasuring()
        setupPickerView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PremiumQuizViewController {
            let vc = segue.destination as? PremiumQuizViewController
            vc?.isAutorization = false
            vc?.trialFrom = "body_measurements"
        }
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.register(type: MeasuringTableViewCell.self)
        tableView.register(type: MeasuringPremiumTableViewCell.self)
        tableView.register(MeasuringHeaderView.nib, forHeaderFooterViewReuseIdentifier: MeasuringHeaderView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    private func setupPickerView() {
        var leftSide: [String] = []
        var secondLeftSide: [String] = []
        for index in 1...200 {
            leftSide.append("\(index) кг")
            secondLeftSide.append("\(index) см")
        }
        var rightSide: [String] = []
        var secondRightSide: [String] = []
        for index in 0...9 {
            rightSide.append("\(index * 100) гр")
            secondRightSide.append("\(index) мм")
        }
        pickerData.append(leftSide)
        pickerData.append(rightSide)
        
        pickerPremiumData.append(secondLeftSide)
        pickerPremiumData.append(secondRightSide)
        
        self.selectedPicker.delegate = self
        self.selectedPicker.dataSource = self
    }
    
    private func showActivity() {
        activityView.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivity() {
        activityView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showProgress(title: String) {
        progressTitleLabel.text = title
        progressView.trackColor = .clear
        progressView.progressColor = #colorLiteral(red: 0.9344636798, green: 0.5902308822, blue: 0.1663158238, alpha: 1)
        progressContainerView.fadeIn(duration: 0.0)
        
        progressView.setProgressWithAnimation(duration: 2, value: 2) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.progressContainerView.fadeOut(duration: 0.0)
        }
    }
    
    private func fetchMeasuring() {
        FirebaseDBManager.fetchMyMeasuringInDataBase { [weak self] (list) in
            guard let strongSelf = self else { return }
            strongSelf.allMeasurings = list
            strongSelf.setupTableView()
            strongSelf.hideActivity()
        }
    }
    
    private func closePicker() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.pickerContainerView.frame = CGRect(x: 0, y: self.view.bounds.size.height, width: UIScreen.main.bounds.width, height: self.pickerContainerView.bounds.size.height)
        }) { (state) in
            if let background = self.pickerContainerView.superview {
                background.fadeOut()
            }
        }
    }
    
    // MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closePickerClicked(_ sender: Any) {
        closePicker()
    }
    
    @IBAction func addMeasuringClicked(_ sender: Any) {
        guard let value = Double("\(selectedPicker.selectedRow(inComponent: 0) + 1).\(selectedPicker.selectedRow(inComponent: 1))") else { return }
        if isPremiumPicker {
            var type: MeasuringType = .chest
            var title: String = "Грудь обновленна"
            if premiumTag == 1 {
                type = .waist
                title = "Талия обновленна"
            } else if premiumTag == 2 {
                type = .hips
                title = "Бедра обновленны"
            }
            FirebaseDBManager.addMeasuring(date: Date(), measuring: self.selectedMeasuring, weight: value, type: type) { [weak self] (result) in
                guard let strongSelf = self else { return }
                strongSelf.closePicker()         
                if let measuring = strongSelf.selectedMeasuring {
                    strongSelf.showProgress(title: title)
                    for (index, item) in strongSelf.allMeasurings.enumerated() where item.generalKey == measuring.generalKey {
                        strongSelf.allMeasurings[index].weight = value
                        break
                    }
                } else {
                    strongSelf.allMeasurings.append(result)
                }
                strongSelf.selectedMeasuring = nil
                strongSelf.tableView.reloadRows(at: [IndexPath(row: strongSelf.premiumTag, section: 1)], with: .none)
            }
        } else {
            guard let date = self.selectedDate else { return }
            FirebaseDBManager.addMeasuring(date: date, measuring: self.selectedMeasuring, weight: value, type: .weight) { [weak self] (result) in
                guard let strongSelf = self else { return }
                strongSelf.closePicker()
                if let measuring = strongSelf.selectedMeasuring {
                    strongSelf.showProgress(title: "Вес обновлен")
                    for (index, item) in strongSelf.allMeasurings.enumerated() where item.generalKey == measuring.generalKey {
                        strongSelf.allMeasurings[index].weight = value
                    }
                    if let cell = strongSelf.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MeasuringTableViewCell {
                        cell.updatePresent(allMeasurings: strongSelf.allMeasurings)
                    }
                } else {
                    strongSelf.allMeasurings.append(result)
                    if let cell = strongSelf.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MeasuringTableViewCell {
                        cell.updatePresent(allMeasurings: strongSelf.allMeasurings)
                    }
                }
                strongSelf.selectedMeasuring = nil
                strongSelf.delegate?.replaceMeasuringList(list: strongSelf.allMeasurings)
            }
        }
    }
    
    @IBAction func removeMeasuringClicked(_ sender: Any) {
        guard let measuring = self.selectedMeasuring else { return }
        FirebaseDBManager.removeMeasuring(measuring: measuring, type: .weight) {  [weak self] in
            guard let strongSelf = self else { return }
            for (index,item) in strongSelf.allMeasurings.enumerated() where item.generalKey == measuring.generalKey {
                strongSelf.closePicker()
                strongSelf.showProgress(title: "Вес удален")                
                strongSelf.selectedMeasuring = nil
                strongSelf.allMeasurings.remove(at: index)
                strongSelf.delegate?.replaceMeasuringList(list: strongSelf.allMeasurings)
                if let cell = strongSelf.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MeasuringTableViewCell {
                    cell.updatePresent(allMeasurings: strongSelf.allMeasurings)
                }
            }
        }
    }
}

extension MeasuringViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MeasuringTableViewCell") as? MeasuringTableViewCell else { fatalError() }
            cell.fillCell(delegate: self, allMeasurings: allMeasurings)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MeasuringPremiumTableViewCell") as? MeasuringPremiumTableViewCell else { fatalError() }
            cell.fillCell(index: indexPath.row, delegate: self, allMeasurings: allMeasurings)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MeasuringHeaderView.reuseIdentifier) as? MeasuringHeaderView else {
            return nil
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.00001 : MeasuringHeaderView.height
    }
}

extension MeasuringViewController: MeasuringDelegate {
    
    func addPremiumMeasuring(tag: Int, measuring: Measuring?) {
        isPremiumPicker = true
        premiumTag = tag
        selectedPicker.reloadAllComponents()
        self.selectedMeasuring = measuring
        self.removeButton.isHidden = true
        UIView.animate(withDuration: 0.3) { 
            if let background = self.pickerContainerView.superview {
                background.fadeIn()
            }
            self.pickerContainerView.frame = CGRect(x: 0, y: self.view.bounds.size.height - self.pickerContainerView.bounds.size.height, width: UIScreen.main.bounds.width, height: self.pickerContainerView.bounds.size.height)
        }
    }
    
    func showPremiumScreen() {
        performSegue(withIdentifier: "sequePremiumScreen", sender: nil)
    }
    
    func showPicker(date: Date, measuring: Measuring?) {
        isPremiumPicker = false
        selectedPicker.reloadAllComponents()
        
        self.selectedDate = date
        self.selectedMeasuring = measuring
        if let _ = measuring {
            self.removeButton.isHidden = false
        } else {
            self.removeButton.isHidden = true
        }
        UIView.animate(withDuration: 0.3) { 
            if let background = self.pickerContainerView.superview {
                background.fadeIn()
            }
            self.pickerContainerView.frame = CGRect(x: 0, y: self.view.bounds.size.height - self.pickerContainerView.bounds.size.height, width: UIScreen.main.bounds.width, height: self.pickerContainerView.bounds.size.height)
        }
    }
    
    func showMiddleWeightDescriptionScreen() {
        performSegue(withIdentifier: "sequeMiddleWeightDescription", sender: nil)
    }
}

extension MeasuringViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return isPremiumPicker ? pickerPremiumData.count : pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return isPremiumPicker ? pickerPremiumData[component].count : pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return isPremiumPicker ? pickerPremiumData[component][row] : pickerData[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return UIScreen.main.bounds.width/3
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.text = isPremiumPicker ? pickerPremiumData[component][row] : pickerData[component][row]
        pickerLabel.font = UIFont.sfProTextRegular(size: 19)
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
}
