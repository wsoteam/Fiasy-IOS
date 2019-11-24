//
//  InsertDiaryView.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/25/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class InsertDiaryView: UIView {
    
    //MARK: - Outlets -
    @IBOutlet weak var clickedButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var mealtimeNameLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    
    //MARK: - Properties -
    private var delegate: SecondMainManagerDelegate?
    private var indexInStackView: Int?
    private var indexPath: IndexPath?
    
    //MARK: - Interface -
    func fillView(by model: Mealtime, delegate: SecondMainManagerDelegate?, index: Int, indexPath: IndexPath) {
        self.delegate = delegate
        self.indexInStackView = index
        self.indexPath = indexPath
        
        nameLabel.text = model.name
//        caloriesLabel.text = "\(model.calories ?? Int(0)) Ккал"
//        
//        proteinLabel.text = "Б. \(model.protein ?? Int(0.0))"
//        fatLabel.text = "Ж. \(model.fat ?? Int(0.0))"
//        carbLabel.text = "У. \(model.carbohydrates ?? Int(0.0))"
        
        mealtimeNameLabel.text = "Вес \(model.weight ?? 100) г"
        
        addLongPressGesture()
    }
    
    private func addLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        longPress.minimumPressDuration = 1.5
        self.clickedButton.addGestureRecognizer(longPress)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.clickedButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            guard let indexCell = indexPath, let indexStack = indexInStackView else { return }
            self.delegate?.showDeletePicker(indexInStack: indexStack, indexPath: indexCell)
        }
    }
    
    @objc func normalTap(_ sender: UIGestureRecognizer) {
        guard let indexCell = indexPath, let indexStack = indexInStackView else { return }
        self.delegate?.showEditMealtime(by: indexStack, indexPath: indexCell)
    }
}
