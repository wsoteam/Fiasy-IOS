//
//  AddActivityTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 9/12/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import NextGrowingTextView

class AddActivityTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var thirdDescriptionLabel: UILabel!
    @IBOutlet weak var thirdTitleLabel: UILabel!
    @IBOutlet weak var secondDescriptionLabel: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var titleDescriptionLabel: UILabel!
    @IBOutlet weak var customSlider: TGPDiscreteSlider!
    @IBOutlet weak var caloriesFieldWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var growingTextView: NextGrowingTextView!
    
    // MARK: - Properties -
    private var time: Int = 15
    private var selectedState: CGFloat = 0.0
    private var selectedValue: Double = 0.0
    private var delegate: AddActivityUIDelegate?
    
    // MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSlider()
        fillSecondTimeCount(time: "15")
        customSlider.value = selectedState
        growingTextView.configureSecondGrowingTextView()
        growingTextView.textView.delegate = self
        
        titleDescriptionLabel.text = LS(key: .ADD_NAME_ACTIVITIE)
        secondTitleLabel.text = LS(key: .TRAINING_TIME)
        secondDescriptionLabel.text = LS(key: .TRAINING_TIME_DESCRIPTION)
        thirdTitleLabel.text = LS(key: .CALORIES_COUNT)
        thirdDescriptionLabel.text = LS(key: .CALORIES_COUNT_DESCRIPTION)
        caloriesLabel.text = " \(LS(key: .CALORIES).uppercased())"
        doneButton.setTitle("            \(LS(key: .DONE).uppercased())            ", for: .normal)
        let fontAttributes = [NSAttributedString.Key.font: UIFont.sfProTextBold(size: 24)]
        let myText = "0"
        let size = (myText as NSString).size(withAttributes: fontAttributes)
        caloriesFieldWidthConstraint.constant = size.width
    }
    
    // MARK: - Interface -
    func fillCell(delegate: AddActivityUIDelegate) {
        self.delegate = delegate
    
    }
    
    // MARK: - Actions -
    @IBAction func caloriesFieldChanged(_ sender: Any) {
        let fontAttributes = [NSAttributedString.Key.font: UIFont.sfProTextBold(size: 24)]
        let myText = caloriesTextField.text ?? "0"
        
        if myText.isEmpty {
            let size = ("0" as NSString).size(withAttributes: fontAttributes)
            caloriesFieldWidthConstraint.constant = size.width
        } else {
            let size = (myText as NSString).size(withAttributes: fontAttributes)
            caloriesFieldWidthConstraint.constant = size.width
        }
        self.layoutIfNeeded()
    }
    
//    @IBAction func valueChanged(_ sender: UISlider) {
//        valueSliderChanged(value: sender.value)
//    }
    
    @IBAction func labelClicked(_ sender: Any) {
        caloriesTextField.becomeFirstResponder()
    }
    
    @IBAction func finishClicked(_ sender: Any) {
        guard let field = self.caloriesTextField.text, (Int(field) ?? 0) >= 10 else {
            return showAlert(message: "\(LS(key: .MINIMAL_CALORIES_COUNT)) 10")
        }
        
        var text: String = ""
        let fullNameArr = (growingTextView.textView.text ?? "").split{$0 == " "}.map(String.init)
        for item in fullNameArr where !item.isEmpty {
            text = text.isEmpty ? item : text + " \(item)"
        }
        
        guard !text.isEmpty else {
            return showAlert(message: LS(key: .ADD_USER_ACTIVITY_HINT))
        }
        
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("USER_LIST").child(uid).child("customActivities").childByAutoId()
            let userData = ["title": text, "time": self.time, "calories": (Int(field) ?? 0), "count" : ""] as [String : Any]
            ref.setValue(userData)
            
            let createdActivity = ActivityElement()
            createdActivity.name = text
            createdActivity.time = self.time
            createdActivity.calories = (Int(field) ?? 0)
            createdActivity.generalKey = ref.key
            
            self.delegate?.addNewActivity(createdActivity)
            if let vc = UIApplication.getTopMostViewController() {
                vc.view.endEditing(true)
                vc.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - Private -
    private func valueSliderChanged(value: Float) {
        selectedValue = Double(value * 360.00).rounded(toPlaces: 0)
        fillTimeCount()
    }
    
    private func setupSlider() {
        customSlider.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
    }
    
    private func showAlert(message: String) {
        if let vc = UIApplication.getTopMostViewController() {
            AlertComponent.sharedInctance.showAlertMessage(message: message, vc: vc)
        }
    }
    
    @objc func valueChanged(sender: TGPDiscreteSlider) {
        selectedState = sender.value
        changeState(value: selectedState)
    }
    
    private func fillTimeCount() {
        let mutableAttrString = NSMutableAttributedString()
        
        if (Int(selectedValue) / 60 % 60) > 0 {
            let hours = Int(selectedValue) / 60 % 60
            let minutes = Int(selectedValue) % 60
            mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 20),
                                                  color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: "\(hours) ".replacingOccurrences(of: ".0", with: "")))
            
            mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 20),
                                                         color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: fetchHoursSuffix(count: hours)))
            
            if minutes > 0 {
                mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 20),
                                                             color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: " \(minutes) "))
                
                mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 20),
                                                             color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: fetchMinutesSuffix(count: minutes)))
            }
        } else {
            let minutes = Int("\(selectedValue.displayOnly(count: 0))".replacingOccurrences(of: ".0", with: "")) ?? 0
            mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 20),
                                                         color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: "\(minutes) "))
            mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 20),
                                                         color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: fetchMinutesSuffix(count: minutes)))
        }
        sliderLabel.attributedText = mutableAttrString
    }
    
    private func fillSecondTimeCount(time: String) {
        let mutableAttrString = NSMutableAttributedString()
        
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextSemibold(size: 20),
                                                     color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: "\(time) "))
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 20),
                                                     color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: LS(key: .MINUTES)))
        sliderLabel.attributedText = mutableAttrString
    }
    
    private func changeState(value: CGFloat) {
        switch value {
        case 0.0:
            self.time = 15
            fillSecondTimeCount(time: "15")
        case 1.0:
            self.time = 30
            fillSecondTimeCount(time: "30")
        case 2.0:
            self.time = 45
            fillSecondTimeCount(time: "45")
        case 3.0:
            self.time = 60
            fillSecondTimeCount(time: "60")
        default:
            break
        }
    }
    
    private func fetchMinutesSuffix(count: Int) -> String {
        if getPreferredLocale().languageCode == "ru" {
            if count == 1 {
                return " минута"
            } else if count > 1 && count < 5 {
                return " минуты"
            } else {
                return " минут"
            }
        } else {
            return LS(key: .MINUTES)
        }
    }
    
    private func fetchHoursSuffix(count: Int) -> String {
        if getPreferredLocale().languageCode == "ru" {
            if count == 1 {
                return " час"
            } else if count > 4 {
                return " часов"
            } else {
                return " часа"
            }
        } else {
            return LS(key: .BLACK_PREM_HOURS)
        }
    }
    
    private func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
}

extension AddActivityTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        return count < 5
    }
}

extension AddActivityTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let _ = textView.text else { return }
        self.delegate?.updateTableView()
    }
}
