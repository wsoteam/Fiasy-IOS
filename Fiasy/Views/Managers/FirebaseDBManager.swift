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
    
    static func removeItem(indexStack: Int, indexCell: IndexPath, handler: @escaping (() -> ()))  {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        switch indexCell.row {
        case 0:
            if !UserInfo.sharedInstance.breakfasts.isEmpty && UserInfo.sharedInstance.breakfasts.indices.contains(indexStack) {
                if let generalKey = UserInfo.sharedInstance.breakfasts[indexStack].generalKey, let parentKey = UserInfo.sharedInstance.breakfasts[indexStack].parentKey {
                    Database.database().reference().child("USER_LIST").child(uid).child(parentKey).child(generalKey).removeValue()
                    handler()
                }
            }
        case 1:
            if !UserInfo.sharedInstance.lunches.isEmpty && UserInfo.sharedInstance.lunches.indices.contains(indexStack) {
                if let generalKey = UserInfo.sharedInstance.lunches[indexStack].generalKey, let parentKey = UserInfo.sharedInstance.lunches[indexStack].parentKey {
                    Database.database().reference().child("USER_LIST").child(uid).child(parentKey).child(generalKey).removeValue()
                    handler()
                }
            }
        case 2:
            if !UserInfo.sharedInstance.dinners.isEmpty && UserInfo.sharedInstance.dinners.indices.contains(indexStack) {
                if let generalKey = UserInfo.sharedInstance.dinners[indexStack].generalKey, let parentKey = UserInfo.sharedInstance.dinners[indexStack].parentKey {
                    Database.database().reference().child("USER_LIST").child(uid).child(parentKey).child(generalKey).removeValue()
                    handler()
                }
            }
        case 3:
            if !UserInfo.sharedInstance.snacks.isEmpty && UserInfo.sharedInstance.snacks.indices.contains(indexStack) {
                if let generalKey = UserInfo.sharedInstance.snacks[indexStack].generalKey, let parentKey = UserInfo.sharedInstance.snacks[indexStack].parentKey {
                    Database.database().reference().child("USER_LIST").child(uid).child(parentKey).child(generalKey).removeValue()
                    handler()
                }
            }
        default:
            break
        }
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
            let state = UserInfo.sharedInstance.updateOfIndicator
        
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
            
            let userData = ["age": age, "difficultyLevel": difficultyLevel, "exerciseStress": exerciseStress, "female": female, "firstName": firstName, "lastName": lastName, "photoUrl": photoURL, "waterCount": waterCount, "weight": weight, "height" : height, "numberOfDay": numberOfDay, "month": month, "year": year, "maxFat": maxFat, "maxKcal": maxKcal, "maxProt": maxProt, "maxCarbo" : maxCarbo, "updateOfIndicator" : state] as [String : Any]
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
        UserInfo.sharedInstance.updateOfIndicator = false
        saveUserInDataBase(firstName: "", lastName: "")
    }
    
    static func fetchEditMealtime() -> Mealtime? {
        if let index = UserInfo.sharedInstance.indexInStack, let indexCell = UserInfo.sharedInstance.indexPath {
            UserInfo.sharedInstance.indexPath = nil
            UserInfo.sharedInstance.indexInStack = nil
            
            switch indexCell.row {
            case 0:
                if !UserInfo.sharedInstance.breakfasts.isEmpty && UserInfo.sharedInstance.breakfasts.indices.contains(index) {
                    return UserInfo.sharedInstance.breakfasts[index]
                }
            case 1:
                if !UserInfo.sharedInstance.lunches.isEmpty && UserInfo.sharedInstance.lunches.indices.contains(index) {
                    return UserInfo.sharedInstance.lunches[index]
                }
            case 2:
                if !UserInfo.sharedInstance.dinners.isEmpty && UserInfo.sharedInstance.dinners.indices.contains(index) {
                    return UserInfo.sharedInstance.dinners[index]
                }
            case 3:
                if !UserInfo.sharedInstance.snacks.isEmpty && UserInfo.sharedInstance.snacks.indices.contains(index) {
                    return UserInfo.sharedInstance.snacks[index]
                }
            default:
                return nil
            }
        }
        return nil
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
}
