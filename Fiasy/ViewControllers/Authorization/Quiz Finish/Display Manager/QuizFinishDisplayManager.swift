//
//  QuizFinishDisplayManager.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Amplitude_iOS

protocol QuizFinishViewOutput {
    
    func openPremiumScreen()
    func changeStateBackButton(hidden: Bool)
}

class QuizFinishDisplayManager: NSObject {

    //MARK: - Properties -
    private var currentCellIndex: IndexPath = IndexPath(row: 0, section: 0)
    private var collectionView: UICollectionView
    private var output: QuizFinishViewOutput
    private var cells = [FirstQuizFinishCell.self, SecondQuizFinishCell.self]
    
    //MARK: - Iterface -
    init(collectionView: UICollectionView, output: QuizFinishViewOutput) {
        self.output = output
        self.collectionView = collectionView
        super.init()
        
        setupCollectionView()
    }
    
    func nextScrollCell() {
//        if cells.indices.contains(currentCellIndex.row + 1) {
//            Amplitude.instance()?.logEvent("question_next", withEventProperties: ["question" : "feature"]) // +
//            scrollCollection(by: currentCellIndex.row + 1, position: .right)
//        } else if currentCellIndex.row == 1 {
//            output.openPremiumScreen()
//        }
        output.openPremiumScreen()
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
        collectionView.register(type: FirstQuizFinishCell.self)
        collectionView.register(type: SecondQuizFinishCell.self)
    }
    
    private func scrollCollection(by index: Int, position: UICollectionView.ScrollPosition) {
        currentCellIndex = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: currentCellIndex, at: position, animated: true)
    }
}

extension QuizFinishDisplayManager: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cells[indexPath.row].cellReuseIdentifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? FirstQuizFinishCell {
            cell.fillCell(delegate: output)
        } else if let cell = cell as? SecondQuizFinishCell {
            cell.fillCell(delegate: output)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
