//
//  PhysicalActivityCell.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/20/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class PhysicalActivityCell: UITableViewCell {
    
    //MARK: - Outlets -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var radioButton: LTHRadioButton!
    
    //MARK: - Properties -
    private var delegate: PhysicalActivityDelegate?
    
    //MARK: - Interface -
    func fillCell(indexPath: IndexPath, delegate: PhysicalActivityDelegate) {
        self.delegate = delegate
        
        var title: String = ""
        var descript: String = ""
        switch indexPath.row {
        case 0:
            title = "Минимальная нагрузка"
            descript = "Работа в офисе"
        case 1:
            title = "Малоактивный"
            descript = "Дневная активность и легкие упражнения 1-3 раза в неделю"
        case 2:
            title = "Среднеактивный"
            descript = "4-5 тренировок в неделю или тяжелая физическая работа"
        case 3:
            title = "Интенсивная нагрузка"
            descript = "Интенсивные тренировки 4-5 раз в неделю"
        case 4:
            title = "Ежедневные тренировки"
            descript = "Ежедневные тренировки (в зале или проф спорт)"
        case 5:
            title = "Ежедневные интенсивные тренировки"
            descript = "Интенсивные тренировки или тренировки 2 раза в день"
        case 6:
            title = "Сверхтяжелые нагрузки"
            descript = "Тяжелая физическая работа или интенсивные тренировки 2 раза в день"
        default:
            break
        }
        
        titleLabel.text = title
        descriptionLabel.text = descript
        
        if UserInfo.sharedInstance.currentUser?.exerciseStress == title {
            radioButton.select()
        } else {
            radioButton.deselect()
        }
    }
    
    //MARK: - Action -
    @IBAction func activityClicked(_ sender: Any) {
        guard let text = titleLabel.text, !text.isEmpty else { return }
        UserInfo.sharedInstance.physicalActivity = text
        UserInfo.sharedInstance.registrationPhysicalActivity = text
        delegate?.closeModule()
    }
}
