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
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties -
    private var displayManager: QuizDisplayManager?
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
    }
    
    // MARK: - Action's -
    @IBAction func backClicked(_ sender: Any) {
        //navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private -
    private func setupInitialState() {
        displayManager = QuizDisplayManager(collectionView: collectionView, output: self)
    }
}

extension QuizViewController: QuizViewOutput {
    
}
