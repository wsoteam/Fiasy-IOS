

import UIKit

class PremiumViewController: BaseViewController {

    @IBOutlet weak var treeMontsBtn: UIButton!
    @IBOutlet weak var nwelveMonth: UIButton!
    @IBOutlet weak var oneMonth: UIButton!
    
   // let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func oneMonth(_ sender: Any) {
        
        self.oneMonth.layer.borderWidth = 4.0
        self.oneMonth.layer.borderColor = UIColor(red:253/255, green:91/255, blue:28/255, alpha: 1).cgColor

        self.oneMonth.layer.masksToBounds = true
        self.nwelveMonth.layer.borderColor =  UIColor.white.cgColor
        self.treeMontsBtn.layer.borderColor =  UIColor.white.cgColor
        
    }
    @IBAction func threeMonth(_ sender: Any) {
        loadHomeTabbarViewController()
        self.treeMontsBtn.layer.borderWidth = 4.0
        self.treeMontsBtn.layer.borderColor = UIColor(red:253/255, green:91/255, blue:28/255, alpha: 1).cgColor
        self.treeMontsBtn.layer.masksToBounds = true
        
        self.nwelveMonth.layer.borderColor =  UIColor.white.cgColor
        self.oneMonth.layer.borderColor =  UIColor.white.cgColor
    }
    
    @IBAction func twelveMonth(_ sender: Any) {

        
        self.nwelveMonth.layer.borderWidth = 4.0
        self.nwelveMonth.layer.borderColor =  UIColor(red:253/255, green:91/255, blue:28/255, alpha: 1).cgColor
         self.nwelveMonth.layer.masksToBounds = true
      
        self.oneMonth.layer.borderColor =  UIColor.white.cgColor
        self.treeMontsBtn.layer.borderColor =  UIColor.white.cgColor
    }
     

}
