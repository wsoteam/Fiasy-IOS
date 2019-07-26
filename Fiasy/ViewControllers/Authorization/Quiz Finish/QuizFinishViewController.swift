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
    @IBOutlet weak var progressView: CircularProgress!
    
    // MARK: - Life cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        progressView.setProgressWithAnimation(duration: 3, value: 1) { [weak self] in
            //
        }
    }
    
    // MARK: - Privates -
    private func setupInitialState() {
        progressView.trackColor = .clear
        progressView.progressColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
    }
}
