//
//
//
//import UIKit
//
//class RouterManager: NSObject {
//    static let sharedInstance = RouterManager()
//    public var mainNavigationController: UINavigationController
//    let appDelegate: AppDelegate = (UIApplication.shared.delegate as? AppDelegate)!
//
//    override init() {
//        let mainStoryboard = UIStoryboard(name: "Login", bundle: nil)
//        mainNavigationController = (mainStoryboard.instantiateViewController(withIdentifier: "BaseNavigationController") as! UINavigationController)
//    }
//
//    func initialController() -> UINavigationController {
//        let mainStoryboard = UIStoryboard(name: "Login", bundle: nil)
//        mainNavigationController = (mainStoryboard.instantiateViewController(withIdentifier: "BaseNavigationController") as! UINavigationController)
//        return mainNavigationController
//    }
//
//    // MARK: - Show Login
//    func showLoginViewController(navigationController: UINavigationController?) {
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        navigationController?.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    func showLogin() {
//        self.appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "Login", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "BaseNavigationController")
//        self.appDelegate.window?.rootViewController = initialViewController
//        self.appDelegate.window?.makeKeyAndVisible()
//
//        mainNavigationController = initialViewController as! UINavigationController
//    }
//
//    // MARK: - Show SignUp
//    func showSignUpViewController(navigationController: UINavigationController?) {
//        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
//        navigationController?.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: - Show ForgotPassword
//    func showForgotPasswordController(navigationController: UINavigationController?) {
//        let storyboard = UIStoryboard(name: "ForgotPassword", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
//        navigationController?.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: - Show ResetPassword
//    func showResetPasswordController(navigationController: UINavigationController?) {
//        let storyboard = UIStoryboard(name: "ResetPassword", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
//        navigationController?.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: - Show ChooseTeam
//    func showChooseTeamViewController(navigationController: UINavigationController?) {
//        let storyboard = UIStoryboard(name: "ChooseTeam", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "ChooseTeamViewController") as! ChooseTeamViewController
//        navigationController?.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: - Start with choose team screen
//    func startWithChooseTeam() {
//        self.appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "ChooseTeam", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "BaseNavigationController")
//        self.appDelegate.window?.rootViewController = initialViewController
//        self.appDelegate.window?.makeKeyAndVisible()
//        mainNavigationController = initialViewController as! UINavigationController
//    }
//
//    // MARK: - Show main ChooseTeam
//    func showMainChooseTeamViewController() {
//        self.appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "ChooseTeam", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "BaseNavigationController")
//
//        mainNavigationController = initialViewController as! UINavigationController
//
//        self.appDelegate.window?.rootViewController = initialViewController
//        self.appDelegate.window?.makeKeyAndVisible()
//    }
//
//    // MARK: - Load Home Tabbar
//    func loadHomeTabbarViewController() {
//        self.appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "TabBarController", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
//
//        //  Update Tab
//        let updateStoryboard = UIStoryboard(name: "Updates", bundle: Bundle.main)
//        let updateVC = updateStoryboard.instantiateViewController(withIdentifier: "UpdatesViewController") as! UpdatesViewController
//        let updateTab = UITabBarItem(title: "Updates", image: UIImage(named: "group7"), selectedImage: UIImage(named: "group7"))
//        updateVC.tabBarItem = updateTab
//
//        //  Legacy Tab
//        let legacyStoryBoard = UIStoryboard(name: "Legacy", bundle: Bundle.main)
//        let legacyVC = legacyStoryBoard.instantiateViewController(withIdentifier: "LegacyViewController") as! LegacyViewController
//        let legacyTab = UITabBarItem(title: "Legacy", image: UIImage(named: "LegacyTab"), selectedImage: UIImage(named: "LegacyTab"))
//        legacyVC.tabBarItem = legacyTab
//
//        //  CheckIn Tab
//        let checkInStoryboard = UIStoryboard(name: "CheckIn", bundle: Bundle.main)
//        let checkInVc = checkInStoryboard.instantiateViewController(withIdentifier: "CheckInViewController") as! CheckInViewController
//        let checkInTab = UITabBarItem(title: "Check-In", image: UIImage(named: "group"), selectedImage: UIImage(named: "group"))
//        checkInVc.delegate = legacyVC
//        checkInVc.tabBarItem = checkInTab
//
//        // Profile Tab
//        let profileStoryboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
//        let profileVc = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//        let profileTab = UITabBarItem(title: "Profile", image: UIImage(named: "profileTab"), selectedImage: UIImage(named: "profileTab"))
//        profileVc.tabBarItem = profileTab
//
//        initialViewController.tabbarViewControllers = [updateVC, legacyVC,checkInVc,profileVc]
//
//        let storyboard2 = UIStoryboard(name: "TabBarController", bundle: nil)
//        let navigationController = storyboard2.instantiateViewController(withIdentifier: "TabbarNavigationController") as! UINavigationController
//        navigationController.isNavigationBarHidden = false
//        navigationController.viewControllers = [initialViewController]
//
//        self.appDelegate.window?.rootViewController = navigationController
//        self.appDelegate.window?.makeKeyAndVisible()
//
//        mainNavigationController = navigationController
//    }
//
//    // MARK - Show Profile
//    func showProfileViewController() {
//        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: - Home Screen
//    func showHomeViewController() {
//        loadHomeTabbarViewController()
//    }
//
//    // MARK: - Edit Profile
//    func showEditProfileViewController() {
//        let storyboard = UIStoryboard(name: "EditProfile", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: - NotificationSettings
//    func showNotificationSettingsViewController() {
//        let storyboard = UIStoryboard(name: "NotificationSettings", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "NotificationSettingsViewController") as! NotificationSettingsViewController
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: - DiscoverPeople
//    func showDiscoverPeopleViewController() {
//        let storyboard = UIStoryboard(name: "DiscoverPeople", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "DiscoverPeopleViewController") as! DiscoverPeopleViewController
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: - LegacyTabStats
//    func showLegacyTabStatsViewController(meStat: StatsModel, index: Int, navigationController: UINavigationController?) {
//        let storyboard = UIStoryboard(name: "LegacyTabStats", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "LegacyTabStatsViewController") as! LegacyTabStatsViewController
//        pushViewConttroler.meStat = meStat
//        pushViewConttroler.index = index
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: - LegacyTabStats
//    func showLegacyFilterViewController() {
//        let storyboard = UIStoryboard(name: "Legacy", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "LegacyFilterViewController") as! LegacyFilterViewController
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: - Mementos Details
//    func showMementosDetailsViewController(memento:MementoModel, typeMode: TypeMode, mementoId: Int?, gameId: String?, createDate: String?, stadium: String?, location: String?, isNewsForYourFriend: Bool?, navigationController: UINavigationController?) {
//
//        let storyboard = UIStoryboard(name: "MementoDetail", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "MementoDetailViewController") as! MementoDetailViewController
//        pushViewConttroler.stadiumName = stadium
//        pushViewConttroler.typeMode = typeMode
//        pushViewConttroler.location = location
//        pushViewConttroler.isNewsForYourFriend = isNewsForYourFriend
//        pushViewConttroler.createDateMemento = createDate
//        if (memento != nil)
//        {
//           pushViewConttroler.mementoModel = memento
//        }
//        if (mementoId != nil)
//        {
//            pushViewConttroler.mementoId = mementoId
//        }
//        pushViewConttroler.gameId = gameId
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    func showMementosDetailsWithGame(typeMode: TypeMode, resultGameModel: GameResultModel, navigationController: UINavigationController?) {
//
//        let storyboard = UIStoryboard(name: "MementoDetail", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "MementoDetailViewController") as! MementoDetailViewController
//        pushViewConttroler.typeMode = typeMode
//        pushViewConttroler.gameId =   resultGameModel.id
//        pushViewConttroler.gameResultModel = resultGameModel
//        pushViewConttroler.createDateMemento = resultGameModel.scheduled
//        pushViewConttroler.isNewsForYourFriend = false
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    func showFriendMemento(targetId: Int) {
//        let storyboard = UIStoryboard(name: "MementoDetail", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "MementoDetailViewController") as! MementoDetailViewController
//        pushViewConttroler.typeMode = .Show
//        pushViewConttroler.isNewsForYourFriend = true
//        pushViewConttroler.mementoId = Int(targetId)
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: - Mementos Details
//    func showLocationViewController(gameModel: GameResultModel?, typeVC: LocationType ,navigationController: UINavigationController?) {
//        let storyboard = UIStoryboard(name: "Location", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
//        pushViewConttroler.gameResultModel = gameModel
//        pushViewConttroler.locationType = typeVC
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: - Mementos Details
//    func showLegacy() {
//        let storyboard = UIStoryboard(name: "Legacy", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "LegacyViewController") as! LegacyViewController
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: - Friends
//    func showFriends() {
//        let storyboard = UIStoryboard(name: "Friends", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//    // MARK: - CHANGE PASSWORD
//    func showChangePasswordVC() {
//        let storyboard = UIStoryboard(name: "ChangePass", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "ChangePassViewController") as! ChangePassViewController
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//
//    // MARK: - Show Future game
//    func showFutureGame(url: String, isWished: Bool, gameId: String) {
//        let storyboard = UIStoryboard(name: "PastLegacy", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "PastLegacyViewController") as! PastLegacyViewController
//        pushViewConttroler.url = url
//        pushViewConttroler.gameId = gameId
//        pushViewConttroler.isWished = isWished
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: Show Game Result
//    func showResultGame(url: String?, isWatched: Bool?, gameResult: GameResultModel?) {
//        let storyboard =  UIStoryboard(name: "GameResult", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "GameResultViewController") as! GameResultViewController
//        pushViewConttroler.url = url
//        pushViewConttroler.gameResultModel = gameResult
//        pushViewConttroler.isWatched = isWatched
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: Show Active Game
//    func showActiveGame(gameResult: GameResultModel?) {
//        let storyboard =  UIStoryboard(name: "ActiveGame", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "ActiveGameViewController") as! ActiveGameViewController
//        pushViewConttroler.gameResultModel = gameResult
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: Show Old Game Result
//    func showoldGameResult(gameResultModel: GameResultModel, isWatched: Bool?) {
//        let storyboard =  UIStoryboard(name: "OldGameResult", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "OldGameResultViewController") as! OldGameResultViewController
//        pushViewConttroler.gameResultModel = gameResultModel
//        pushViewConttroler.isWatched = isWatched
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//
//    // MARK: Show Old Game Result
//    func showAnnounceGame(url: String) {
//        let detailVC = UIStoryboard(name: "DetailGame", bundle: nil).instantiateViewController(withIdentifier: "DetailGameViewController") as! DetailGameViewController
//        detailVC.typeModel = "mlb_announces"
//        detailVC.urlString = url
//
//        let initialViewController = UIStoryboard(name: "TabBarController", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarVC") as! MainTabBarVC
//        let detailTab = UITabBarItem(title: "Share", image: UIImage(named: "share"), selectedImage: UIImage(named: "share"))
//        detailVC.tabBarItem = detailTab
//        initialViewController.tabbarViewControllers = [detailVC]
//        mainNavigationController.pushViewController(initialViewController, animated: true)
//    }
//
//    // MARK: - Show Updates Feed
//    func showUpdatesFeed() {
//        mainNavigationController.popViewController(animated: true)
//    }
//
//    // MARK: - Show WebView
//    func showWebView(url: String) {
//        let storyboard =  UIStoryboard(name: "WebView", bundle: nil)
//        let pushViewConttroler = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
//        pushViewConttroler.url = url
//        mainNavigationController.pushViewController(pushViewConttroler, animated: true)
//    }
//}
