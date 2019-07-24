//
//  FirebaseDBManager.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseDatabase
import Amplitude_iOS

class FirebaseDBManager {

    static func getMealtimeItemsInDataBase(handler: @escaping ((String?) -> ())) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("USER_LIST").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                UserInfo.sharedInstance.clearAllItems()
                if let snapshotValue = snapshot.value as? [String:[String:AnyObject]] {
                    let sorted = snapshotValue.sorted() { $0.key.lowercased() < $1.key.lowercased() }
                    for (key, items) in sorted {
                        for secondItem in items {
                            if let dictionary = secondItem.value as? [String:AnyObject] {
                                let item = Mealtime(parentKey: key, generalKey: secondItem.key,  dictionary: dictionary)
                                UserInfo.sharedInstance.putMealtimeData(item: item)
                            }
                        }
                    }
                }
                handler(nil)
            }) { (error) in
                handler(error.localizedDescription)
            }
        }
    }
    
    static func reloadItems()  {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("USER_LIST").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                UserInfo.sharedInstance.clearAllItems()
                if let snapshotValue = snapshot.value as? [String:[String:AnyObject]] {
                    let sorted = snapshotValue.sorted() { $0.key.lowercased() < $1.key.lowercased() }
                    for (key, items) in sorted {
                        for secondItem in items {
                            if let dictionary = secondItem.value as? [String:AnyObject] {
                                let item = Mealtime(parentKey: key, generalKey: secondItem.key, dictionary: dictionary)
                                UserInfo.sharedInstance.putMealtimeData(item: item)
                            }
                        }
                    }
                }
                UserInfo.sharedInstance.isReload = true
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    static func removeItem(mealtime: Mealtime, handler: @escaping (() -> ()))  {
        guard let uid = Auth.auth().currentUser?.uid, let parentKey = mealtime.parentKey, let generalKey =  mealtime.generalKey else { return }
        let ref = Database.database().reference()
        ref.child("USER_LIST").child(uid).child(parentKey).child(generalKey).removeValue()
        handler()
    }
    
    static func removeTemplate(key: String, handler: @escaping (() -> ())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("USER_LIST").child(uid).child("template").child(key).removeValue()
        handler()
    }
    
    static func removeFavorite(key: String, handler: @escaping (() -> ())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("USER_LIST").child(uid).child("customFoods").child(key).removeValue()
        handler()
    }
    
    static func removeOwnRecipe(key: String, handler: @escaping (() -> ())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference()
        ref.child("USER_LIST").child(uid).child("customRecipes").child(key).removeValue()
        handler()
    }
    
    //MARK: - Registration -
    static func saveUserInDataBase(_ photoURL: String = "", firstName: String, lastName: String) {
        if let uid = Auth.auth().currentUser?.uid {
            let age = Int(UserInfo.sharedInstance.registrationAge) ?? 0
            let difficultyLevel = UserInfo.sharedInstance.registrationLoadСomplexity
            let exerciseStress = UserInfo.sharedInstance.registrationPhysicalActivity
            let female = UserInfo.sharedInstance.registrationGender == .girl
            let height = Int(UserInfo.sharedInstance.registrationGrowth) ?? 0
            let weight = Int(UserInfo.sharedInstance.registrationWeight) ?? 0
            //let state = UserInfo.sharedInstance.updateOfIndicator
        
            var boo: Double = 0.0
            var waterCount: Int = 0
            if female {
                boo = (9.99 * Double(weight) + 6.25 * Double(height) - 4.92 * Double(age) - 161) * 1.1
                waterCount = 30 * weight
            } else {
                boo = (9.99 * Double(weight) + 6.25 * Double(height) - 4.92 * Double(age) + 5) * 1.1
                waterCount = 40 * weight
            }
            let K = FirebaseDBManager.getLoadFactor(activity: UserInfo.sharedInstance.registrationPhysicalActivity)
            let SPK = getTarget(spk: boo * K, complexity: UserInfo.sharedInstance.registrationLoadСomplexity)
            
            let maxCarbo = Int(SPK * 0.5 / 3.75)
            let maxFat = Int(SPK * 0.2 / 9)
            let maxKcal = Int(SPK)
            let maxProt = Int(SPK * 0.3 / 4)
            
            let numberOfDay = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: Date())!
            let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: Date())!
            let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: Date())!
            
            let userData = ["age": age, "difficultyLevel": difficultyLevel, "exerciseStress": exerciseStress, "female": female, "firstName": firstName, "lastName": lastName, "photoUrl": photoURL, "waterCount": waterCount, "weight": weight, "height" : height, "numberOfDay": numberOfDay, "month": month, "year": year, "maxFat": maxFat, "maxKcal": maxKcal, "maxProt": maxProt, "maxCarbo" : maxCarbo, "updateOfIndicator" : true] as [String : Any]
            Database.database().reference().child("USER_LIST").child(uid).child("profile").setValue(userData)
            Amplitude.instance().logEvent("create_acount")
        }
    }

    static func checkFilledProfile() {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("USER_LIST").child(uid).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshotValue = snapshot.value as? [String:AnyObject] {
                    UserDefaults.standard.set(true, forKey: "firstLoadComplete")
                    UserDefaults.standard.synchronize()
                    UserInfo.sharedInstance.currentUser = User(dictionary: snapshotValue)
                } else {
                    fillDefaultUserInDatabase()
                    checkFilledProfile()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    static func fillDefaultUserInDatabase() {
        UserInfo.sharedInstance.registrationAge = "0"
        UserInfo.sharedInstance.registrationLoadСomplexity = TargetType.easy.rawValue
        UserInfo.sharedInstance.registrationPhysicalActivity = "Минимальная нагрузка"
        UserInfo.sharedInstance.registrationGender = .man
        UserInfo.sharedInstance.registrationGrowth = "0"
        UserInfo.sharedInstance.registrationWeight = "0"
        //UserInfo.sharedInstance.updateOfIndicator = false
        saveUserInDataBase(firstName: "", lastName: "")
    }
    
    static func fetchEditMealtime() -> Mealtime? {
        return UserInfo.sharedInstance.editMealtime
    }
    
    static func getTarget(spk: Double, complexity: String) -> Double {
        switch complexity {
        case "Легкая":
            return spk
        case "Средняя":
            return spk - 300
        case "Высокая":
            return spk - 500
        default:
            return spk
        }
    }
    
    static func getLoadFactor(activity: String) -> Double {
        switch activity {
        case "Минимальная нагрузка":
            return 1.2
        case "Малоактивный":
            return 1.375
        case "Среднеактивный":
            return 1.4625
        case "Интенсивная нагрузка":
            return 1.550
        case "Ежедневные тренировки":
            return 1.6375
        case "Ежедневные интенсивные тренировки":
            return 1.725
        case "Сверхтяжелые нагрузки":
            return 1.9
        default:
            return 1.2
        }
    }
    
    static func saveTemplate(titleName: String, generalKey: String?) {
        if let uid = Auth.auth().currentUser?.uid {
            let ref: DatabaseReference = Database.database().reference()
            if let key = generalKey {
                let userData = ["name": titleName, "fields": UserInfo.sharedInstance.templateArray] as [String : Any]
                ref.child("USER_LIST").child(uid).child("template").child(key).setValue(userData)
            } else {
                let userData = ["name": titleName, "fields": UserInfo.sharedInstance.templateArray] as [String : Any]
                ref.child("USER_LIST").child(uid).child("template").childByAutoId().setValue(userData)
            }
            UserInfo.sharedInstance.templateArray.removeAll()
            UserInfo.sharedInstance.reloadTemplate = true
        }
    }
    
    static func fetchTemplateInDataBase(handler: @escaping (([Template]) -> ())) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("USER_LIST").child(uid).child("template").observeSingleEvent(of: .value, with: { (snapshot) in
                
                var allTemplate: [Template] = []
                if let snapshotValue = snapshot.value as? [String:[String:AnyObject]] {
                    for (key, items) in snapshotValue {
                        let item = Template(generalKey: key, dictionary: items)
                        allTemplate.append(item)
                    }
                }
                handler(allTemplate)
            }) { (error) in
                handler([])
            }
        }
    }
    
    static func fetchFavoriteInDataBase(handler: @escaping (([Favorite]) -> ())) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("USER_LIST").child(uid).child("customFoods").observeSingleEvent(of: .value, with: { (snapshot) in
                var allFavorites: [Favorite] = []
                if let snapshotValue = snapshot.value as? [String:[String:AnyObject]] {
                    for (key, items) in snapshotValue {
                        let item = Favorite(dictionary: items, generalKey: key)
                        allFavorites.append(item)
                    }
                }
                handler(allFavorites)
            }) { (error) in
                handler([])
            }
        }
    }
    
    static func fetchUndeletableCustomFoodsInDataBase(handler: @escaping (([Favorite]) -> ())) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("USER_LIST").child(uid).child("undeletableCustomFoods").observeSingleEvent(of: .value, with: { (snapshot) in
                var allFavorites: [Favorite] = []
                if let snapshotValue = snapshot.value as? [String:[String:AnyObject]] {
                    for (key, items) in snapshotValue {
                        let item = Favorite(dictionary: items, generalKey: key)
                        allFavorites.append(item)
                    }
                }
                handler(allFavorites)
            }) { (error) in
                handler([])
            }
        }
    }
    
    static func fetchRecipesInDataBase(handler: @escaping (([Listrecipe]) -> ())) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("USER_LIST").child(uid).child("customRecipes").observeSingleEvent(of: .value, with: { (snapshot) in
                var allRecipes: [Listrecipe] = []
                if let snapshotValue = snapshot.value as? [String:[String:AnyObject]] {
                    for (key, items) in snapshotValue {
                        let item = Listrecipe(generalKey: key, dictionary: items)
                        allRecipes.append(item)
                    }
                }
                handler(allRecipes)
            }) { (error) in
                handler([])
            }
        }
    }
}
