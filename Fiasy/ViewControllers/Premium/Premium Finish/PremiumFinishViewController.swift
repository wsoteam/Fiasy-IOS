//
//  PremiumFinishViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/11/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import VisualEffectView

class PremiumFinishViewController: UIViewController {
    
    // MARK: - Outlets -
    @IBOutlet weak var blurView: VisualEffectView!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Properties -
    var isAutorization: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        blurView.colorTint = .gray
        blurView.colorTintAlpha = 0.1
        blurView.blurRadius = 5
        blurView.scale = 1
        showAnimate()
    }
    
    // MARK: - Actions -
    @IBAction func cancelClicked(_ sender: Any) {
        removeAnimate()
    }
    
    // MARK: - Private -
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
                if self?.isAutorization == true {
                    self?.performSegue(withIdentifier: "sequeMenuScreen", sender: nil)
                } else {
                    self?.dismiss(animated: true, completion: {
                        if let vc = UIApplication.getTopMostViewController() {
                            vc.navigationController?.popViewController(animated: true)
                        }
                    })
                }
        })
    }
}

