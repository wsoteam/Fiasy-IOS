
import UIKit
import Parchment
import MBCircularProgressBar

class PagingMainView: UIView {
    
    //MARK: - Outlets -
    @IBOutlet weak var caloriesProgress: MBCircularProgressBarView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var squirrelsLabel: UILabel!
    
    //MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fillView()
    }

    //MARK: - Private -
    private func fillView() {
        fatsLabel.attributedText = fillDescription(title: "Жиры", count: 32)
        carbohydratesLabel.attributedText = fillDescription(title: "Углеводы", count: 0)
        squirrelsLabel.attributedText = fillDescription(title: "Белки", count: 83)
        caloriesLabel.font = caloriesLabel.font?.withSize(isIphone5 ? 12.0 : 14.0)
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    func fillDescription(title: String, count: Int) -> NSMutableAttributedString {
        let mutableAttrString = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        let fontSize: CGFloat = isIphone5 ? 9.0 : 10.0
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center
        
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoRegular(size: fontSize),
                                                     color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: title))
        mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoMedium(size: fontSize),
                                                     color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: "\nОсталось \(count) г"))
        mutableAttrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrString.length))
        return mutableAttrString
    }
}
