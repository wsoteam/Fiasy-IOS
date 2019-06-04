//
//  DiaryViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Parchment
import Firebase
import FirebaseDatabase
import MBCircularProgressBar
import Amplitude_iOS

class DiaryViewController: BaseViewController {
    
    //MARK: - Outlets -
    @IBOutlet weak var fatProgress: MBCircularProgressBarView!
    @IBOutlet weak var carbohydratesProgress: MBCircularProgressBarView!
    @IBOutlet weak var proteinProgress: MBCircularProgressBarView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableViewContentHeight: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleCaloriesLabel: UILabel!
    @IBOutlet weak var caloriesProgress: MBCircularProgressBarView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var carbohydratesLabel: UILabel!
    @IBOutlet weak var squirrelsLabel: UILabel!
    
    //MARK: - Properties -
    private let isIphone5 = Display.typeIsLike == .iphone5
    private var isFirstLoad: Bool = true
    private var selectedDate = Date()
    private let pagingViewController = PagingViewController<CalendarItem>()
    private weak var secondViewController: SecondMainViewController?
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillView()
        getItemsInDataBase()
        Amplitude.instance().logEvent("view_diary")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserInfo.sharedInstance.isReload {
            UserInfo.sharedInstance.isReload = false
            getItemsInDataBase()
        }
        addObserver(for: self, #selector(showProductDetails), Constant.SHOW_PRODUCT_LIST)
        addObserver(for: self, #selector(reloadDiary), Constant.RELOAD_DIARY)
        
        if UserInfo.sharedInstance.allProducts.isEmpty {
            SQLDatabase.shared.fetchProducts()
        }
        if UserInfo.sharedInstance.allRecipes.isEmpty {
            UserInfo.sharedInstance.getAllRecipes()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let second = secondViewController {
            second.tableView.layoutIfNeeded()
            scrollView.bounces = false
            second.tableView.isScrollEnabled = false
            let height = self.tabBarController?.tabBar.frame.height ?? 49.0
            tableViewContentHeight.constant = UIScreen.main.bounds.height - height
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    //MARK: - Private -
    private func fillView() {
        
        topViewHeight.constant = CustomPagingView.getHeaderHeight()
        fatsLabel.attributedText = fillDescription(title: "Жиры", count: 0)
        carbohydratesLabel.attributedText = fillDescription(title: "Углеводы", count: 0)
        squirrelsLabel.attributedText = fillDescription(title: "Белки", count: 0)
        caloriesLabel.font = caloriesLabel.font?.withSize(isIphone5 ? 12.0 : 14.0)
        
        pagingViewController.menuItemSize = .fixed(width: UIScreen.main.bounds.width, height: 0.0)
        addChild(pagingViewController)
        
        viewContainer.addSubview(pagingViewController.view)
        viewContainer.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
    
        pagingViewController.delegate = self
        pagingViewController.infiniteDataSource = self
        
        selectedDate = Date()
        pagingViewController.select(pagingItem: CalendarItem(date: Date()))
        dateLabel.text = DateFormatters.shortDateFormatter.string(from: Date())
        UserInfo.sharedInstance.selectedDate = Date()
    }
    
    private func getItemsInDataBase() {
        showPreloader(isShow: true)
        FirebaseDBManager.getMealtimeItemsInDataBase { [unowned self] (error) in
            if let error = error {
                //
            } else {
                DispatchQueue.main.async(execute: {
                    self.fillTopContainer()
                    self.secondViewController?.tableView.reloadData()
                })
            }
            self.showPreloader(isShow: false)
        }
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    private func fillDescription(title: String, count: Int) -> NSMutableAttributedString {
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
    
    private func getCaloriesTitle(count: String,  currency: String, wholeSize: CGFloat, сurrencySize: CGFloat, currencyOffset: CGFloat) -> NSMutableAttributedString {
        
        let mutableAttrString = NSMutableAttributedString()
        mutableAttrString.append(NSAttributedString(string: count,
                                                    attributes: setAttributes(size: wholeSize)))
        mutableAttrString.append(NSAttributedString(string: currency, attributes: [.font : UIFont.fontRobotoMedium(size: сurrencySize), .baselineOffset: currencyOffset]))
        
        return mutableAttrString
    }
    
    private func setAttributes(size: CGFloat) -> [NSAttributedString.Key : NSObject] {
        return [NSAttributedString.Key.font: UIFont.fontRobotoMedium(size: size)]
    }
    
    private func fillTopContainer() {
        let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: selectedDate)!
        let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: selectedDate)!
        let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: selectedDate)!
        
        var calories: Int = 0
        var protein: Int = 0
        var fat: Int = 0
        var carbohydrates: Int = 0
        if !UserInfo.sharedInstance.allMealtime.isEmpty {
            for item in UserInfo.sharedInstance.allMealtime where item.day == day && item.month == month && item.year == year {
                fat += item.fat ?? 0
                calories += item.calories ?? 0
                protein += item.protein ?? 0
                carbohydrates += item.carbohydrates ?? 0
            }
        }
        fatProgress.value = CGFloat(fat)
        caloriesProgress.value = CGFloat(calories)
        proteinProgress.value = CGFloat(protein)
        carbohydratesProgress.value = CGFloat(carbohydrates)
        
        fatProgress.progressColor = fat <= (UserInfo.sharedInstance.currentUser?.maxFat ?? 0) ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.8759917617, green: 0.3424766958, blue: 0.05536212772, alpha: 1)
        caloriesProgress.progressColor = calories <= (UserInfo.sharedInstance.currentUser?.maxKcal ?? 0) ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.8759917617, green: 0.3424766958, blue: 0.05536212772, alpha: 1)
        proteinProgress.progressColor = protein <= (UserInfo.sharedInstance.currentUser?.maxProt ?? 0) ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.8759917617, green: 0.3424766958, blue: 0.05536212772, alpha: 1)
        carbohydratesProgress.progressColor = carbohydrates <= (UserInfo.sharedInstance.currentUser?.maxCarbo ?? 0) ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.8759917617, green: 0.3424766958, blue: 0.05536212772, alpha: 1)
        
        let count = calories < (UserInfo.sharedInstance.currentUser?.maxKcal ?? 0) ? ((UserInfo.sharedInstance.currentUser?.maxKcal ?? 0) - calories) : 0
        caloriesProgress.maxValue = CGFloat(calories < (UserInfo.sharedInstance.currentUser?.maxKcal ?? 0) ? (UserInfo.sharedInstance.currentUser?.maxKcal ?? 0) : calories)
        titleCaloriesLabel.attributedText = getCaloriesTitle(count: "     \(calories)", currency: "+\(count)", wholeSize: 25, сurrencySize: 14, currencyOffset: 20.0)
        fatProgress.maxValue = CGFloat(fat < (UserInfo.sharedInstance.currentUser?.maxFat ?? 0) ? (UserInfo.sharedInstance.currentUser?.maxFat ?? 0) : fat)
        proteinProgress.maxValue = CGFloat(protein < (UserInfo.sharedInstance.currentUser?.maxProt ?? 0) ? (UserInfo.sharedInstance.currentUser?.maxProt ?? 0) : protein)
        carbohydratesProgress.maxValue = CGFloat(carbohydrates < (UserInfo.sharedInstance.currentUser?.maxCarbo ?? 0) ? (UserInfo.sharedInstance.currentUser?.maxCarbo ?? 0) : carbohydrates)
        
        fatsLabel.attributedText = fillDescription(title: "Жиры", count: fat < (UserInfo.sharedInstance.currentUser?.maxFat ?? 0) ? (UserInfo.sharedInstance.currentUser?.maxFat ?? 0) - fat : 0)
        carbohydratesLabel.attributedText = fillDescription(title: "Углеводы", count: carbohydrates < (UserInfo.sharedInstance.currentUser?.maxCarbo ?? 0) ? (UserInfo.sharedInstance.currentUser?.maxCarbo ?? 0) - carbohydrates : 0)
        squirrelsLabel.attributedText = fillDescription(title: "Белки", count: protein < (UserInfo.sharedInstance.currentUser?.maxProt ?? 0) ? (UserInfo.sharedInstance.currentUser?.maxProt ?? 0) - protein : 0)
    }
    
    //MARK: - Actions -
    @IBAction func nextControllClicked(_ sender: UIButton) {
        let date = sender.tag == 0 ? selectedDate.yesterday() : selectedDate.tomorrow()
        pagingViewController.select(pagingItem: CalendarItem(date: date), animated: true)
    }
    
    @objc func showProductDetails() {
        performSegue(withIdentifier: "sequeProductsList", sender: nil)
    }
    
    @objc func reloadDiary() {
        getItemsInDataBase()
    }
}

extension DiaryViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            guard scrollView.contentOffset.y > 0 else {
                return scrollView.contentOffset = CGPoint(x: 0, y: 0) }
            guard let second = secondViewController else { return }
            if let view = dateLabel.superview, (view.frame.origin.y - 10) < scrollView.contentOffset.y {
                scrollView.contentOffset = CGPoint(x: 0, y: view.frame.origin.y - 10)
                second.tableView.isScrollEnabled = true
            }
        }
    }
}

extension DiaryViewController: PagingViewControllerInfiniteDataSource {
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForPagingItem pagingItem: T) -> UIViewController {
        guard let viewController = UIStoryboard(name: "Diary", bundle: nil).instantiateViewController(withIdentifier: "SecondMainViewController") as? SecondMainViewController else {
            return UIViewController()
        }
        let _ = viewController.view
        if isFirstLoad {
            isFirstLoad = false
            let calendarItem = pagingItem as! CalendarItem
            if DateFormatters.shortDateFormatter.string(from: Date()) == DateFormatters.shortDateFormatter.string(from: calendarItem.date) {
                secondViewController = viewController
                secondViewController?.date = calendarItem.date
                if let second = secondViewController {
                    second.tableView.layoutIfNeeded()
                    tableViewContentHeight.constant = second.tableView.contentSize.height + 500
                }
            }
        }
        return viewController
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemBeforePagingItem pagingItem: T) -> T? {
        let calendarItem = pagingItem as! CalendarItem
        return CalendarItem(date: calendarItem.date.yesterday()) as? T
    }
    
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemAfterPagingItem pagingItem: T) -> T? {
        let calendarItem = pagingItem as! CalendarItem
        return CalendarItem(date: calendarItem.date.tomorrow()) as? T
    }
}

extension DiaryViewController: PagingViewControllerDelegate {
    func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, didScrollToItem pagingItem: T, startingViewController: UIViewController?, destinationViewController: UIViewController, transitionSuccessful: Bool) {
        guard let startingViewController = startingViewController as? SecondMainViewController else { return }
        guard let destinationViewController = destinationViewController as? SecondMainViewController else { return }
        let calendarItem = pagingItem as! CalendarItem
        if transitionSuccessful {
            startingViewController.tableView.delegate = nil
            selectedDate = calendarItem.date
            fillTopContainer()
            dateLabel.text = DateFormatters.shortDateFormatter.string(from: calendarItem.date)
            UserInfo.sharedInstance.selectedDate = calendarItem.date
            secondViewController = destinationViewController
            secondViewController?.date = calendarItem.date
            secondViewController?.tableView.reloadData()
        }
    }
}
