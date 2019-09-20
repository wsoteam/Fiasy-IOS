import UIKit
import Kingfisher
import Alamofire
import Amplitude_iOS
import Intercom

class ProfileViewController: UIViewController {
    
    //MARK: - Outlet -
    @IBOutlet weak var topTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabTitleLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var displayManager: ProfileDisplayManager?
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        fillFields()
//        displayManager?.reloadCells()
//        hideKeyboardWhenTappedAround()
        addObserver(for: self, #selector(reloadContent), "reloadContent")
        addObserver(for: self, #selector(reloadProfile), "reloadProfile")
        
        Amplitude.instance().logEvent("view_profile") // +
        Intercom.logEvent(withName: "view_profile") // +
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //removeObserver()
    }
    
    @objc func reloadContent() {
        displayManager?.reloadCells()
    }
    
    @objc func reloadProfile() {
        displayManager?.reloadProfile()
    }
    
    //MARK: - Private -
    private func setupInitialState() {
        displayManager = ProfileDisplayManager(tableView, self)
        
        if isIphone5 {
            topTitleConstraint.constant = 20.0
            tabTitleLable.font = tabTitleLable.font.withSize(25)
        }
    }
    
    private func fillFields() {
//        guard let profile = UserInfo.sharedInstance.currentUser else { return }
//        if let path = UserInfo.sharedInstance.currentUser?.photoUrl, let url = try? path.asURL(), !path.isEmpty && path != "default" {
//            avatarImageView.kf.indicatorType = .activity
//            let resource = ImageResource(downloadURL: url)
//            avatarImageView.kf.setImage(with: resource)
//        } else {
//            avatarImageView.image = UserInfo.sharedInstance.userGender.avatarImage
//        }
//
//        if let first = UserInfo.sharedInstance.currentUser?.firstName, let last = UserInfo.sharedInstance.currentUser?.lastName, (!first.isEmpty && first.lowercased() != "default") && (!last.isEmpty && last.lowercased() != "default") {
//            nameButton.setTitle("\(first) \(last)", for: .normal)
//        } else {
//            nameButton.setTitle("Ваше имя", for: .normal)
//        }
//        ageLabel.text = "\(UserInfo.sharedInstance.currentUser?.age ?? 20) лет"
//        dateLabel.text = "Зарегистрирован\(profile.female ?? false ? "а" : "") с \(UserInfo.sharedInstance.currentUser?.dateRegistration ?? "01.01.2019")"
    }
}

extension ProfileViewController: ProfileDelegate {
    
    func editProfile() {
        performSegue(withIdentifier: "sequeEditProfile", sender: self)
    }
    
    func showComplexityScreen() {
        performSegue(withIdentifier: "sequeTargetType", sender: self)
    }
}
