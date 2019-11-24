

import UIKit

class SecondMainCell: UITableViewCell {
    
    //MARK: - Outlets -
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var mealtimeTitleLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var insertStackView: UIStackView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    //MARK: - Properties -
    private var delegate: SecondMainManagerDelegate?
    private var isArrowSelected: Bool = false
    private var indexCell: IndexPath?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clearStackView()
        caloriesLabel.text = "0 Ккал"
        fatLabel.text = "Ж. 0"
        carbohydratesLabel.text = "У. 0"
        proteinLabel.text = "Б. 0"
    }
    
    //MARK: - Interface -
    func fillCell(state: Bool, indexCell: IndexPath, delegate: SecondMainManagerDelegate, selectedDate: Date) {
        self.delegate = delegate
        self.isArrowSelected = state
        self.indexCell = indexCell
        
        insertStackView.isHidden = !state
        arrowImageView.image = state ? #imageLiteral(resourceName: "Polygon") : #imageLiteral(resourceName: "Polygon-2")
        
        let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: selectedDate)!
        let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: selectedDate)!
        let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: selectedDate)!
        
        var allFat: Int = 0
        var allProtein: Int = 0
        var allCalories: Int = 0
        var allCarbohydrates: Int = 0
        
        switch indexCell.row {
        case 0:
            mealtimeTitleLabel.text = "Завтрак"

            if !UserInfo.sharedInstance.breakfasts.isEmpty {
//                for (index,item) in UserInfo.sharedInstance.breakfasts.enumerated() where item.day == day && item.month == month && item.year == year {
//                    guard let view = InsertDiaryView.fromXib() else { return }
//                    view.fillView(by: item, delegate: self.delegate, index: index, indexPath: indexCell)
//                    allFat += item.fat ?? 0
//                    allProtein += item.protein ?? 0
//                    allCalories += item.calories ?? 0
//                    allCarbohydrates += item.carbohydrates ?? 0
//                    insertStackView.addArrangedSubview(view)
//                }
            }
        case 1:
            mealtimeTitleLabel.text = "Обед"
            
            if !UserInfo.sharedInstance.lunches.isEmpty {
//                for (index,item) in UserInfo.sharedInstance.lunches.enumerated() where item.day == day && item.month == month && item.year == year {
//                    guard let view = InsertDiaryView.fromXib() else { return }
//                    view.fillView(by: item, delegate: self.delegate, index: index, indexPath: indexCell)
//                    allFat += item.fat ?? 0
//                    allProtein += item.protein ?? 0
//                    allCalories += item.calories ?? 0
//                    allCarbohydrates += item.carbohydrates ?? 0
//                    insertStackView.addArrangedSubview(view)
//                }
            }
        case 2:
            mealtimeTitleLabel.text = "Ужин"
            
//            if !UserInfo.sharedInstance.dinners.isEmpty {
//                for (index,item) in UserInfo.sharedInstance.dinners.enumerated() where item.day == day && item.month == month && item.year == year {
//                    guard let view = InsertDiaryView.fromXib() else { return }
//                    view.fillView(by: item, delegate: self.delegate, index: index, indexPath: indexCell)
//                    allFat += item.fat ?? 0
//                    allProtein += item.protein ?? 0
//                    allCalories += item.calories ?? 0
//                    allCarbohydrates += item.carbohydrates ?? 0
//                    insertStackView.addArrangedSubview(view)
//                }
//            }
        case 3:
            mealtimeTitleLabel.text = "Перекус"
//            
//            if !UserInfo.sharedInstance.snacks.isEmpty {
//                for (index,item) in UserInfo.sharedInstance.snacks.enumerated() where item.day == day && item.month == month && item.year == year {
//                    guard let view = InsertDiaryView.fromXib() else { return }
//                    view.fillView(by: item, delegate: self.delegate, index: index, indexPath: indexCell)
//                    allFat += item.fat ?? 0
//                    allProtein += item.protein ?? 0
//                    allCalories += item.calories ?? 0
//                    allCarbohydrates += item.carbohydrates ?? 0
//                    insertStackView.addArrangedSubview(view)
//                }
//            }
        default:
            break
        }
        
        caloriesLabel.text = "\(allCalories) Ккал"
        fatLabel.text = "Ж. \(allFat)"
        carbohydratesLabel.text = "У. \(allCarbohydrates)"
        proteinLabel.text = "Б. \(allProtein)"
    }
    
    private func clearStackView() {
        for view in insertStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    //MARK: - Actions -
    @IBAction func showMoreClicked(_ sender: Any) {
        guard let index = indexCell else { return }
        self.delegate?.showMoreDescription(state: isArrowSelected, indexPath: index)
    }
    
    @IBAction func plusClicked(_ sender: Any) {
        guard let indexCell = indexCell?.row else { return }
        self.delegate?.selectedMealtime(by: indexCell)
    }
}

