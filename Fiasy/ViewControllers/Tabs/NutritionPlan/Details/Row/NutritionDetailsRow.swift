//
//  NutritionDetailsRow.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/28/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit

class NutritionDetailsRow: UITableViewCell {
    
    // MARK: - Outlets -
    @IBOutlet var selectedButtons: [UIButton]!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties -
    private var selectedIndex: Int = 0
    static let rowHeight: CGFloat = 200.0
    private var recipes: [[SecondRecipe]] = []
    private var filteredRecipes: [SecondRecipe] = []
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    // MARK: - Life Cicle -
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        fillButtons(index: selectedIndex)
//    }
    
    // MARK: - Interface -
    func fillRow(recipes: [[SecondRecipe]]) {
        self.recipes = recipes
        
        fillButtons(index: selectedIndex)
        setupCollectionView()
    }
    
    // MARK: - Private -
    private func setupCollectionView() {
        self.collectionView.register(type: RecipeCollectionViewCell.self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    // MARK: - Actions -
    @IBAction func buttonsClicked(_ sender: UIButton) {
        selectedIndex = sender.tag
        fillButtons(index: selectedIndex)
        self.collectionView.reloadData()
    }
    
    // MARK: - Private -
    private func fillButtons(index: Int) {
        self.filteredRecipes = recipes[index]
        for item in selectedButtons {
            if item.tag == index {
                item.backgroundColor = #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1)
                item.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            } else {
                item.backgroundColor = .clear
                item.setTitleColor(#colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), for: .normal)
            }
        }
    }
}

extension NutritionDetailsRow: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredRecipes.count >= 3 ? 3 : filteredRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCollectionViewCell", for: indexPath) as? RecipeCollectionViewCell else { return UICollectionViewCell() }
        cell.clickedButton.isHidden = false
        cell.fillRow(recipe: filteredRecipes.shuffled().last!)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let vc = UIApplication.getTopMostViewController() as? NutritionDetailsViewController {
//            if recipes.indices.contains(indexPath.row) {
//                vc.performSegue(withIdentifier: "sequeArticleDetailsScreen", sender: filteredRecipes[indexPath.row])
//            }
//        }
//    }
}

extension NutritionDetailsRow: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 50, height: 200)
    }
}
