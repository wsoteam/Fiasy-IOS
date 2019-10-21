import UIKit
import Amplitude_iOS

class UnboardingViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var generalStackView: UIStackView!
    @IBOutlet weak var unboardingView: SwiftyOnboard!
    
    // MARK: - Properties -
    private var selectedIndex: Int = 0
    private let isIphone5 = Display.typeIsLike == .iphone5
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Life cicle -
    override func viewDidLoad() {
        super.viewDidLoad()

        fillTopLabel()
        unboardingView.dataSource = self
        skipButton.setTitle(LS(key: .UNBOARDING_SKEEP), for: .normal)
        nextButton.setTitle("\(LS(key: .UNBOARDING_NEXT)) ", for: .normal)
    }
    
    // MARK: - Actions -
    @IBAction func nextClicked(_ sender: Any) {
        Amplitude.instance()?.logEvent("onboarding_next", withEventProperties: ["onboarding" : "page\(selectedIndex + 1)"]) // +
        if selectedIndex >= 2 {
            Amplitude.instance()?.logEvent("onboarding_next", withEventProperties: ["onboarding" : "reg"]) // +
            performSegue(withIdentifier: "showFirstScreen", sender: nil)
        } else {
            selectedIndex += 1
            unboardingView.goToPage(index: selectedIndex, animated: true)
        }
    }
    
    @IBAction func skipClicked(_ sender: Any) {
        Amplitude.instance()?.logEvent("onboarding_skip", withEventProperties: ["onboarding" : "page\(selectedIndex + 1)"]) // +
        performSegue(withIdentifier: "showFirstScreen", sender: nil)
    }
    
    // MARK: - Private -
    private func fillTopLabel() {
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 24),
                                               color: #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1), text: "\(LS(key: .UNBOARDING_WELCOME))\n"))
        mutableAttrString.append(configureAttrString(by: UIFont.sfProTextMedium(size: 24),
                                               color: #colorLiteral(red: 0.9501664042, green: 0.6013857722, blue: 0.2910895646, alpha: 1), text: "Fiasy!"))
        topLabel.attributedText = mutableAttrString
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
}

extension UnboardingViewController: SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 3
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let page = SwiftyOnboardPage()
        switch index {
        case 0:
            page.imageView.image = #imageLiteral(resourceName: "дама 1")
            page.title.text = LS(key: .UNBOARDING_FIRST_SCREEN)
        case 1:
            page.imageView.image = #imageLiteral(resourceName: "дама 3")
            page.title.text = LS(key: .UNBOARDING_SECOND_SCREEN)
        case 2:
            page.imageView.image = #imageLiteral(resourceName: "дама 2")
            page.title.text = LS(key: .UNBOARDING_THIRD_SCREEN)
        default:
            break
        }
        page.title.textColor = #colorLiteral(red: 0.3685839176, green: 0.3686525226, blue: 0.3685796857, alpha: 1)
        if isIphone5 {
            page.title.font = page.title.font.withSize(15)
        }
        return page
    }
}
