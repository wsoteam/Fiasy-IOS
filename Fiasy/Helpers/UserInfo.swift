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
    internal var complition: (() -> Void)?
    
    // MARK: - Current User -
    var productModel: MLModel?
    var currentUser: User?
    
    var userTarget: TargetType = .easy
    var userGender: Gender = .man
    var physicalActivity: String = "Минимальная нагрузка"
    
    var selectedMealtimeIndex: Int = 0
    var selectedMealtimeHeaderTitle: String = ""
    var selectedMealtimeData: [Listrecipe] = []
    
    var selectedDate: Date?
    var isReload: Bool = false
    
    var reloadDiariContent: Bool = false
    
    // MARK: - User fields -
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
    
    var registrationLoadСomplexity: String = TargetType.easy.rawValue
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
    
    // MARK: - Product Flow -
    var productFlow = AddProductFlow()
    var reloadFavoriteScreen: Bool = false
    
    // MARK: - Recipe Flow -
    var recipeFlow = AddRecipeFlow()
    var reloadRecipesScreen: Bool = false
    
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
    
    func getTitleMealtime(text: String) -> String {
        switch text {
        case "breakfasts":
            return "Завтрак"
        case "lunches":
            return "Обед"
        case "dinners":
            return "Ужин"
        case "snacks":
            return "Перекус"
        default:
            return "Завтрак"
        }
    }
    
    func getAmplitudeTitle(text: String) -> String {
        switch text {
        case "Завтрак":
            return "breakfasts"
        case "Обед":
            return "lunches"
        case "Ужин":
            return "dinners"
        case "Перекус":
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
