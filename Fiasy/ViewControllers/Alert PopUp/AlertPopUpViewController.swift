//
//  AlertPopUpViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/11/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class AlertPopUpViewController: UIViewController {
    
    // MARK: - Outlets -
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Properties -
    var completion: (()-> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showAnimate()
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func okClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.containerView.alpha = 0.0
            self?.containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {[weak self] _ in
                self?.dismiss(animated: true) { [weak self] in
                    self?.completion?()
                }
        })
    }
    
    private func showAnimate() {
        containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        containerView.alpha = 0.0
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.containerView.alpha = 1.0
            self?.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    private func removeAnimate() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.containerView.alpha = 0.0
            self?.containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {[weak self] _ in
                self?.dismiss(animated: true)
        })
    }
}
