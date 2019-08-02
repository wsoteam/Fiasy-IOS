//
//  SelectActivityTableViewCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/25/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class SelectActivityTableViewCell: UICollectionViewCell {
    
    // MARK: - Outlet -
    @IBOutlet weak var slider: TGPDiscreteSlider!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var selectedStateImageView: UIImageView!
    
    //MARK: - Properties -
    private var delegate: QuizViewOutput?
    private var selectedState: CGFloat = 0.0
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    //MARK: - Life Cicle -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSlider()
        changeState(value: 0.0)
    }
    
    // MARK: - Interface -
    func fillCell(delegate: QuizViewOutput) {
        self.delegate = delegate
        
        delegate.changeTitle(title: "Выберите свою активность")
        delegate.changeStateBackButton(hidden: false)
        delegate.changeStateNextButton(state: true)
        delegate.changePageControl(index: 4)
    }
    
    // MARK: - Private -
    private func setupSlider() {
        slider.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func valueChanged(sender: TGPDiscreteSlider) {
        if sender.value != selectedState {
            selectedState = sender.value
            changeState(value: selectedState)
        }
    }
    
    // MARK: - Private -
    private func changeState(value: CGFloat) {
        switch value {
        case 0.0:
            selectedStateImageView.image = #imageLiteral(resourceName: "1_step")
            descriptionLabel.text = "Минимальная нагрузка"
        case 1.0:
            selectedStateImageView.image = #imageLiteral(resourceName: "2_step")
            descriptionLabel.text = "Легкая физическая нагрузка\nв течении дня"
        case 2.0:
            selectedStateImageView.image = #imageLiteral(resourceName: "3_step")
            descriptionLabel.text = "Тренировки 2-4 раза в неделю\n(или работа средней тяжести)"
        case 3.0:
            selectedStateImageView.image = #imageLiteral(resourceName: "4_step")
            descriptionLabel.text = "Интенсивные тренировки\n4-5 раз в неделю"
        case 4.0:
            selectedStateImageView.image = #imageLiteral(resourceName: "5_step")
            descriptionLabel.text = "Ежедневные интенсивные\nтренировки"
        case 5.0:
            selectedStateImageView.image = #imageLiteral(resourceName: "6_step")
            descriptionLabel.text = "Тренировки 5-7 раз в неделю,\nпо два раза в день"
        case 6.0:
            selectedStateImageView.image = #imageLiteral(resourceName: "7_step")
            descriptionLabel.text = "Тяжелая физическая работа или\nежедневные интенсивные тренировки\nпо 2 раза в день"
        default:
            break
        }
        UserInfo.sharedInstance.registrationFlow.loadActivity = value
    }
}
