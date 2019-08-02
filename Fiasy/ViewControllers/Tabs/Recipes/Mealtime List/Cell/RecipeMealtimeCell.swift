//
//  RecipeMealtimeCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/6/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Kingfisher

class RecipeMealtimeCell: UITableViewCell {
    
    //MARK: - Outlet -
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet var recipeImages: [UIImageView]!
    @IBOutlet var recipeNameLabels: [UILabel]!
    @IBOutlet var caloriesLabels: [UILabel]!
    
    //MARK: - Properties -
    private var delegate: RecipeMealtimeDelegate?
    private var indexCell: IndexPath?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        leftView.isUserInteractionEnabled = false
        rightView.isUserInteractionEnabled = false
    }
    
    //MARK: - Interface -
    func fillCell(recipes: [Listrecipe], delegate: RecipeMealtimeDelegate, indexPath: IndexPath) {
        self.indexCell = indexPath
        self.delegate = delegate
        
        let index = indexPath.row * 2
        if recipes.indices.contains(index) {
            recipeNameLabels[0].text = recipes[index].name
            caloriesLabels[0].text = "\(recipes[index].calories ?? 0) Ккал"
            if let path = recipes[index].url, let url = try? path.asURL() {
                recipeImages[0].kf.indicatorType = .activity
                let resource = ImageResource(downloadURL: url)
                recipeImages[0].kf.setImage(with: resource)
            }
            leftView.isUserInteractionEnabled = true
        }
        
        if recipes.indices.contains(index + 1) {
            rightView.alpha = 1
            recipeNameLabels[1].text = recipes[index + 1].name
            caloriesLabels[1].text = "\(recipes[index + 1].calories ?? 0) Ккал"
            if let path = recipes[index + 1].url, let url = try? path.asURL() {
                recipeImages[1].kf.indicatorType = .activity
                let resource = ImageResource(downloadURL: url)
                recipeImages[1].kf.setImage(with: resource)
            }
            rightView.isUserInteractionEnabled = true
        } else {
            rightView.alpha = 0
        }
    }
    
    //MARK: - Actions -
    @IBAction func leftRecipeClicked(_ sender: UIButton) {
        guard let index = indexCell,
            UserInfo.sharedInstance.selectedMealtimeData.indices.contains(index.row * 2) else { return }
        UserInfo.sharedInstance.selectedRecipes = UserInfo.sharedInstance.selectedMealtimeData[index.row * 2]
        delegate?.showMealtimeDetails()
    }
    
    @IBAction func rightRecipeClicked(_ sender: UIButton) {
        guard let index = indexCell,
            UserInfo.sharedInstance.selectedMealtimeData.indices.contains((index.row * 2) + 1) else { return }
        UserInfo.sharedInstance.selectedRecipes = UserInfo.sharedInstance.selectedMealtimeData[(index.row * 2) + 1]
        delegate?.showMealtimeDetails()
    }
}
