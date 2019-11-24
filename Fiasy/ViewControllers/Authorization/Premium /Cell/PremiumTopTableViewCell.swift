//
//  PremiumTopTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class PremiumTopTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    // MARK: - Outlet -
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var endTimerLabel: UILabel!
    @IBOutlet weak var timerStackView: UIStackView!
    @IBOutlet weak var minutesTitleLabel: UILabel!
    @IBOutlet weak var hoursTitleLabel: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties -
    private var state: PremiumColorState = .black
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var slides: [PremiumSlideView] = []
    private var delegate: PremiumQuizDelegate?
    private var timer = Timer()
    
    // MARK: - Life Cicle -
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if slides.isEmpty {     
            let dcf = DateComponentsFormatter()
            dcf.allowedUnits = [.day, .hour, .minute]
            dcf.unitsStyle = .full
            
            let df = ISO8601DateFormatter()
            df.formatOptions = [.withFullDate, .withDashSeparatorInDate]
            
            if let future = df.date(from: "2019-12-01") {
//                let tomorrow = Calendar.current.date(byAdding: .hour, value: 23, to: future)!
//                let second = Calendar.current.date(byAdding: .minute, value: 03, to: tomorrow)!
                
                let component = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: future)
                if let day = component.day, let hour = component.hour, let minute = component.minute, let second = component.second {
                    if day <= 0 && hour <= 0 && minute <= 0 && second <= 0 {
                        state = .white
                        timerStackView.isHidden = true
                    } else {
                        state = .black
                        timerStackView.isHidden = false
                    }
                }
                slides = createSlides()
                applyColorState(state: state)
                
                if let day = component.day, day < 3 {
                    timerStackView.isHidden = false
                    countDownDate()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDownDate), userInfo: nil, repeats: true)
                    }
                } else {
                    timerStackView.isHidden = true
                }
            }
            setupSlideScrollView(slides: slides)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        hoursTitleLabel.text = LS(key: .BLACK_PREM_HOURS)
        minutesTitleLabel.text = LS(key: .BLACK_PREM_MINUTES)
        secondTitleLabel.text = LS(key: .BLACK_PREM_SECONDS)
        endTimerLabel.text = LS(key: .BLACK_PREM_END)
    }
    
    // MARK: - Interface -
    func fillCell(delegate: PremiumQuizDelegate, state: PremiumColorState) {
        self.state = state
        self.delegate = delegate
        applyColorState(state: state)
        
        let dcf = DateComponentsFormatter()
        dcf.allowedUnits = [.day, .hour, .minute]
        dcf.unitsStyle = .full
        
        let df = ISO8601DateFormatter()
        df.formatOptions = [.withFullDate, .withDashSeparatorInDate]
        
        if let future = df.date(from: "2019-12-01") {
            let component = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: future)
            if let day = component.day, day < 3 {
                timerStackView.isHidden = false
            } else {
                timerStackView.isHidden = true
            }
        }
    }
    
    // MARK: - Actions -
    @IBAction func payClicked(_ sender: Any) {
        delegate?.purchedClicked()
    }

    // MARK: - Private -
    private func setupSlideScrollView(slides: [PremiumSlideView]) {
        scrollView.removeAllSubviews()
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: (UIScreen.main.bounds.width - 40) * CGFloat(slides.count), height: 181)
        for (index, item) in slides.enumerated() {
            item.frame = CGRect(x: ((UIScreen.main.bounds.width - 40) * CGFloat(index)), y: 0, width: (UIScreen.main.bounds.width - 40), height: 181)
            scrollView.addSubview(item)
        }
    }
    
    @objc private func countDownDate() {
        guard let vc = UIApplication.getTopMostViewController() else { return }
        if ((vc as? PremiumQuizViewController) != nil) || ((vc as? PremiumDetailsViewController) != nil) {
            let dcf = DateComponentsFormatter()
            dcf.allowedUnits = [.day, .hour, .minute, .hour, .minute, .second]
            dcf.unitsStyle = .full
        
            let df = ISO8601DateFormatter()
            df.formatOptions = [.withFullDate, .withDashSeparatorInDate]
            //"2019-12-01"
            if let future = df.date(from: "2019-12-01") {
                //let diff = dcf.string(from: Date(), to: future)
                
//                let tomorrow = Calendar.current.date(byAdding: .hour, value: 23, to: future)!
//                let second = Calendar.current.date(byAdding: .minute, value: 03, to: tomorrow)!
//                
                let component = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: future)
//                if let day = component.day {
//                    dayLabel.fadeTransition(0.4)
//                    dayLabel.text = day >= 10 ? "\(day)" : "0\(day)"
//                }
                if let hour = component.hour {
                    if let day = component.day, day > 0 {
                        dayLabel.fadeTransition(0.4)
                        dayLabel.text = "\((day * 24) + hour)"
                    } else {
                        dayLabel.fadeTransition(0.4)
                        dayLabel.text = hour >= 10 ? "\(hour)" : "0\(hour)"
                    }
                }
                if let minute = component.minute {
                    hoursLabel.fadeTransition(0.4)
                    hoursLabel.text = minute >= 10 ? "\(minute)" : "0\(minute)"
                }
                
                if let second = component.second {
                    minutesLabel.fadeTransition(0.4)
                    minutesLabel.text = second >= 10 ? "\(second)" : "0\(second)"
                }
                
                if let day = component.day, let hour = component.hour, let minute = component.minute, let second = component.second {
                    if day <= 0 && hour <= 0 && minute <= 0 && second <= 0 {
                        state = .white
                        timer.invalidate()
                        if let vc = UIApplication.getTopMostViewController() as? PremiumQuizViewController {
                            vc.state = .white
                            vc.applyColorState(state: .white)
                            vc.setNeedsStatusBarAppearanceUpdate()
                            slides = createSlides()
                            timerStackView.isHidden = true
                            setupSlideScrollView(slides: slides)
                            vc.tableView.reloadData()
                        } else if let vc = UIApplication.getTopMostViewController() as? PremiumDetailsViewController {
                            vc.setNeedsStatusBarAppearanceUpdate()
                            state = .white
                            vc.state = .white
                            vc.applyColorState(state: .white)
                            vc.tableView.reloadData()
                        }
                    }
                }
            }
        } else {
            state = .white
            timer.invalidate()
            if let vc = UIApplication.getTopMostViewController() as? PremiumQuizViewController {
                vc.state = .white
                vc.applyColorState(state: .white)
                vc.tableView.reloadData()
            } else if let vc = UIApplication.getTopMostViewController() as? PremiumDetailsViewController {
                state = .white
                vc.tableView.reloadData()
            }
        }
    }
    
    private func applyColorState(state: PremiumColorState) {
        switch state {
        case .black:
            topImageView.image = #imageLiteral(resourceName: "friday- Title")
        case .white:
            if let appLanguage = StorageService.get(by: .APP_LANGUAGE) as? String {
                switch appLanguage {
                case "en":
                    topImageView.image = #imageLiteral(resourceName: "white_Анг")
                case "de":
                    topImageView.image = #imageLiteral(resourceName: "white_Нем")
                case "pt":
                    topImageView.image = #imageLiteral(resourceName: "white_Порт")
                case "es":
                    topImageView.image = #imageLiteral(resourceName: "white_Исп")
                default:
                    topImageView.image = #imageLiteral(resourceName: "white_Рус")
                }
            }
        }
        buyButton.setTitle("       \(LS(key: .SETTINGS_PERSONAL).uppercased())       ", for: .normal)
        buyButton.backgroundColor = state == .black ? #colorLiteral(red: 0.8516539931, green: 0.6581981182, blue: 0.267614007, alpha: 1) : #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
        let mutableAttrString = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        mutableAttrString.append(NSAttributedString(string: LS(key: .LONG_PREM_TITL_1), attributes: [.font: UIFont.sfProTextMedium(size: 20), .foregroundColor: state == .black ? #colorLiteral(red: 0.866572082, green: 0.8667211533, blue: 0.8665626645, alpha: 1) : #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)]))
        mutableAttrString.append(NSAttributedString(string: "Fiasy Premium", attributes: [.font: UIFont.sfProTextBold(size: 25), .foregroundColor: state == .black ? #colorLiteral(red: 0.8516539931, green: 0.6581981182, blue: 0.267614007, alpha: 1) : #colorLiteral(red: 0.9187557101, green: 0.5817510486, blue: 0.2803534865, alpha: 1)]))
        topTitleLabel.attributedText = mutableAttrString
    }

    private func createSlides() -> [PremiumSlideView] {
        var items: [PremiumSlideView] = []
        for index in 0...2 {
            guard let item = PremiumSlideView.fromXib() else { return [] }
            item.fillCell(index: index, state: self.state)
            items.append(item)
        }
        return items
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0) }
        
        let pageIndex = round(scrollView.contentOffset.x/UIScreen.main.bounds.width)
        delegate?.changeSubscriptionIndex(index: Int(pageIndex))
    }
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
