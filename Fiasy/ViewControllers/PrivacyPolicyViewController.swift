import UIKit
import Amplitude_iOS

class PrivacyPolicyViewController: UIViewController {
    
    //MARK: - Outlet -
    @IBOutlet weak var titleNavigationLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    //MARK: - Properties -
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleNavigationLabel.text = LS(key: .PRIVACY_DESCRIPTION)
        textView.setContentOffset(.zero, animated: false)
        textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
    }
    
    //MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
//
//extension PrivacyPolicyViewController: UIScrollViewDelegate, UITextViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if ((scrollView as? UITextView) != nil) {
//            if scrollView.contentOffset.y < 0.0 {
//                self.textView.isScrollEnabled = false
//                self.scrollView.isScrollEnabled = true
//            }
//        } else {
//            guard scrollView.contentOffset.y > 0 else {
//                return scrollView.contentOffset = CGPoint(x: 0, y: 0) }
//            if (contentView.frame.origin.y - 40) < scrollView.contentOffset.y {
//                self.scrollView.contentOffset = CGPoint(x: 0, y: contentView.frame.origin.y - 40)
//                self.scrollView.isScrollEnabled = false
//                self.textView.isScrollEnabled = true
//            }
//        }
//    }
//}

