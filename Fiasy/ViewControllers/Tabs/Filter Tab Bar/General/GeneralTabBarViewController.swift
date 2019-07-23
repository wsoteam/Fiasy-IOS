//
//  GeneralTabBarViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import VisualEffectView

protocol GeneralTabBarDelegate {
    func searchByText(text: String)
}

class GeneralTabBarViewController: ButtonBarPagerTabStripViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var blurView: VisualEffectView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var searchTextField: DesignableUITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        
        titleLabel.text = UserInfo.sharedInstance.getTitleMealtime(text: UserInfo.sharedInstance.getTitleMealtimeForFirebase())
        settings.style.buttonBarBackgroundColor = #colorLiteral(red: 0.9998915792, green: 1, blue: 0.9998809695, alpha: 1)
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0.946321547, green: 0.5661845803, blue: 0.1569737494, alpha: 1)
        settings.style.buttonBarItemFont = UIFont.fontRobotoMedium(size: 13)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
        settings.style.buttonBarLeftContentInset = 15
        settings.style.buttonBarRightContentInset = 15
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = #colorLiteral(red: 0.1293928325, green: 0.1294226646, blue: 0.129390955, alpha: 1)
            newCell?.label.textColor = #colorLiteral(red: 0.9386262298, green: 0.4906092286, blue: 0.001925615128, alpha: 1)
        }
        setupInitialState()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addObserver(for: self, #selector(showTemplatesScreen), "AddTemplatesScreen")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeObserver()
    }
    
    @objc func showTemplatesScreen() {
        performSegue(withIdentifier: "sequeTemplateScreen", sender: nil)
    }
    
    // MARK: - PagerTabStripDataSource -
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let firstScreen = UIStoryboard(name: "GeneralTabBar", bundle: nil).instantiateViewController(withIdentifier: "SearchTabViewController")
        let secondScreen = UIStoryboard(name: "GeneralTabBar", bundle: nil).instantiateViewController(withIdentifier: "FavoritesTabViewController")
        let thirdScreen = UIStoryboard(name: "GeneralTabBar", bundle: nil).instantiateViewController(withIdentifier: "TemplatesTabViewController")
        let fourthScreen = UIStoryboard(name: "GeneralTabBar", bundle: nil).instantiateViewController(withIdentifier: "RecipesTabViewController")
        
        guard let first = firstScreen as? SearchTabViewController, let second = secondScreen as? FavoritesTabViewController, let third = thirdScreen as? TemplatesTabViewController, let fourth = fourthScreen as? RecipesTabViewController else {
            return []
        }
        return [first, second, third, fourth]
    }
    
    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        if indexWasChanged {
            searchTextField.endEditing(true)
            searchTextField.text?.removeAll()
        }
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchProduct(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            UserInfo.sharedInstance.searchProductText = ""
            return post("searchClicked")
        }
    }
    
    @IBAction func blurFilterClicked(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            performSegue(withIdentifier: "sequeAddProductScreen", sender: nil)
        case 2:
            showTemplatesScreen()
        default:
            break
        }
        
        blurView.fadeOut(secondView: filterView)
    }
    
    @IBAction func filterClicked(_ sender: Any) {
        if filterView.isHidden {
            blurView.fadeIn(secondView: filterView)
        } else {
            blurView.fadeOut(secondView: filterView)
            
        }
    }
    
    // MARK: - Private -
    private func setupInitialState() {
        blurView.colorTint = .gray
        blurView.colorTintAlpha = 0.1
        blurView.blurRadius = 5
        blurView.scale = 1
    }
}

extension GeneralTabBarViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        UserInfo.sharedInstance.searchProductText = text
        post("searchClicked")
        return true
    }
}
