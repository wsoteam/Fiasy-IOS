import UIKit
import Intercom
import Amplitude_iOS

class UnboardingViewController: UIViewController {
    
    //MARK: - Outlet -
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

        Intercom.logEvent(withName: "onboarding_next", metaData: ["onboarding" : selectedIndex + 1])
        Amplitude.instance()?.logEvent("onboarding_next", withEventProperties: ["onboarding" : selectedIndex + 1])
        unboardingView.dataSource = self
    }
    
    // MARK: - Actions -
    @IBAction func nextClicked(_ sender: Any) {
        Intercom.logEvent(withName: "onboarding_next", metaData: ["onboarding" : selectedIndex + 2])
        Amplitude.instance()?.logEvent("onboarding_next", withEventProperties: ["onboarding" : selectedIndex + 2])
        if selectedIndex >= 2 {
            performSegue(withIdentifier: "showFirstScreen", sender: nil)
        } else {
            selectedIndex += 1
            unboardingView.goToPage(index: selectedIndex, animated: true)
        }
    }
    
    @IBAction func skipClicked(_ sender: Any) {
        Intercom.logEvent(withName: "onboarding_skip")
        Amplitude.instance().logEvent("onboarding_skip")
        performSegue(withIdentifier: "showFirstScreen", sender: nil)
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
            page.title.text = "Множество научных статей\nо правильном питании"
        case 1:
            page.imageView.image = #imageLiteral(resourceName: "дама 3")
            page.title.text = "Полезные рецепты\nна каждый день"
        case 2:
            page.imageView.image = #imageLiteral(resourceName: "дама 2")
            page.title.text = "Удобно отслеживать свои\nдостижения"
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
