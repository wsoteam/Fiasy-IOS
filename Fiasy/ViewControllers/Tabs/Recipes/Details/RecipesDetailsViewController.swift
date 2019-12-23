//
//  RecipesDetailsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 5/3/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Kingfisher
import Amplitude_iOS

protocol PremiumDisplayDelegate {
    func showPremiumScreen()
}

protocol RecipesDetailsDelegate {
    func showAnimate()
    func showPremiumScreen()
}

class RecipesDetailsViewController: UIViewController {
    
    //MARK: - Outlet's -
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var updatePremiumButton: UIButton!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var premiumTitleLabel: UILabel!
    @IBOutlet weak var premiumImageView: UIImageView!
    
    //MARK: - Properties -
    private var ownRecipe: Bool = false
    private var screenTitle: String = LS(key: .BREAKFAST)
    private var selectedRecipe: SecondRecipe?
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertTitleLabel.text = LS(key: .RECIPE_ADDED).capitalizeFirst
        setupTableView()
        updatePremiumButton.setTitle("        \(LS(key: .RECIPE_DETAILS_SUBSC_BTN).uppercased())        ", for: .normal)
        //ownRecipe = ((backViewController() as? GeneralTabBarViewController) != nil)

        Amplitude.instance()?.logEvent("view_recipe", withEventProperties: ["recipe_item" : selectedRecipe?.recipeName]) // +
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupInitialState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset = UIEdgeInsets(top: -UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - Interface -
    func fillScreen(by recipe: SecondRecipe, title: String) {
        self.screenTitle = title
        self.selectedRecipe = recipe
    }
    
    //MARK: - Privates -
    private func setupTableView() {
        tableView.register(type: DishDescriptionCell.self)
        tableView.register(RecipesHeaderDetailsView.nib, forHeaderFooterViewReuseIdentifier: RecipesHeaderDetailsView.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupInitialState() {
//        if ownRecipe {
//            premiumView.isHidden = true
//        } else {
            if UserInfo.sharedInstance.purchaseIsValid {
                premiumView.isHidden = true
                tableView.reloadData()
            } else {
                premiumView.isHidden = false
                if let path = selectedRecipe?.imageUrl, let url = try? path.asURL() {
                    premiumImageView.kf.indicatorType = .activity
                    let resource = ImageResource(downloadURL: url)
                    premiumImageView.kf.setImage(with: resource)
                }
                
                let mutableAttrString = NSMutableAttributedString()
                mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoLight(size: 32.0),
                                                             color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: "\(LS(key: .RECIPE_DETAILS_TITLE_1))\n"))
                mutableAttrString.append(configureAttrString(by: UIFont.fontRobotoBold(size: 32.0),
                                                             color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), text: "\(LS(key: .RECIPE_DETAILS_TITLE_2))"))
                premiumTitleLabel.attributedText = mutableAttrString
            }
        //}
    }
    
    private func configureAttrString(by font: UIFont, color: UIColor, text: String) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PremiumQuizViewController {
            let vc = segue.destination as? PremiumQuizViewController
            vc?.isAutorization = false
            vc?.trialFrom = "recipe"
        }
    }
    
    //MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func premiumClicked(_ sender: Any) {
        performSegue(withIdentifier: "sequelPremiumScreen", sender: nil)
    }
}

extension RecipesDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DishDescriptionCell") as? DishDescriptionCell else { fatalError() }

        if let recipe = selectedRecipe {
            cell.fillCell(recipe: recipe, delegate: self, ownRecipe: ownRecipe, title: screenTitle)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecipesHeaderDetailsView.reuseIdentifier) as? RecipesHeaderDetailsView else {
            return UITableViewHeaderFooterView()
        }
        header.fillHeader(imageUrl: selectedRecipe?.imageUrl)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RecipesHeaderDetailsView.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y > 0 else {
            navigationView.backgroundColor = .clear
            statusBarView.backgroundColor = .clear
            backButton.tintColor = .white
            return scrollView.contentOffset = CGPoint(x: 0, y: 0) }

        let offset = scrollView.contentOffset.y / 150
        let isFilled = offset >= 0.8
        let backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
        navigationView.backgroundColor = backgroundColor.withAlphaComponent(offset)
        statusBarView.backgroundColor = backgroundColor.withAlphaComponent(offset)
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.backButton.tintColor = isFilled ? .black : .white
        }
    }
}

extension RecipesDetailsViewController: RecipesDetailsDelegate {
    
    func showPremiumScreen() {
        Amplitude.instance()?.logEvent("product_page_micro") // +
        performSegue(withIdentifier: "sequePremiumScreen", sender: nil)
    }
    
    func showAnimate() {
        loaderView.isHidden = false
        containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        containerView.alpha = 0.0
        
        if let tab = tabBarController, let first = tab.viewControllers?.first as? UINavigationController {
            if first.topViewController is DiaryViewController {
                let diary = first.topViewController as? DiaryViewController
                diary?.getItemsInDataBase()
            }
        }
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.containerView.alpha = 1.0
            self?.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        delay(bySeconds: 1.0) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
