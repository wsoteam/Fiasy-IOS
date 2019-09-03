//
//  ArticleTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    // MARK: - Outlets -
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties -
    static let rowHeight: CGFloat = Display.typeIsLike == .iphone5 ? 160.0 : 200.0
    private var models: [ArticleModel] = []
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    // MARK: - Interface -
    func fillRow(models: [ArticleModel]) {
        self.models = models
        
        setupCollectionView()
    }
    
    // MARK: - Private -
    private func setupCollectionView() {
        self.collectionView.register(type: ArticleCollectionViewCell.self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
}

extension ArticleTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as? ArticleCollectionViewCell else { return UICollectionViewCell() }
        cell.fillRow(model: models[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = UIApplication.getTopMostViewController() {
            vc.performSegue(withIdentifier: "sequeArticleDetailsScreen", sender: models[indexPath.row])
        }
    }
}

extension ArticleTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isIphone5 {
            return CGSize(width: UIScreen.main.bounds.size.width - 50, height: 160)
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width - 50, height: 200)
        }
    }
}
