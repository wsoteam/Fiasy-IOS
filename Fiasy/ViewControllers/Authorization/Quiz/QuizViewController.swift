//
//  QuizViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Intercom
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
    
    // MARK: - Life cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
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
        let flow = UserInfo.sharedInstance.registrationFlow
        let birthday: Date = flow.dateOfBirth ?? Date()
        let ageComponents = Calendar.current.dateComponents([.year], from: birthday, to: Date())
        let age = Double(ageComponents.year ?? 0)
        let item = flow.gender == 0 ? "female" : "male"
        
        let identify = AMPIdentify()
        identify.set("male", value: item as NSObject)
        identify.set("height", value: flow.growth as NSObject)
        identify.set("weight", value: flow.weight as NSObject)
        identify.set("age", value: age as NSObject)
        identify.set("active", value: Int(flow.loadActivity) + 1 as NSObject)
        identify.set("goal", value: (flow.target ?? 0) + 1 as NSObject)
        Amplitude.instance()?.identify(identify)
        
        let userAttributes = [
            "male": item,
            "height": flow.growth,
            "weight": flow.weight,
            "age": age,
            "active": Int(flow.loadActivity) + 1,
            "goal": (flow.target ?? 0) + 1
            ] as [String : Any]
        
        let attributed = ICMUserAttributes()
        attributed.customAttributes = userAttributes
        Intercom.updateUser(attributed)
        
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
        nextButton.setImage(state ? #imageLiteral(resourceName: "ewfwefwewee") : #imageLiteral(resourceName: "next_gray"), for: .normal)
    }
}
