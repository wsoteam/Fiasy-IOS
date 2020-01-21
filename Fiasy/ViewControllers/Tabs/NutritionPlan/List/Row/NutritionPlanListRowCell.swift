//
//  NutritionPlanListRowCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 1/20/20.
//  Copyright © 2020 Eugen Lipatov. All rights reserved.
//

import UIKit

class NutritionPlanListRowCell: UITableViewCell {

    // MARK: - Outlets -
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties -
    static let rowHeight: CGFloat = 200.0
    private var nutritions: [NutritionDetail] = []
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    // MARK: - Interface -
    func fillRow(nutritions: [NutritionDetail]) {
        self.nutritions = nutritions
        
        setupCollectionView()
    }
    
    // MARK: - Private -
    private func setupCollectionView() {
        self.collectionView.register(type: NutritionPlanListTableCell.self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
}

extension NutritionPlanListRowCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nutritions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NutritionPlanListTableCell", for: indexPath) as? NutritionPlanListTableCell else { return UICollectionViewCell() }
        cell.fillRow(nutrition: nutritions[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = UIApplication.getTopMostViewController() {
            //vc.performSegue(withIdentifier: "sequeArticleDetailsScreen", sender: articles[indexPath.row])
        }
    }
}

extension NutritionPlanListRowCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 50, height: isIphone5 ? 150 : 180)
    }
}
