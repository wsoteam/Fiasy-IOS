//
//  DiaryWaterTableViewCell.swift
//  Fiasy
//
//  Created by Yuriy Sokirko on 9/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class DiaryWaterTableViewCell: UITableViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties -
    
    
    // MARK: - Interface -
    func fillCell() {
        
        setupCollectionView()
    }
    
    // MARK: - Private -
    private func setupCollectionView() {
        self.collectionView.register(type: WaterCollectionCell.self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
}

extension DiaryWaterTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WaterCollectionCell", for: indexPath) as? WaterCollectionCell else { return UICollectionViewCell() }
        
//        if recipes.indices.contains(indexPath.row) {
//            cell.fillCell(by: recipes[indexPath.row])
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? WaterCollectionCell {
            cell.waterButtleImageView.image = UIImage.coloredImage(image: UIImage(named: "test_png1"), color: #colorLiteral(red: 0.1752049029, green: 0.6115815043, blue: 0.8576936722, alpha: 1))?.withRenderingMode(.alwaysOriginal)
        }
    }
}

extension DiaryWaterTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}
