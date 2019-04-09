

import UIKit

class SecondMainCell: UITableViewCell {
    
    //MARK: - Outlets -
    @IBOutlet weak var insertStackView: UIStackView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    //MARK: - Properties -
    private var delegate: SecondMainManagerDelegate?
    private var isArrowSelected: Bool = false
    private var indexCell: IndexPath?
    
    //MARK: - Interface -
    func fillCell(state: Bool, indexCell: IndexPath, delegate: SecondMainManagerDelegate) {
        self.delegate = delegate
        self.isArrowSelected = state
        self.indexCell = indexCell
        
        insertStackView.isHidden = !state
        arrowImageView.image = state ? #imageLiteral(resourceName: "Polygon-2") : #imageLiteral(resourceName: "Polygon")
    }
    
    //MARK: - Actions -
    @IBAction func showMoreClicked(_ sender: Any) {
        guard let index = indexCell else { return }
        self.delegate?.showMoreDescription(state: isArrowSelected, indexPath: index)
    }
}
