//
//  UserInfo.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase

enum Gender: Int {
    case man = 0
    case girl = 1
    
    var avatarImage: UIImage {
        switch self {
        case .man:
            return #imageLiteral(resourceName: "default_man_Icon")
        case .girl:
            return #imageLiteral(resourceName: "default_ girl_Icon")
        }
    }
}

enum TargetType: String {
    case easy = "Легкая"
    case average = "Средняя"
    case high = "Высокая"
    
    var targetColor: UIColor {
        switch self {
        case .easy:
            return #colorLiteral(red: 0.5672869682, green: 0.782702148, blue: 0.2939775586, alpha: 1)
        case .average:
            return #colorLiteral(red: 1, green: 0.7656647563, blue: 0, alpha: 1)
        case .high:
            return #colorLiteral(red: 0.9309825301, green: 0.3653407693, blue: 0.1645739377, alpha: 1)
        }
    }
}

class UserInfo {
    
    static var sharedInstance = UserInfo()
    
    //MARK: - Current User -
    var currentUser: User?
    
    var userTarget: TargetType = .easy
    var userGender: Gender = .man
    var physicalActivity: String = "Минимальная нагрузка"
    
    var selectedMealtimeIndex: Int = 0
    var selectedMealtimeHeaderTitle: String = ""
    var selectedMealtimeData: [Listrecipe] = []
    
    var selectedDate: Date?
    var isReload: Bool = false
    
    //MARK: - User fields -
    var paymentComplete: Bool = false
    var purchaseIsValid: Bool = false
    var name: String = ""
    var surname: String = ""
    var growth: Int?
    var weight: Int?
    var age: Int?
    var allProducts: [Product] = []
    var selectedProduct: Product?
    
    var allRecipes: [Listrecipe] = []
    var selectedRecipes: Listrecipe?
    
    //MARK: - RegistrationUserInfo -
    var registrationLoadСomplexity: String = TargetType.easy.rawValue
    var registrationPhysicalActivity: String = "Минимальная нагрузка"
    
    var registrationGrowth: String = ""
    var registrationWeight: String = ""
    var registrationAge: String = ""
    var registrationGender: Gender?
    
    //MARK: - Mealtime Data -
    var allMealtime: [Mealtime] = []
    var breakfasts: [Mealtime] = []
    var lunches: [Mealtime] = []
    var dinners: [Mealtime] = []
    var snacks: [Mealtime] = []
    
    var selectedMealtimeTitle: String = ""
    
    var updateOfIndicator: Bool = false
    
    let maxFat: Int = 50
    let maxCarbohydrates: Int = 300
    let maxProtein: Int = 165
    let maxCalories: Int = 2500
    
    var indexInStack: Int?
    var indexPath: IndexPath?
    
    func fillAllFields(fields: [UITextField], female: Bool) {
        let name = fields.indices.contains(0) ? (fields[0].text ?? "") : ""
        let surname = fields.indices.contains(1) ? (fields[1].text ?? "") : ""
        let growth = fields.indices.contains(2) ? Int(fields[2].text ?? "0") : 0
        let weight = fields.indices.contains(3) ? Int(fields[3].text ?? "0") : 0
        let age = fields.indices.contains(4) ? Int(fields[4].text ?? "0") : 0
        
        var boo: Double = 0.0
        if female {
            boo = (9.99 * Double(weight ?? 0) + 6.25 * Double(growth ?? 0) - 4.92 * Double(age ?? 0) - 161) * 1.1
        } else {
            boo = (9.99 * Double(weight ?? 0) + 6.25 * Double(growth ?? 0) - 4.92 * Double(age ?? 0) + 5) * 1.1
        }
        let K = FirebaseDBManager.getLoadFactor(activity: UserInfo.sharedInstance.physicalActivity)
        let SPK = FirebaseDBManager.getTarget(spk: boo * K, complexity: (UserInfo.sharedInstance.currentUser?.difficultyLevel ?? ""))
        
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            UserInfo.sharedInstance.isReload = true
            ref.child("USER_LIST").child(uid).child("profile").child("age").setValue(age)
            ref.child("USER_LIST").child(uid).child("profile").child("firstName").setValue(name)
            ref.child("USER_LIST").child(uid).child("profile").child("lastName").setValue(surname)
            ref.child("USER_LIST").child(uid).child("profile").child("height").setValue(growth)
            ref.child("USER_LIST").child(uid).child("profile").child("weight").setValue(weight)
            ref.child("USER_LIST").child(uid).child("profile").child("female").setValue(female)
            ref.child("USER_LIST").child(uid).child("profile").child("maxCarbo").setValue(Int(SPK * 0.5 / 3.75))
            ref.child("USER_LIST").child(uid).child("profile").child("maxFat").setValue(Int(SPK * 0.2 / 9))
            ref.child("USER_LIST").child(uid).child("profile").child("maxKcal").setValue(Int(SPK))
            ref.child("USER_LIST").child(uid).child("profile").child("maxProt").setValue(Int(SPK * 0.3 / 4))
            ref.child("USER_LIST").child(uid).child("profile").child("exerciseStress").setValue(UserInfo.sharedInstance.physicalActivity)
            
            UserInfo.sharedInstance.currentUser?.age = age
            UserInfo.sharedInstance.currentUser?.firstName = name
            UserInfo.sharedInstance.currentUser?.lastName = surname
            UserInfo.sharedInstance.currentUser?.female = female
            UserInfo.sharedInstance.currentUser?.maxCarbo = Int(SPK * 0.5 / 3.75)
            UserInfo.sharedInstance.currentUser?.maxFat = Int(SPK * 0.2 / 9)
            UserInfo.sharedInstance.currentUser?.maxKcal = Int(SPK)
            UserInfo.sharedInstance.currentUser?.maxProt = Int(SPK * 0.3 / 4)
            UserInfo.sharedInstance.currentUser?.exerciseStress = UserInfo.sharedInstance.physicalActivity
            if let weight = weight {
                UserInfo.sharedInstance.currentUser?.waterCount = female ? (30 * weight) : (40 * weight)
            }
        }
        FirebaseDBManager.checkFilledProfile()
    }
    
    func clearAllItems() {
        allMealtime.removeAll()
        breakfasts.removeAll()
        lunches.removeAll()
        dinners.removeAll()
        snacks.removeAll()
    }
    
    func putMealtimeData(item: Mealtime) {
        switch item.parentKey {
        case "breakfasts":
            allMealtime.append(item)
            breakfasts.append(item)
        case "lunches":
            allMealtime.append(item)
            lunches.append(item)
        case "dinners":
            allMealtime.append(item)
            dinners.append(item)
        case "snacks":
            allMealtime.append(item)
            snacks.append(item)
        default:
            break
        }
    }
    
    func getAllProducts() {
//        var allProducts: [ListOfFoodItem] = []
//        if let path = Bundle.main.path(forResource: "food_list", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                let products = try? JSONDecoder().decode(Product.self, from: data)
//            
//                if let list = products?.listOfGroupsOfFood, !list.isEmpty {
//                    for item in list {
//                        if let secondList = item.listOfFoodItems, !secondList.isEmpty {
//                            for secondItem in secondList {
//                                allProducts.append(secondItem)
//                            }
//                        }
//                    }
//                }
//            } catch let error {
//                print("parse error: \(error.localizedDescription)")
//            }
//        } else {
//            print("Invalid filename/path.")
//        }
//        self.allProducts = allProducts
    }
    
    func getAllRecipes() {
        var allRecipes: [Listrecipe] = []
        if let path = Bundle.main.path(forResource: "diet-for-test", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let recipe = try? JSONDecoder().decode(Recipe.self, from: data)

                if let list = recipe?.listrecipes, !list.isEmpty {
                    allRecipes = list
                }
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        self.allRecipes = allRecipes
    }
    
    func getTitleMealtimeForFirebase() -> String {
        switch selectedMealtimeTitle {
        case "Завтрак":
            return "breakfasts"
        case "Обед":
            return "lunches"
        case "Ужин":
            return "dinners"
        case "Перекус":
            return "snacks"
        default:
            return ""
        }
    }
    
    static func setMealtimeLimits() {
        //
    }
    
    func removeRegistrationFields() {
        UserInfo.sharedInstance = UserInfo()
    }
}
