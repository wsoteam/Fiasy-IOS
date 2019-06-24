//
//  DiaryClickedPicker.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class DiaryClickedPicker: NSObject, UINavigationControllerDelegate {
    
    var targetVC: UIViewController?
    
    internal var removeMealtime: (() -> Void)?
    internal var saveDate: ((Date) -> Void)?
    internal var changeDate: (() -> Void)?
    internal var closeAction: (() -> Void)?
    
    func showPicker() {
        guard let target = targetVC else { return }
        
        let refreshAlert = UIAlertController(title: nil,
                                        message: nil,
                                 preferredStyle: .actionSheet)
        

        refreshAlert.addAction(UIAlertAction(title: "Удалить",
                                          style: .default,
                                        handler: { [weak self] _ in
                                                guard let `self` = self else { return }
                                                self.removeMealtime?()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        target.present(refreshAlert, animated: true)
    }
}

extension DiaryClickedPicker {
    
    func showDatePicker(date: Date) {
        let alert = UIAlertController(style: .actionSheet, title: "", message: "")
        alert.addDatePicker(mode: .date, date: date, minimumDate: nil, maximumDate: Date()) { date in
            UserInfo.sharedInstance.selectedDate = date
        }
        
        alert.addAction(UIAlertAction(title: "Применить",
                                   style: .default,
                                 handler: { [weak self] _ in
                                        guard let `self` = self else { return }
                                        self.changeDate?()
        }))

        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: { [weak self]
            action in
            guard let `self` = self else { return }
            self.closeAction?()
        }))
        
        alert.show()
    }
}

extension UIAlertController {
    
    func addDatePicker(mode: UIDatePicker.Mode, date: Date?, minimumDate: Date? = nil, maximumDate: Date? = nil, action: DatePickerViewController.Action?) {
        let datePicker = DatePickerViewController(mode: mode, date: date, minimumDate: minimumDate, maximumDate: maximumDate, action: action)
        
        set(vc: datePicker, height: 200)
    }
}

final class DatePickerViewController: UIViewController {
    
    public typealias Action = (Date) -> Void
    
    fileprivate var action: Action?
    
    fileprivate lazy var datePicker: UIDatePicker = { [unowned self] in
        $0.addTarget(self, action: #selector(DatePickerViewController.actionForDatePicker), for: .valueChanged)
        return $0
        }(UIDatePicker())
    
    required init(mode: UIDatePicker.Mode, date: Date? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, action: Action?) {
        super.init(nibName: nil, bundle: nil)
        datePicker.datePickerMode = mode
        
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.timeZone = TimeZone(abbreviation: "GMT")!
        datePicker.setDate(date ?? Date(), animated: false)
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = Date()
        UserInfo.sharedInstance.selectedDate = date ?? Date()
        self.action = action
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = datePicker
    }
    
    @objc func actionForDatePicker() {
        action?(datePicker.date)
    }
    
    public func setDate(_ date: Date) {
        datePicker.setDate(date, animated: true)
    }
}
