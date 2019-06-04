//
//  RecipesPremiumViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/15/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Kingfisher

class RecipesPremiumViewController: UIViewController {
    
    //MARK: - Outlet's -
    @IBOutlet weak var recipeImageView: UIImageView!
    
    //MARK: - Properties -
    private let selectedRecipe = UserInfo.sharedInstance.selectedRecipes
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitialState()
    }
    
    //MARK: - Private -
    private func setupInitialState() {
        if let path = selectedRecipe?.url, let url = try? path.asURL() {
            let resource = ImageResource(downloadURL: url)
            recipeImageView.kf.setImage(with: resource)
        }
    }
    
    //MARK: - Action's -
    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func premiumClicked(_ sender: Any) {
        dismiss(animated: true) {
            if let vc = UIApplication.getTopMostViewController() {
                vc.performSegue(withIdentifier: "sequeGeneralPremiumScreen", sender: nil)
            }
        }
    }
}
