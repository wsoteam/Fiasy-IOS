//
//  UICollectionView+ReusableCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

extension UICollectionViewCell: ReusableCell {
    static var cellReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    func register<Cell: ReusableCell>(type: Cell.Type)  {
        let nib = UINib(nibName: Cell.cellReuseIdentifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: Cell.cellReuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: ReusableCell>(type: Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.cellReuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Failed to dequeue cell with identifier: " + Cell.cellReuseIdentifier)
        }
        
        return cell
    }
}
