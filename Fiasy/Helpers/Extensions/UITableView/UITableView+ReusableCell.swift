//
//  UITableView+ReusableCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/19/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

protocol ReusableCell: class {
    static var cellReuseIdentifier: String { get }
}

extension UITableViewCell: ReusableCell {
    static var cellReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func register<Cell: ReusableCell>(type: Cell.Type)  {
        let nib = UINib(nibName: Cell.cellReuseIdentifier, bundle: nil)
        register(nib, forCellReuseIdentifier: Cell.cellReuseIdentifier)
    }
    
    func dequeueReusableCell<Cell: ReusableCell>(type: Cell.Type) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.cellReuseIdentifier) as? Cell else {
            fatalError("Failed to dequeue cell with identifier: " + Cell.cellReuseIdentifier)
        }
        
        return cell
    }
}
