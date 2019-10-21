//
//  QuizViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS

class QuizViewController: UIViewController {
    
    // MARK: - Outlets -
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties -
    private var displayManager: QuizDisplayManager?
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    // MARK: - Life cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
        nextButton.setTitle("\(LS(key: .UNBOARDING_NEXT)) ", for: .normal)
        if isIphone5 {
            bottomTitleLabel.font = bottomTitleLabel.font?.withSize(16)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        displayManager?.backScrollCell()
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        displayManager?.nextScrollCell()
    }
    
    // MARK: - Private -
    private func setupInitialState() {
        UserInfo.sharedInstance.registrationFlow.gender = nil
        UserInfo.sharedInstance.registrationFlow.photoUrl = ""
        UserInfo.sharedInstance.registrationFlow.growth = 154
        UserInfo.sharedInstance.registrationFlow.weight = 60.0
        UserInfo.sharedInstance.registrationFlow.dateOfBirth = nil
        UserInfo.sharedInstance.registrationFlow.loadActivity = 0.0
        UserInfo.sharedInstance.registrationFlow.target = nil
        
        displayManager = QuizDisplayManager(collectionView: collectionView, output: self)
    }
}

extension QuizViewController: QuizViewOutput {
    
    func openFinishScreen() {
        fillUserProperties()
        performSegue(withIdentifier: "sequeFinishQuiz", sender: nil)
    }
    
    
    func changeTitle(title: String) {
        bottomTitleLabel.text = title
    }
    
    func changePageControl(index: Int) {
        pageControl.currentPage = index
    }
    
    func changeStateBackButton(hidden: Bool) {
        backButton.isHidden = hidden
    }
    
    func changeStateNextButton(state: Bool) {
        nextButton.isUserInteractionEnabled = state
        nextButton.backgroundColor = state ? #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1) : #colorLiteral(red: 0.741094768, green: 0.7412236333, blue: 0.7410866618, alpha: 1)
    }
    
    private func fillUserProperties() {
        let flow = UserInfo.sharedInstance.registrationFlow
        let birthday: Date = flow.dateOfBirth ?? Date()
        let ageComponents = Calendar.current.dateComponents([.year], from: birthday, to: Date())
        let age = Double(ageComponents.year ?? 0)
        let item = flow.gender == 0 ? "female" : "male"

        var BMR: Double = 0.0
        var fat: Int = 0
        var protein: Int = 0
        var carbohydrates: Int = 0
        if flow.gender == 0 {
            BMR = (10 * flow.weight) + (6.25 * Double(flow.growth)) - (5 * age) - 161
        } else {
            BMR = (10 * flow.weight) + (6.25 * Double(flow.growth)) - (5 * age) + 5
        }
        let activity = (BMR * RegistrationFlow.fetchActivityCoefficient(value: flow.loadActivity))
        let result = RegistrationFlow.fetchResultByAdjustmentCoefficient(target: flow.target, count: activity).displayOnly(count: 0)
        
        if flow.gender == 0 {
            fat = (Int((result * 0.25).displayOnly(count: 0))/9) + 16
            protein = (Int((result * 0.4).displayOnly(count: 0))/4) - 16
            carbohydrates = (Int((result * 0.35).displayOnly(count: 0))/4) - 16
        } else {
            fat = (Int((result * 0.25).displayOnly(count: 0))/9) + 36
            protein = (Int((result * 0.4).displayOnly(count: 0))/4) - 36
            carbohydrates = (Int((result * 0.35).displayOnly(count: 0))/4) - 36
        }
        
        let identify = AMPIdentify()
        identify.set("male", value: item as NSObject)
        identify.set("height", value: flow.growth as NSObject)
        identify.set("weight", value: flow.weight as NSObject)
        identify.set("age", value: age as NSObject)
        identify.set("active", value: (Int(flow.loadActivity) + 1).fetchUserActive() as NSObject)
        identify.set("goal", value: ((flow.target ?? 0) + 1).fetchUserGoal() as NSObject)
        
        identify.set("calorie", value: "\(Int(result))" as NSObject)
        identify.set("proteins", value: "\(protein)" as NSObject)
        identify.set("fats", value: "\(fat)" as NSObject)
        identify.set("сarbohydrates", value: "\(carbohydrates)" as NSObject)
        
        Amplitude.instance()?.identify(identify)
    }
}
