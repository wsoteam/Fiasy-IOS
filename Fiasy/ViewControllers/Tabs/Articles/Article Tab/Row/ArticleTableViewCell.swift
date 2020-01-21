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
    static let rowHeight: CGFloat = 180.0
    private var articles: [Article] = []
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    // MARK: - Interface -
    func fillRow(articles: [Article]) {
        self.articles = articles
        
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
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell", for: indexPath) as? ArticleCollectionViewCell else { return UICollectionViewCell() }
        cell.fillRow(article: articles[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = UIApplication.getTopMostViewController() {
            vc.performSegue(withIdentifier: "sequeArticleDetailsScreen", sender: articles[indexPath.row])
        }
    }
}

extension ArticleTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width - 50, height: isIphone5 ? 150 : 180)
    }
}
