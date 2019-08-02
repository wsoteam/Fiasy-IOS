//
//  DateOfBirthSelectionCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/25/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class DateOfBirthSelectionCell: UICollectionViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectedDataLabel: UILabel!
    
    // MARK: - Properties -
    private var delegate: QuizViewOutput?
    private let isIphone5 = Display.typeIsLike == .iphone5
    lazy var mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        
        return formatter
    }()
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupInitialState()
        datePicker.maximumDate = Date()
    }
    
    // MARK: - Interface -
    func fillCell(delegate: QuizViewOutput) {
        self.delegate = delegate
        
        delegate.changeTitle(title: "Выберите дату рождения")
        delegate.changeStateBackButton(hidden: false)
        delegate.changePageControl(index: 3)
        
        if let _ = UserInfo.sharedInstance.registrationFlow.dateOfBirth {
            delegate.changeStateNextButton(state: true)
        } else {
            delegate.changeStateNextButton(state: false)
        }
    }
    
    // MARK: - Private -
    private func setupInitialState() {
        datePicker.locale = Locale(identifier: "ru_RU")
    }
    
    // MARK: - Actions -
    @IBAction func changeValuePicker(_ sender: UIDatePicker) {
        delegate?.changeStateNextButton(state: true)
        UserInfo.sharedInstance.registrationFlow.dateOfBirth = datePicker.date
        selectedDataLabel.text = mediumDate.string(from: datePicker.date).replacingOccurrences(of: "г.", with: "год")
    }
}
