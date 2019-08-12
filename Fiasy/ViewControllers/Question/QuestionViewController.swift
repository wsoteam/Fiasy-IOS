//
//  QuestionViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/6/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var questionMessageLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    
    // MARK: - Properties -
    var questionTitle: String = ""
    var message: String = ""
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTitleLabel.text = questionTitle
        questionMessageLabel.text = message
    }
    
    //MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
