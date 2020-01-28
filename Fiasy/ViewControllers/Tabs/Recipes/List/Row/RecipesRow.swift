//
//  RecipesRow.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class RecipesRow : UITableViewCell {
    
    //MARK: - Outlets -
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties -
    static let rowHeight: CGFloat = 180.0
    private var recipes: [Listrecipe] = []
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    //MARK: - Interface -
    func fillRow(by recipes: [Listrecipe]) {
        self.recipes = recipes
        setupCollectionView()
    }
    
    //MARK: - Private -
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
}

extension RecipesRow: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count >= 5 ? 5 : recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipesCell", for: indexPath) as? RecipesCell else { return UICollectionViewCell() }
        
//        if recipes.indices.contains(indexPath.row) {
//            cell.fillCell(by: recipes[indexPath.row])
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = UIApplication.getTopMostViewController() {
            UserInfo.sharedInstance.selectedRecipes = recipes[indexPath.row]
            
   //         if UserInfo.sharedInstance.purchaseIsValid {
                vc.performSegue(withIdentifier: "sequeRecipeDetails", sender: nil)
//            } else {
//                vc.performSegue(withIdentifier: "sequePremiumScreen", sender: nil)
//            }
        }
    }
}

extension RecipesRow: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width/2.5, height: isIphone5 ? 150 : 180)
    }
}
