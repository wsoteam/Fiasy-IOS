//
//  QuizViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

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
        UserInfo.sharedInstance.registrationFlow = RegistrationFlow()
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
        displayManager = QuizDisplayManager(collectionView: collectionView, output: self)
    }
}

extension QuizViewController: QuizViewOutput {
    
    func openFinishScreen() {
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
