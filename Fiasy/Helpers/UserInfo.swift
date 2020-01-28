//
//  UserInfo.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import CoreML

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

class UserInfo {

    static var sharedInstance = UserInfo()
    internal var complition: (() -> Void)?
    
    var articleExpert: [Article] = []
    
    var templateName: String = ""
    var templateEditKey: String?
    var templateProductList: [SecondProduct] = []
    
    // MARK: - Measuring -
    var measuringList: [Measuring] = []
    
    // MARK: - Current User -
    var productModel: MLModel?
    var currentUser: User?
    
    var activityStates: [Bool] = [true, true, true]
    
//    var userTarget: TargetType = .easy
    var userGender: Gender = .man
    var physicalActivity: String = "Минимальная нагрузка"
    
    var selectedMealtimeIndex: Int = 0
    var selectedMealtimeHeaderTitle: String = ""
    var selectedMealtimeData: [Listrecipe] = []
    
    var selectedDate: Date?
    var isReload: Bool = false
    
    var reloadDiariContent: Bool = false
    
    var reloadActiveContent: Bool = false
    
    var trialFrom: String = ""
    
    // MARK: - User fields -
    var editTarget: Int = 0
    var editActivity: CGFloat = 0.0
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
    
    var dayCount: [Date] = []
    
    // MARK: - Registration Flow -
    var registrationFlow = RegistrationFlow()
    
    //var registrationLoadСomplexity: String = TargetType.easy.rawValue
    var registrationPhysicalActivity: String = "Минимальная нагрузка"
    
    var registrationGrowth: String = ""
    var registrationWeight: String = ""
    var registrationAge: String = ""
    var registrationGender: Gender?
    
    // MARK: - Mealtime Data -
    var allMealtime: [Mealtime] = []
    var breakfasts: [Mealtime] = []
    var lunches: [Mealtime] = []
    var dinners: [Mealtime] = []
    var snacks: [Mealtime] = []
    
    var selectedMealtimeTitle: String = ""
    
    let maxFat: Int = 50
    let maxCarbohydrates: Int = 300
    let maxProtein: Int = 165
    let maxCalories: Int = 2500
    
    var indexInStack: Int?
    var indexPath: IndexPath?
    var editMealtime: Mealtime?
    
    var searchProductText: String = ""
    
    var templateArray: [[String]] = []
    var reloadTemplate: Bool = false
    
    var allWaters: [Water] = []
    
    // MARK: - Product Flow -
    var productFlow = AddProductFlow()
    var reloadFavoriteScreen: Bool = false
    
    // MARK: - Recipe Flow -
    var recipeFlow = AddRecipeFlow()
    var reloadRecipesScreen: Bool = false
    
    // MARK: - Dish Flow -
    var dishFlow = DishFlow()
    var reloadDishScreen: Bool = false
    
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
        FirebaseDBManager.checkFilledProfile { (state) in }
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
    
    static func sortMealTime(mealtimes: [Mealtime]) -> [[Mealtime]] {
        var breakfasts: [Mealtime] = []
        var lunches: [Mealtime] = []
        var dinners: [Mealtime] = []
        var snacks: [Mealtime] = []
        
        for item in mealtimes {
            switch item.parentKey {
            case "breakfasts":
                breakfasts.append(item)
            case "lunches":
                lunches.append(item)
            case "dinners":
                dinners.append(item)
            case "snacks":
                snacks.append(item)
            default:
                break
            }
        }
        var sectionArray: [[Mealtime]] = []
        sectionArray.append(breakfasts)
        sectionArray.append(lunches)
        sectionArray.append(dinners)
        sectionArray.append(snacks)
        return sectionArray
    }
    
    func getAllRecipes() {
//        var allRecipes: [Listrecipe] = []
//        if let path = Bundle.main.path(forResource: "diet-for-test", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                let recipe = try? JSONDecoder().decode(Recipe.self, from: data)
//                
//                if let list = recipe?.listrecipes, !list.isEmpty {
//                    allRecipes = list
//                }
//            } catch let error {
//                print("parse error: \(error.localizedDescription)")
//            }
//        } else {
//            print("Invalid filename/path.")
//        }
//        self.allRecipes = allRecipes
    }
    
    func getAllActivitys() -> [ActivityElement] {
        var allActivitys: [ActivityElement] = []
        
        var fileName: String = "activity_list"
        switch Locale.current.languageCode {
        case "es":
            // испанский
            fileName = "activity_spain_list"
        case "pt":
//            // португалия (бразилия)
            fileName = "activity_port_list"
        case "en":
            // английский
            fileName = "activity_eng_list"
        case "de":
//            // немецикий
            fileName = "activity_deut_list"
        default:
            break
        }
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let activitys = try? JSONDecoder().decode(Activity.self, from: data)
                
                if let items = activitys {
                    allActivitys = items
                }
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        }
        return allActivitys
    }
    
    func getTitleMealtimeForFirebase() -> String {
        switch selectedMealtimeIndex {
        case 0:
            return "breakfasts"
        case 1:
            return "lunches"
        case 2:
            return "dinners"
        case 3:
            return "snacks"
        default:
            return ""
        }
    }
    
    func getSecondTitleMealtimeForFirebase() -> String {
        switch selectedMealtimeIndex {
        case 0:
            return "breakfast"
        case 1:
            return "lunch"
        case 2:
            return "dinner"
        case 3:
            return "snack"
        default:
            return ""
        }
    }
    
    func getTitleMealtime(text: String) -> String {
        switch text {
        case "breakfasts":
            return LS(key: .BREAKFAST)
        case "lunches":
            return LS(key: .LUNCH)
        case "dinners":
            return LS(key: .DINNER)
        case "snacks":
            return LS(key: .SNACK)
        default:
            return LS(key: .BREAKFAST)
        }
    }
    
    func getAmplitudeTitle(text: String) -> String {
        switch text {
        case LS(key: .BREAKFAST):
            return "breakfasts"
        case LS(key: .LUNCH):
            return "lunches"
        case LS(key: .DINNER):
            return "dinners"
        case LS(key: .SNACK):
            return "snacks"
        default:
            return "snacks"
        }
    }
    
    func removeRegistrationFields() {
        UserInfo.sharedInstance = UserInfo()
    }
    
    func getDateCount(completion: @escaping (Int) -> ()) {
        dayCount.removeAll()
        complition = { [weak self] in
            guard let strongSelf = self else { return }
            completion(strongSelf.dayCount.count)
        }
        searchDate(date: Date())
    }
    
    private func searchDate(date: Date) {
        let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: date)!
        let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: date)!
        let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: date)!
        
        var isContains: Bool = false
        for item in UserInfo.sharedInstance.allMealtime where item.presentDay == true && item.day == day && item.month == month && item.year == year {
            isContains = true
            dayCount.append(date)
            break
        }
        
        if !isContains {
            complition?()
        } else {
            if let last = dayCount.last {
                searchDate(date: last.yesterday())
            }
        }
    }
}
