//
//  DateOfBirthSelectionCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/25/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS

class DateOfBirthSelectionCell: UICollectionViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectedDataLabel: UILabel!
    
    // MARK: - Properties -
    private var delegate: QuizViewOutput?
    private let isIphone5 = Display.typeIsLike == .iphone5
    lazy var mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        switch Locale.current.languageCode {
        case "es":
            // испанский
            formatter.locale = Locale(identifier: "es_ES")
        case "pt":
            // португалия (бразилия)
            formatter.locale = Locale(identifier: "pt_BR")
        case "en":
            // английский
            formatter.locale = Locale(identifier: "en_US")
        case "de":
            // немецикий
            formatter.locale = Locale(identifier: "de_DE")
        default:
            // русский
            formatter.locale = Locale(identifier: "ru_RU")
        }       
        return formatter
    }()
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupInitialState()
        datePicker.maximumDate = Date()
        Amplitude.instance()?.logEvent("question_next", withEventProperties: ["question" : "age"]) // +
    }
    
    // MARK: - Interface -
    func fillCell(delegate: QuizViewOutput) {
        self.delegate = delegate
        
        delegate.changeTitle(title: LS(key: .SELECT_YOUR_BIRTHDAY))
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
        switch Locale.current.languageCode {
        case "es":
            // испанский
            datePicker.locale = Locale(identifier: "es_ES")
        case "pt":
            // португалия (бразилия)
            datePicker.locale = Locale(identifier: "pt_BR")
        case "en":
            // английский
            datePicker.locale = Locale(identifier: "en_US")
        case "de":
            // немецикий
            datePicker.locale = Locale(identifier: "de_DE")
        default:
            // русский
            datePicker.locale = Locale(identifier: "ru_RU")
        } 
    }
    
    // MARK: - Actions -
    @IBAction func changeValuePicker(_ sender: UIDatePicker) {
        delegate?.changeStateNextButton(state: true)
        UserInfo.sharedInstance.registrationFlow.dateOfBirth = datePicker.date
        selectedDataLabel.text = mediumDate.string(from: datePicker.date).replacingOccurrences(of: LS(key: .YEAR_SHORT), with: LS(key: .YEAR))
    }
}
