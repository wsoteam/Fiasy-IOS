//
//  ProductDetailsViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MBCircularProgressBar
import Amplitude_iOS

class ProductDetailsViewController: UIViewController {
    
    //MARK: - Outlets -
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak var bottomSeparatorView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var calorieProductLabel: UILabel!
    @IBOutlet weak var carbohydratesProductLabel: UILabel!
    @IBOutlet weak var fatProductLabel: UILabel!
    @IBOutlet weak var squirrelsProductLabel: UILabel!
    @IBOutlet weak var addProductWeightTextField: UITextField!
    @IBOutlet weak var squirrelsProgress: MBCircularProgressBarView!
    @IBOutlet weak var fatProgress: MBCircularProgressBarView!
    @IBOutlet weak var carbohydratesProgress: MBCircularProgressBarView!
    @IBOutlet weak var carbohydrateAmountLabel: UILabel!
    @IBOutlet weak var fatAmountLabel: UILabel!
    @IBOutlet weak var proteinsAmountLabel: UILabel!
    
    //MARK: - Properties -
    private let ref: DatabaseReference = Database.database().reference()
    private var selectedProduct = UserInfo.sharedInstance.selectedProduct
    private var editProduct: Mealtime?
    private var isEditState: Bool = false
    override internal var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let editMealTime = FirebaseDBManager.fetchEditMealtime() {
            self.editProduct = editMealTime
            self.isEditState = true
            for item in UserInfo.sharedInstance.allProducts where item.name == editMealTime.name {
                selectedProduct = item
            }
            setupEditState()
        }
        setupInitialState()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeObserver()
    }
    
    //MARK: - Private -
    private func setupInitialState() {
        guard let selectedProduct = selectedProduct else { return }
        productNameLabel.text = "\(selectedProduct.name ?? "") (\(selectedProduct.brend ?? ""))"
        
        carbohydrateAmountLabel.text = "\(String(Double((selectedProduct.carbohydrates ?? 0.0) * 100).rounded(toPlaces: 2))) г"
        fatAmountLabel.text = "\(String(Double((selectedProduct.fats ?? 0.0) * 100).rounded(toPlaces: 2))) г"
        proteinsAmountLabel.text = "\(String(Double((selectedProduct.proteins ?? 0.0) * 100).rounded(toPlaces: 2))) г"

        if let count = selectedProduct.percentProteins {
            squirrelsProgress.value = CGFloat(count)
        }

        if let count = selectedProduct.percentFats {
            fatProgress.value = CGFloat(count)
        }

        if let count = selectedProduct.percentCarbohydrates {
            carbohydratesProgress.value = CGFloat(count)
        }
    }
    
    private func setupEditState() {
        guard let editProduct = editProduct else { return }
        fillAllCountFields(count: editProduct.weight ?? 1)
        addProductWeightTextField.text = "\(editProduct.weight ?? 1)"
        saveButton.setImage(isEditState ? #imageLiteral(resourceName: "button (3)") : #imageLiteral(resourceName: "button (1)"), for: .normal)
    }
    
    private func fillCount(field: UITextField) {
        guard let text = field.text, let count = Int(text), !text.isEmpty else {
            return fillAllCountFields(count: 0)
        }
        fillAllCountFields(count: count)
    }
    
    private func fillAllCountFields(count: Int) {
        guard let selected = selectedProduct, let calories = selected.calories else {
            return
        }
        calorieProductLabel.text = "\(Int(Float(count) * Float(calories))) Ккал"
        carbohydratesProductLabel.text = "\(Int(Float(count) * Float(selected.carbohydrates ?? 0.0))) г"
        fatProductLabel.text = "\(Int(Float(count) * Float(selected.fats ?? 0.0))) г"
        squirrelsProductLabel.text = "\(Int(Float(count) * Float(selected.proteins ?? 0.0))) г"
    }
    
    private func showAnimate() {
        loaderView.isHidden = false
        containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        containerView.alpha = 0.0
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.containerView.alpha = 1.0
            self?.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        Amplitude.instance().logEvent("success_add_food")
        delay(bySeconds: 1.0) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Actions -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveProductClicked(_ sender: Any) {
        if isEditState {
            let ref = Database.database().reference()
            if let uid = Auth.auth().currentUser?.uid, let generalKey = editProduct?.generalKey, let parentKey = editProduct?.parentKey {
                if let weight = addProductWeightTextField.text, let protein = squirrelsProductLabel.text, let fat = fatProductLabel.text, let carbohydrates = carbohydratesProductLabel.text, let calories = calorieProductLabel.text {
                    ref.child("USER_LIST").child(uid).child(parentKey).child(generalKey).child("weight").setValue(Int(weight))
                    ref.child("USER_LIST").child(uid).child(parentKey).child(generalKey).child("protein").setValue(Int(protein.replacingOccurrences(of: " г", with: "")))
                    ref.child("USER_LIST").child(uid).child(parentKey).child(generalKey).child("fat").setValue(Int(fat.replacingOccurrences(of: " г", with: "")))
                    ref.child("USER_LIST").child(uid).child(parentKey).child(generalKey).child("carbohydrates").setValue(Int(carbohydrates.replacingOccurrences(of: " г", with: "")))
                    ref.child("USER_LIST").child(uid).child(parentKey).child(generalKey).child("calories").setValue(calories.replacingOccurrences(of: " Ккал", with: ""))
                    FirebaseDBManager.reloadItems()
                    UserInfo.sharedInstance.isReload = true
                    navigationController?.popViewController(animated: true)
                }
            }
        } else {
            Amplitude.instance().logEvent("attempt_add_food")
            if let uid = Auth.auth().currentUser?.uid, let date = UserInfo.sharedInstance.selectedDate, let weight = addProductWeightTextField.text, let protein = squirrelsProductLabel.text, let fat = fatProductLabel.text, let carbohydrates = carbohydratesProductLabel.text, let calories = calorieProductLabel.text {
                let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: date)!
                let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: date)!
                let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: date)!
                
                let userData = ["day": day, "month": month, "year": year, "name": selectedProduct?.name ?? "", "weight": Int(weight), "protein": Int(protein.replacingOccurrences(of: " г", with: "")), "fat": Int(fat.replacingOccurrences(of: " г", with: "")), "carbohydrates": Int(carbohydrates.replacingOccurrences(of: " г", with: "")), "calories": calories.replacingOccurrences(of: " Ккал", with: "")] as [String : Any]
                ref.child("USER_LIST").child(uid).child(UserInfo.sharedInstance.getTitleMealtimeForFirebase()).childByAutoId().setValue(userData)
                FirebaseDBManager.reloadItems()
                showAnimate()
            }
        }
    }
    
    @IBAction func editingTextField(_ sender: UITextField) {
        fillCount(field: sender)
    }
}

extension ProductDetailsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y > 0 else {
            return scrollView.contentOffset = CGPoint(x: 0, y: 0) }
    }
}

extension ProductDetailsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 10
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomSeparatorView.backgroundColor = #colorLiteral(red: 0.9386252165, green: 0.490940094, blue: 0, alpha: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bottomSeparatorView.backgroundColor = #colorLiteral(red: 0.8783355355, green: 0.8784865737, blue: 0.8783260584, alpha: 1)
    }
}
