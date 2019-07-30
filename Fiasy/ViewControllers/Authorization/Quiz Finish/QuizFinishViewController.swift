//
//  QuizFinishViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/25/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class QuizFinishViewController: UIViewController {
    
     // MARK: - Outlet's -
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var finishStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressView: CircularProgress!
    
    // MARK: - Properties -
    private var displayManager: QuizFinishDisplayManager?
    
    // MARK: - Life cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
        secondView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        progressView.setProgressWithAnimation(duration: 3, value: 1) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.finishStackView.isHidden = true
            strongSelf.secondView.isHidden = false
        }
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        displayManager?.backScrollCell()
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        displayManager?.nextScrollCell()
    }
    
    // MARK: - Privates -
    private func setupInitialState() {
        progressView.trackColor = .clear
        progressView.progressColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
        
        displayManager = QuizFinishDisplayManager(collectionView: collectionView, output: self)
    }
}

extension QuizFinishViewController: QuizFinishViewOutput {
    
    func openPremiumScreen() {
        performSegue(withIdentifier: "sequePremiumQuizScreen", sender: nil)
    }
    
    func changeStateBackButton(hidden: Bool) {
        backButton.isHidden = hidden
    }
}
