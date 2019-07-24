//
//  QuizDisplayManager.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol QuizViewOutput {
    
}

class QuizDisplayManager: NSObject {
    
    //MARK: - Properties -
    private var cells = [QuizGenderCell.self]
    private var collectionView: UICollectionView
    private var output: QuizViewOutput
    
    //MARK: - Iterface -
    init(collectionView: UICollectionView, output: QuizViewOutput) {
        self.output = output
        self.collectionView = collectionView
        super.init()
        
        setupCollectionView()
        //setupTitleNavigation(by: 1)
    }
    
    //MARK: - Private -
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(type: QuizGenderCell.self)
    }
}

extension QuizDisplayManager: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cells[indexPath.row].cellReuseIdentifier,
                                                      for: indexPath)
//        if let cell = cell as? FirstStepCell {
//            cell.fillCell(delegate: self)
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if let cell = cell as? SecondStepCell {
//            cell.fillCell(delegate: self, flow: self.flow)
//        } else if let cell = cell as? ThirdStepCell {
//            cell.fillCell(delegate: self, flow: self.flow)
//        } else if let cell = cell as? FourthStepCell {
//            cell.fillCell(code: self.phoneCode, phone: self.phone, delegate: self)
//        } else if let cell = cell as? FiveStepCell {
//            cell.fillCell(delegate: self)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

