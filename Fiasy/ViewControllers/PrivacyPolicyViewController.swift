import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    //MARK: - Outlet -
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    //MARK: - Properties -
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.isHidden = navigationController == nil
        closeButton.isHidden = navigationController != nil
    }
    
    //MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension PrivacyPolicyViewController: UIScrollViewDelegate, UITextViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView as? UITextView) != nil) {
            if scrollView.contentOffset.y < 0.0 {
                self.textView.isScrollEnabled = false
                self.scrollView.isScrollEnabled = true
            }
        } else {
            guard scrollView.contentOffset.y > 0 else {
                return scrollView.contentOffset = CGPoint(x: 0, y: 0) }
            if (contentView.frame.origin.y - 40) < scrollView.contentOffset.y {
                self.scrollView.contentOffset = CGPoint(x: 0, y: contentView.frame.origin.y - 40)
                self.scrollView.isScrollEnabled = false
                self.textView.isScrollEnabled = true
            }
        }
    }
}

