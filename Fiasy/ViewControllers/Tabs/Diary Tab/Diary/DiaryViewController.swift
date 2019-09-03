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
import Intercom
import Amplitude_iOS
import UserNotifications
import GradientProgressBar
import VisualEffectView

protocol DiaryViewDelegate {
    func stopProgress()
    func editMealTime()
    func removeMealTime()
    func showProducts()
}

class DiaryViewController: BaseViewController {
    
    //MARK: - Outlets -
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
        
        setupInitialState()
        getItemsInDataBase()
        UserInfo.sharedInstance.selectedDate = Date()
        Amplitude.instance().logEvent("view_diary")
        
        var state: Bool = false
        if let _ = UserInfo.sharedInstance.currentUser?.email {
            state = true
        }
        
        let identify = AMPIdentify()
        identify.set("email", value: state as NSObject)
        Amplitude.instance()?.identify(identify)
        
        let attributed = ICMUserAttributes()
        attributed.customAttributes = ["email": state]
        Intercom.updateUser(attributed)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        registerForRemoteNotification()
        if UserInfo.sharedInstance.isReload {
            UserInfo.sharedInstance.isReload = false
            getItemsInDataBase()
        }
        addObserver(for: self, #selector(showProductDetails), Constant.SHOW_PRODUCT_LIST)
        addObserver(for: self, #selector(reloadDiary), Constant.RELOAD_DIARY)

        if UserInfo.sharedInstance.allProducts.isEmpty {
            SQLDatabase.shared.fetchProducts()
        }
        
        if UserInfo.sharedInstance.reloadDiariContent {
            UserInfo.sharedInstance.reloadDiariContent = false
            getItemsInDataBase()
        }
        
        if let _ = Auth.auth().currentUser?.uid {
            intercomButton.isHidden = false
        }
        getItemsInDataBase()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
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
    
    private func getItemsInDataBase() {
        FirebaseDBManager.getMealtimeItemsInDataBase { [weak self] (error) in
            guard let `self` = self else { return }
            DispatchQueue.main.async(execute: {
                self.displayManager.changeDate(self.mountLabel, self.selectedDate)
                self.displayManager.changeNewDate(date: self.selectedDate)
                self.post("reloadContent")
            })
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
                
                let attributed = ICMUserAttributes()
                attributed.customAttributes = ["push_enabled": granted]
                Intercom.updateUser(attributed)
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
        Intercom.logEvent(withName: "intercom_chat") //
        Amplitude.instance()?.logEvent("intercom_chat") //
        Intercom.presentMessenger()
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
}

extension DiaryViewController: DiaryViewDelegate {
    
    func stopProgress() {
        activityView.isHidden = true
        self.activity.stopAnimating()
    }
    
    func showProducts() {
        performSegue(withIdentifier: "sequeProductsList", sender: nil)
    }
    
    func removeMealTime() {
        let alert = UIAlertController(title: "Внимание", message: "Вы уверены, что хотите удалить продукт?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            Amplitude.instance().logEvent("delete_food") //
            Intercom.logEvent(withName: "delete_food") //
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
        case (.sunday, .in, _): return #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)
        case (.sunday, _, _): return #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)
        case (_, .in, _): return #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)
        default: return #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)
        }
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        //case (_, .selected, _), (_, .highlighted, _): return .clear
        case (_, .selected, _), (_, .highlighted, _): return #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.1524507934, alpha: 1)
        default: return nil
        }
    }
}
