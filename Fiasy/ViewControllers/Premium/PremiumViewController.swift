import UIKit
import Amplitude_iOS

class PremiumViewController: UIViewController, UIScrollViewDelegate {

    //MARK: - Outlet -
    @IBOutlet weak var completeFinishView: UIView!
    @IBOutlet var finishViews: [UIView]!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var buttonHeight: NSLayoutConstraint!
    @IBOutlet weak var premiumTitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    // MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var slides: [PremiumSlideView] = []
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)

        if isIphone5 {
            nextButton.cornerRadius = 17.5
            buttonHeight.constant = 35
            premiumTitleLabel.font = premiumTitleLabel.font.withSize(19)
        }
        
        if UserInfo.sharedInstance.paymentComplete {
            premiumTitleLabel.text = "Fiasy Premium"
            for item in finishViews {
                item.alpha = 0
            }
            completeFinishView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver(for: self, #selector(paymentComplete), Constant.PAYMENT_COMPLETE)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageControl.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    }
    
    @objc func paymentComplete() {
        UserInfo.sharedInstance.paymentComplete = true
        DispatchQueue.global().async {
            UserInfo.sharedInstance.purchaseIsValid = SubscriptionService.shared.checkValidPurchases()
        }
        premiumTitleLabel.text = "Fiasy Premium"
        for item in finishViews {
            item.alpha = 0
        }
        completeFinishView.isHidden = false
    }
    
    func setupSlideScrollView(slides: [PremiumSlideView]) {
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    // MARK: - Action's -
    @IBAction func showPrivacyClicked(_ sender: Any) {
        if let url = URL(string: "http://fiasy.com/PrivacyPolice.html") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func purchedClicked(_ sender: Any) {
        SubscriptionService.shared.purchase()
    }
    
    //MARK: - Private -
    private func createSlides() -> [PremiumSlideView] {
        let slide1: PremiumSlideView = Bundle.main.loadNibNamed("PremiumSlideView", owner: self, options: nil)?.first as! PremiumSlideView
        slide1.imageView.image = #imageLiteral(resourceName: "prem_1")
        slide1.titleLabel.text = "Узнать КБЖУ продукта \nпо камере телефона"

        let slide2: PremiumSlideView = Bundle.main.loadNibNamed("PremiumSlideView", owner: self, options: nil)?.first as! PremiumSlideView
        slide2.imageView.image = #imageLiteral(resourceName: "prem_2")
        slide2.titleLabel.text = "Сотни рецептов с КБЖУ"
        
        let slide3: PremiumSlideView = Bundle.main.loadNibNamed("PremiumSlideView", owner: self, options: nil)?.first as! PremiumSlideView
        slide3.imageView.image = #imageLiteral(resourceName: "prem_3")
        slide3.titleLabel.text = "Планы питания и \nконтроль веса"
        
        let slide4: PremiumSlideView = Bundle.main.loadNibNamed("PremiumSlideView", owner: self, options: nil)?.first as! PremiumSlideView
        slide4.imageView.image = #imageLiteral(resourceName: "prem_4")
        slide4.titleLabel.text = "Тысяча продуктов в базе"
        
        let slide5: PremiumSlideView = Bundle.main.loadNibNamed("PremiumSlideView", owner: self, options: nil)?.first as! PremiumSlideView
        slide5.imageView.image = #imageLiteral(resourceName: "prem_5")
        slide5.titleLabel.text = "Специальные статьи \nо правильном питании"
        
        return [slide1, slide2, slide3, slide4, slide5]
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0
        
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset

        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            
            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
            
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
            
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
            
        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
            slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
            slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
        }
    }
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        if(pageControl.currentPage == 0) {
            //Change background color to toRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1
            //Change pageControl selected color to toRed: 103/255, toGreen: 58/255, toBlue: 183/255, fromAlpha: 0.2
            //Change pageControl unselected color to toRed: 255/255, toGreen: 255/255, toBlue: 255/255, fromAlpha: 1
            
            let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.pageIndicatorTintColor = pageUnselectedColor
            
            
            let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            slides[pageControl.currentPage].backgroundColor = bgColor
            
            let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.currentPageIndicatorTintColor = pageSelectedColor
        }
    }
    
    
    func fade(fromRed: CGFloat,
              fromGreen: CGFloat,
              fromBlue: CGFloat,
              fromAlpha: CGFloat,
              toRed: CGFloat,
              toGreen: CGFloat,
              toBlue: CGFloat,
              toAlpha: CGFloat,
              withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
