//
//  QuizDisplayManager.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol QuizViewOutput {
    
    func openFinishScreen()
    func changeTitle(title: String)
    func changePageControl(index: Int)
    func changeStateNextButton(state: Bool)
    func changeStateBackButton(hidden: Bool)
}

class QuizDisplayManager: NSObject {
    
    //MARK: - Properties -
    private var currentCellIndex: IndexPath = IndexPath(row: 0, section: 0)
    private var cells = [QuizGenderCell.self, GrowthSelectionCell.self, WeightSelectionCell.self,  DateOfBirthSelectionCell.self, SelectActivityTableViewCell.self, TargetSelectedCell.self]
    private var collectionView: UICollectionView
    private var output: QuizViewOutput
    
    //MARK: - Iterface -
    init(collectionView: UICollectionView, output: QuizViewOutput) {
        self.output = output
        self.collectionView = collectionView
        super.init()
        
        setupCollectionView()
    }
    
    func nextScrollCell() {
        if cells.indices.contains(currentCellIndex.row + 1) {
            scrollCollection(by: currentCellIndex.row + 1, position: .right)
        } else if currentCellIndex.row == 5 {
            output.openFinishScreen()
        }
    }
    
    func backScrollCell() {
        if cells.indices.contains(currentCellIndex.row - 1) {
            scrollCollection(by: currentCellIndex.row - 1, position: .left)
        }
    }
    
    //MARK: - Private -
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(type: QuizGenderCell.self)
        collectionView.register(type: TargetSelectedCell.self)
        collectionView.register(type: GrowthSelectionCell.self)
        collectionView.register(type: WeightSelectionCell.self)
        collectionView.register(type: DateOfBirthSelectionCell.self)
        collectionView.register(type: SelectActivityTableViewCell.self)
    }
    
    private func scrollCollection(by index: Int, position: UICollectionView.ScrollPosition) {
        currentCellIndex = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: currentCellIndex, at: position, animated: true)
    }
}

extension QuizDisplayManager: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cells[indexPath.row].cellReuseIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? QuizGenderCell {
            cell.fillCell(delegate: output)
        } else if let cell = cell as? GrowthSelectionCell {
            cell.fillCell(delegate: output)
        } else if let cell = cell as? WeightSelectionCell {
            cell.fillCell(delegate: output)
        } else if let cell = cell as? DateOfBirthSelectionCell {
            cell.fillCell(delegate: output)
        } else if let cell = cell as? SelectActivityTableViewCell {
            cell.fillCell(delegate: output)
        } else if let cell = cell as? TargetSelectedCell {
            cell.fillCell(delegate: output)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

