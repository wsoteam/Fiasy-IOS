//
//  SecondQuizFinishCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class SecondQuizFinishCell: UICollectionViewCell {
    
    //MARK: - Properties -
    private var delegate: QuizFinishViewOutput?
    
    //MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //setupDefaultState()
    }
    
    // MARK: - Interface -
    func fillCell(delegate: QuizFinishViewOutput) {
        self.delegate = delegate
        
        delegate.changeStateBackButton(hidden: false)
    }
}
