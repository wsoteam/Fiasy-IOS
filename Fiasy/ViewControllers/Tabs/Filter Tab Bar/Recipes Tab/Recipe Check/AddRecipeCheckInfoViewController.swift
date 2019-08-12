//
//  AddRecipeCheckInfoViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 7/17/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Amplitude_iOS
import Intercom

class AddRecipeCheckInfoViewController: UIViewController {
    
    // MARK: - Outlet -
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    private var flow = UserInfo.sharedInstance.recipeFlow
    
    // MARK: - Life Cicle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    // MARK: - Action -
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishClicked(_ sender: Any) {
        if let uid = Auth.auth().currentUser?.uid {
            loader.startAnimating()
            activityView.isHidden = false
            var calories: Int = 0
            for item in flow.allProduct {
                guard let second = item.calories, second != -1.0 else { break }
                calories = calories + Int(Double((second) * Double((item.productWeightByAdd ?? 0))).rounded(toPlaces: 1))
            }
            var carbohydrates: Double = 0.0
            for item in flow.allProduct {
                guard let second = item.carbohydrates, second != -1.0 else { break }
                carbohydrates = (carbohydrates + Double((second) * Double((item.productWeightByAdd ?? 0)))).rounded(toPlaces: 1)
            }
            var cellulose: Double = 0.0
            for item in flow.allProduct {
                guard let second = item.cellulose, second != -1.0 else { break }
                cellulose = (cellulose + Double((second) * Double((item.productWeightByAdd ?? 0)))).rounded(toPlaces: 1)
            }
            var cholesterol: Int = 0
            for item in flow.allProduct {
                guard let second = item.cholesterol, second != -1.0 else { break }
                cholesterol = cholesterol + Int(Double((second) * Double((item.productWeightByAdd ?? 0))).rounded(toPlaces: 1))
            }
            var fats: Double = 0.0
            for item in flow.allProduct {
                guard let second = item.fats, second != -1.0 else { break }
                fats = (fats + Double((second) * Double((item.productWeightByAdd ?? 0)))).rounded(toPlaces: 1)
            }
            var potassium: Int = 0
            for item in flow.allProduct {
                guard let second = item.pottassium, second != -1.0 else { break }
                potassium = potassium + Int(Double((second) * Double((item.productWeightByAdd ?? 0))).rounded(toPlaces: 1))
            }
            var proteins: Double = 0.0
            for item in flow.allProduct {
                guard let second = item.proteins, second != -1.0 else { break }
                proteins = proteins + (Double((second) * Double((item.productWeightByAdd ?? 0)))).rounded(toPlaces: 1)
            }

            var saturatedFats: Double = 0.0
            for item in flow.allProduct {
                guard let second = item.saturatedFats, second != -1.0 else { break }
                saturatedFats = saturatedFats + (Double((second) * Double((item.productWeightByAdd ?? 0)))).rounded(toPlaces: 1)
            }
            var sodium: Int = 0
            for item in flow.allProduct {
                guard let second = item.sodium, second != -1.0 else { break }
                sodium = sodium + Int(Double((second) * Double((item.productWeightByAdd ?? 0))).rounded(toPlaces: 1))
            }
            var sugar: Double = 0.0
            for item in flow.allProduct {
                guard let sugars = item.sugar, sugars != -1.0 else { break }
                sugar = sugar + (Double((sugars) * Double((item.productWeightByAdd ?? 0)))).rounded(toPlaces: 1)
            }
            var ingredients: [String] = []
            for item in flow.allProduct {
                ingredients.append("\(item.name ?? "") (\(item.productWeightByAdd ?? 0)г)")
            }
            var weight: Double = 0.0
            for item in flow.allProduct {
                weight = Double(weight + Double(item.productWeightByAdd ?? 0)).rounded(toPlaces: 1)
            }
            
            var recipeName: String = ""
            let fullNameArr = (self.flow.recipeName ?? "").split{$0 == " "}.map(String.init)
            for item in fullNameArr where !item.isEmpty {
                recipeName = recipeName.isEmpty ? item : recipeName + " \(item)"
            }
            
            var selectedProducts: [[String : Any]] = []
            for item in flow.allProduct {
                let post = ["name": item.name,
                           "brend": item.brend,
                        "calories": item.calories,
                "productWeightByAdd": item.productWeightByAdd] as [String : Any]
                
                selectedProducts.append(post)
            }
            
            
            for (index, item) in flow.instructionsList.enumerated() {
                var text: String = ""
                let fullNameArr2 = item.split{$0 == " "}.map(String.init)
                for item in fullNameArr2 where !item.isEmpty {
                    text = text.isEmpty ? item : text + " \(item)"
                }
                flow.instructionsList[index] = text
            }

            let ref = Database.database().reference()
            if let image = flow.recipeImage, let resizeImage = resizeImage(image: image, targetSize: CGSize(width: 450, height: 450)) {
                let uuid = UUID().uuidString
                let storageRef = Storage.storage().reference().child("AVATARS/").child("\(uuid).png")
                if let uploadData = resizeImage.pngData() {
                    storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                        if error != nil {
                            print("error")
                        } else {
                            if let uid = Auth.auth().currentUser?.uid, let url = metadata?.downloadURL()?.absoluteString {
                                let userData = ["selectedProducts" : selectedProducts, "weight" : weight, "calories": calories, "carbohydrates": carbohydrates, "cellulose" : cellulose, "cholesterol" : cholesterol, "fats": fats, "potassium" : potassium, "proteins" : proteins, "name" : recipeName, "complexity" : self.flow.complexity, "instruction": self.flow.instructionsList,  "saturatedFats": saturatedFats, "sodium": sodium, "sugar": sugar, "time" : Int(self.flow.time ?? "0") ?? 10, "ingredients" : ingredients, "url" : url] as [String : Any]
                                if self.flow.showAll {
                                    ref.child("USERS_RECIPES").childByAutoId().setValue(userData)
                                }
                                if let key = UserInfo.sharedInstance.recipeFlow.recipe?.key {
                                    ref.child("USER_LIST").child(uid).child("customRecipes").child(key).setValue(userData)
                                } else {
                                    ref.child("USER_LIST").child(uid).child("customRecipes").childByAutoId().setValue(userData)
                                }
                                UserInfo.sharedInstance.reloadRecipesScreen = true
                                Intercom.logEvent(withName: "custom_reciepe_success")
                                Amplitude.instance()?.logEvent("custom_reciepe_success")
                                self.popBack(5)
                            }
                        }
                    }
                }
            } else {
                let userData = ["selectedProducts" : selectedProducts, "weight" : weight, "calories": calories, "carbohydrates": carbohydrates, "cellulose" : cellulose, "cholesterol" : cholesterol, "fats": fats, "potassium" : potassium, "proteins" : proteins, "name" : recipeName, "complexity" : flow.complexity, "instruction": flow.instructionsList,  "saturatedFats": saturatedFats, "sodium": sodium, "sugar": sugar, "time" : Int(flow.time ?? "0") ?? 10, "ingredients" : ingredients, "url" : "https://firebasestorage.googleapis.com/v0/b/diet-for-test.appspot.com/o/default_recipe.png?alt=media&token=1fcf855f-fa9d-4831-9ff2-af204a612707"] as [String : Any]
                if flow.showAll {
                    ref.child("USERS_RECIPES").childByAutoId().setValue(userData)
                }
                
                if let key = UserInfo.sharedInstance.recipeFlow.recipe?.key {
                    ref.child("USER_LIST").child(uid).child("customRecipes").child(key).setValue(userData)
                } else {
                    ref.child("USER_LIST").child(uid).child("customRecipes").childByAutoId().setValue(userData)
                }
                UserInfo.sharedInstance.reloadRecipesScreen = true
                Intercom.logEvent(withName: "custom_reciepe_success")
                Amplitude.instance()?.logEvent("custom_reciepe_success")
                popBack(5)
            }
        }
    }
    
    // MARK: - Private -
    private func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
        tableView.register(type: SecondRecipeCheckTableVIewCell.self)
        tableView.register(type: RecipeCheckTableViewCell.self)
        tableView.register(AddProductFourthStepHeaderView.nib, forHeaderFooterViewReuseIdentifier: AddProductFourthStepHeaderView.reuseIdentifier)
    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension AddRecipeCheckInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return flow.allProduct.count
        case 2:
            return flow.instructionsList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCheckTableViewCell") as? RecipeCheckTableViewCell else { fatalError() }
            cell.fillCell(flow: flow, index: indexPath.row)
            return cell
        case 1,2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SecondRecipeCheckTableVIewCell") as? SecondRecipeCheckTableVIewCell else { fatalError() }
            cell.fillCell(flow: flow, indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AddProductFourthStepHeaderView.reuseIdentifier) as? AddProductFourthStepHeaderView else {
            return nil
        }
        header.fillRecipeHeader(section: section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AddProductFourthStepHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 2 ? 50.0 : 0.0000001
    }
}
