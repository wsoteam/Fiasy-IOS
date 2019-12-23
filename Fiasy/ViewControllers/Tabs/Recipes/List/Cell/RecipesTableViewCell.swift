//
//  RecipesTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/25/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class RecipesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets -
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties -
    static let rowHeight: CGFloat = 200.0
    private var recipes: [SecondRecipe] = []
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    // MARK: - Interface -
    func fillRow(recipes: [SecondRecipe]) {
        self.recipes = recipes
        
        setupCollectionView()
    }
    
    // MARK: - Private -
    private func setupCollectionView() {
        self.collectionView.register(type: RecipeCollectionViewCell.self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
}

extension RecipesTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count >= 5 ? 5 : recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as? RecipeCollectionViewCell else { return UICollectionViewCell() }
        cell.fillRow(recipe: recipes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = UIApplication.getTopMostViewController() as? RecipesViewController {
            if recipes.indices.contains(indexPath.row) {
                vc.performSegue(withIdentifier: "sequeArticleDetailsScreen", sender: recipes[indexPath.row])
            }
        }
    }
}

extension RecipesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 50, height: 200)
    }
}
