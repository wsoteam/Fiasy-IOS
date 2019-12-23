//
//  DiaryViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import Parchment
import Amplitude_iOS
import DynamicBlurView
import Amplitude_iOS
import UserNotifications
import GradientProgressBar
import VisualEffectView

protocol DiaryViewDelegate {
    func reloadMealtime()
    func replaceMeasuringList(list: [Measuring])
    func openMeasuringScreen()
    func stopProgress()
    func showWaterDetails()
    func editMealTime(mealTime: Mealtime)
    func removeMealTime()
    func removeActivity()
    func showProducts()
    func reloadAfterRemoveActivity()
}

class DiaryViewController: UIViewController {
    
    //MARK: - Outlets -
    @IBOutlet var weekLabels: [UILabel]!
    @IBOutlet weak var topTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabTitleLable: UILabel!
    @IBOutlet weak var intercomButton: UIButton!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var blurView: VisualEffectView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateStackView: UIStackView!
    @IBOutlet weak var mountLabel: UILabel!
    @IBOutlet var dateLabels: [UILabel]!
    
    // MARK: - Properties -
    private var selectedDate: Date = Date()
    private var waterCount: Double =  UserInfo.sharedInstance.currentUser?.maxWater ?? 2.0
    private let isIphone5 = Display.typeIsLike == .iphone5
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    lazy var currentCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone(name: "GMT")! as TimeZone
        return calendar
    }()

    lazy var picker: DiaryClickedPicker = {
        let picker = DiaryClickedPicker()
        picker.changeDate = { [weak self] in
            guard let `self` = self else { return }
            let date = UserInfo.sharedInstance.selectedDate ?? Date()
            self.calendarView.toggleViewWithDate(date)
            self.displayManager.changeDate(self.mountLabel, date)
            self.selectedDate = date
            self.setupTopContainer(date: self.selectedDate)
        }
        picker.closeAction = { [weak self] in
            guard let `self` = self else { return }
        }
        return picker
    }()
    
    lazy var displayManager: DiaryDisplayManager = {
        return DiaryDisplayManager(tableView, self, topView)
    }()
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localizeScreen()
        calendarView.commitCalendarViewUpdate()
        setupInitialState()
        getItemsInDataBase()
        UserInfo.sharedInstance.selectedDate = Date()
        
        if let email = UserInfo.sharedInstance.currentUser?.email {
            let identify = AMPIdentify()
            identify.set("email", value: email as NSObject)
            Amplitude.instance()?.identify(identify)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = UserInfo.sharedInstance.currentUser, let count = user.maxWater, self.waterCount != count {
            self.waterCount = count
            displayManager.reloadWater()
        }

        registerForRemoteNotification()
        if UserInfo.sharedInstance.isReload {
            UserInfo.sharedInstance.isReload = false
            getItemsInDataBase()
        }
        addObserver(for: self, #selector(showProductDetails), Constant.SHOW_PRODUCT_LIST)
        addObserver(for: self, #selector(reloadDiary), Constant.RELOAD_DIARY)

        if UserInfo.sharedInstance.reloadDiariContent {
            UserInfo.sharedInstance.reloadDiariContent = false
            getItemsInDataBase()
        }
        
        if UserInfo.sharedInstance.reloadActiveContent {
            UserInfo.sharedInstance.reloadActiveContent = false
            getActivitysInDataBase()
        }
        
        intercomButton.isHidden = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    @objc func showProductDetails() {
        performSegue(withIdentifier: "sequeProductsList", sender: nil)
    }
    
    @objc func reloadDiary() {
        getItemsInDataBase()
    }
    
    func getItemsInDataBase() {
        FirebaseDBManager.getMealtimeItemsInDataBase { [weak self] (error) in
            guard let `self` = self else { return }
            DispatchQueue.main.async(execute: {
                self.displayManager.changeDate(self.mountLabel, self.selectedDate)
                self.displayManager.changeNewDate(date: self.selectedDate)
                self.getActivitysInDataBase()
                FirebaseDBManager.fetchWaterItemsInDataBase { [weak self] (error) in
                    guard let `self` = self else { return }
                    self.displayManager.reloadWater()
                }
                self.reloadMeaseringList()
                self.post("reloadContent")
            })
        }
    }
    
    private func getActivitysInDataBase() {
        FirebaseDBManager.fetchDiaryActivityInDataBase { [weak self] (list) in
            guard let strongSelf = self else { return }
            strongSelf.displayManager.reloadActivity(list, selectedDate: strongSelf.selectedDate)
        }
    }
    
    private func localizeScreen() {
        tabTitleLable.text = LS(key: .TAB_TITLE1)
        for (index, item) in weekLabels.enumerated() {
            item.text = LS_WEEK(index: index)
        }
    }
    
    func reloadMeaseringList() {
        FirebaseDBManager.fetchMyMeasuringInDataBase { [weak self] (list) in
            guard let strongSelf = self else { return }
            strongSelf.displayManager.reloadMeasuringsContent(allMeasurings: list)
            if !strongSelf.tableView.visibleCells.isEmpty {
                UIView.performWithoutAnimation {
                    strongSelf.tableView.reloadSections(IndexSet(integer: 6), with: .none)
                }
            }
        }
    }
    
    private func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil {
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }
                
                let identify = AMPIdentify()
                identify.set("push_enabled", value: granted as NSObject)
                Amplitude.instance()?.identify(identify)
            }
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // MARK: - Actions -
    @IBAction func calendarClicked(_ sender: Any) {
        picker.showDatePicker(date: self.selectedDate)
    }
    
    @IBAction func showChatIntercom(_ sender: Any) {
        Amplitude.instance()?.logEvent("intercom_chat") // +
    }
    
    // MARK: - Private -
    private func setupInitialState() {
        blurView.colorTint = .gray
        blurView.colorTintAlpha = 0.1
        blurView.blurRadius = 5
        blurView.scale = 1
        
        activity.startAnimating()
        
        if isIphone5 {
            topTitleConstraint.constant = 0.0
            tabTitleLable.font = tabTitleLable.font.withSize(25)
        }
    }
    
    private func fillTitleNavigation() -> String {
        switch UserInfo.sharedInstance.selectedMealtimeIndex {
        case 0:
            return LS(key: .BREAKFAST)
        case 1:
            return LS(key: .LUNCH)
        case 2:
            return LS(key: .DINNER)
        case 3:
            return LS(key: .SNACK)
        default:
            return ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EditActivityViewController, let model = sender as? ActivityElement {
            vc.fillScreenByModel(model)
        } else if let vc = segue.destination as? MeasuringViewController {
            vc.delegate = self
        } else if let vc = segue.destination as? ProductAddingOptionsViewController {
            vc.diaryDelegate = self
        } else if let vc = segue.destination as? ProductDetailsViewController {
            if let model = sender as? Mealtime {
                vc.fillSelectedProduct(product: Product(mealtime: model), title: fillTitleNavigation(), basketProduct: false)
            }
        }
    }
}

extension DiaryViewController: DiaryViewDelegate {
    
    func reloadMealtime() {
        getItemsInDataBase()
    }
    
    func replaceMeasuringList(list: [Measuring]) {
        displayManager.reloadMeasuringsContent(allMeasurings: list)
        if !tableView.visibleCells.isEmpty {
            UIView.performWithoutAnimation {
                tableView.reloadSections(IndexSet(integer: 7), with: .none)
            }
        }
    }
    
    func openMeasuringScreen() {
        performSegue(withIdentifier: "sequeMeasuringScreen", sender: nil)
    }
    
    func removeActivity() {
        let alert = UIAlertController(title: LS(key: .ATTENTION), message: LS(key: .ACTIVITY_REMOVE_ALERT), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LS(key: .ALERT_YES), style: .default, handler: { action in
            self.displayManager.removeActivity()
            self.getItemsInDataBase()
        }))
        alert.addAction(UIAlertAction(title: LS(key: .ALERT_NO), style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func reloadAfterRemoveActivity() {
        getItemsInDataBase()
    }
    
    func showWaterDetails() {
        performSegue(withIdentifier: "sequeWaterDetailsScreen", sender: nil)
    }
    
    func stopProgress() {
        activityView.isHidden = true
        self.activity.stopAnimating()
    }
    
    func showProducts() {
        performSegue(withIdentifier: "sequeProductsList", sender: nil)
    }
    
    func removeMealTime() {
        let alert = UIAlertController(title: LS(key: .ATTENTION), message: LS(key: .ALERT_CONFIRM2), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LS(key: .ALERT_YES), style: .default, handler: { action in
            Amplitude.instance().logEvent("delete_food") // +
            self.displayManager.removeMealTime()
            self.getItemsInDataBase()
        }))
        alert.addAction(UIAlertAction(title: LS(key: .ALERT_NO), style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func editMealTime(mealTime: Mealtime) {
        performSegue(withIdentifier: "sequeEditScreen", sender: mealTime)
    }
}

extension DiaryViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    func firstWeekday() -> Weekday { return .monday }
    func presentationMode() -> CalendarMode { return .weekView }
    func calendar() -> Calendar? { return currentCalendar }
    func shouldShowWeekdaysOut() -> Bool { return true }
    
    func presentedDateUpdated(_ date: CVDate) {
        UserInfo.sharedInstance.selectedDate = date.date
        self.selectedDate = UserInfo.sharedInstance.selectedDate ?? Date()
        self.setupTopContainer(date: self.selectedDate)
        self.displayManager.changeDate(self.mountLabel, date.date)
    }
    
    func didShowNextWeekView(from startDayView: DayView, to endDayView: DayView) {
        let selected = UserInfo.sharedInstance.selectedDate ?? Date()
        for item in startDayView.date.date.getWeekDates() where Calendar.current.component(.day, from: item) == Calendar.current.component(.day, from: selected) && Calendar.current.component(.year, from: item) == Calendar.current.component(.year, from: selected) && Calendar.current.component(.month, from: item) == Calendar.current.component(.month, from: selected) {
            self.displayManager.changeDate(self.mountLabel, selected)
            return
        }
        if startDayView.date.month != endDayView.date.month {
            if endDayView.date.day > 3 {
                self.displayManager.changeDate(self.mountLabel, endDayView.date.date)
            } else {
                self.displayManager.changeDate(self.mountLabel, startDayView.date.date)
            }
        } else {
            self.displayManager.changeDate(self.mountLabel, startDayView.date.date)
        }
    }
    
    func didShowPreviousWeekView(from startDayView: DayView, to endDayView: DayView) {
        let selected = UserInfo.sharedInstance.selectedDate ?? Date()
        for item in startDayView.date.date.getWeekDates() where Calendar.current.component(.day, from: item) == Calendar.current.component(.day, from: selected) && Calendar.current.component(.year, from: item) == Calendar.current.component(.year, from: selected) && Calendar.current.component(.month, from: item) == Calendar.current.component(.month, from: selected) {
            self.displayManager.changeDate(self.mountLabel, selected)
            return
        }
        if startDayView.date.month != endDayView.date.month {
            if endDayView.date.day > 3 {
                self.displayManager.changeDate(self.mountLabel, endDayView.date.date)
            } else {
                self.displayManager.changeDate(self.mountLabel, startDayView.date.date)
            }
        } else {
            self.displayManager.changeDate(self.mountLabel, startDayView.date.date)
        }
    }
}

extension DiaryViewController: CVCalendarViewAppearanceDelegate {
    
    func dayLabelWeekdayDisabledColor() -> UIColor { return .lightGray }
    
    func dayLabelPresentWeekdayInitallyBold() -> Bool { return false }
    
    func spaceBetweenDayViews() -> CGFloat { return 0 }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont.sfProTextSemibold(size: 15) }
    
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .selected, _), (_, .highlighted, _): return .white
        default: return #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)
        }
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = #colorLiteral(red: 0.8900639415, green: 0.8978396654, blue: 0.9144185185, alpha: 1)
        return circleView
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent, isCurrentDay: Bool) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .selected, _), (_, .highlighted, _): return #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.1524507934, alpha: 1)
        default: return .clear
        }
    }
}
