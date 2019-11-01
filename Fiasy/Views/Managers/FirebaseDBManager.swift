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
    
    static func fetchWaterItemsInDataBase(handler: @escaping ((String?) -> ())) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("USER_LIST").child(uid).child("waters").observeSingleEvent(of: .value, with: { (snapshot) in
                UserInfo.sharedInstance.allWaters.removeAll()
                if let snapshotValue = snapshot.value as? [String: [String:AnyObject]] {
                    for (key, items) in snapshotValue {
                        if let dictionary = items as? [String: AnyObject] {
                            let item = Water(generalKey: key, dictionary: dictionary)
                            UserInfo.sharedInstance.allWaters.append(item)
                        }
                    }
                }
                handler(nil)
            }) { (error) in
             handler(error.localizedDescription)
            }
        }
    }

    static func fetchMyMeasuringInDataBase(handler: @escaping (([Measuring]) -> ())) {
        if let uid = Auth.auth().currentUser?.uid {
            var lists: [Measuring] = []
            Database.database().reference().child("USER_LIST").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshotValue = snapshot.value as? [String : [String : AnyObject]] {
                    if let weights = snapshotValue["weights"] as? [String : [String : AnyObject]] {
                        for (key, items) in weights {
                            lists.append(Measuring(generalKey: key, dictionary: items, type: .weight))
                        }
                    }
                    if let waist = snapshotValue["waist"] as? [String : [String : AnyObject]] {
                        for (key, items) in waist {
                            lists.append(Measuring(generalKey: key, dictionary: items, type: .waist))
                        }
                    }
                    if let chest = snapshotValue["chest"] as? [String : [String : AnyObject]] {
                        for (key, items) in chest {
                            lists.append(Measuring(generalKey: key, dictionary: items, type: .chest))
                        }
                    }
                    if let hips = snapshotValue["hips"] as? [String : [String : AnyObject]] {
                        for (key, items) in hips {
                            lists.append(Measuring(generalKey: key, dictionary: items, type: .hips))
                        }
                    }
                    handler(lists)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    static func fetchMyActivityInDataBase(handler: @escaping (([ActivityElement]) -> ())) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("USER_LIST").child(uid).child("customActivities").observeSingleEvent(of: .value, with: { (snapshot) in
                var lists: [ActivityElement] = []
                if let snapshotValue = snapshot.value as? [String:[String:AnyObject]] {
                    for (key, items) in snapshotValue {
                        lists.append(ActivityElement(generalKey: key, dictionary: items))
                    }
                }
                return handler(lists)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    static func fetchDiaryActivityInDataBase(handler: @escaping (([ActivityElement]) -> ())) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("USER_LIST").child(uid).child("activities").observeSingleEvent(of: .value, with: { (snapshot) in
                var lists: [ActivityElement] = []
                if let snapshotValue = snapshot.value as? [String:[String:AnyObject]] {
                    for (key, items) in snapshotValue {
                        lists.append(ActivityElement(generalKey: key, dictionary: items))
                    }
                }
                return handler(lists)
            }) { (error) in
                print(error.localizedDescription)
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
    
    static func removeMeasuring(measuring: Measuring, type: MeasuringType, handler: @escaping (() -> ())) {
        guard let uid = Auth.auth().currentUser?.uid, let key = measuring.generalKey else { return }
        var item: String = ""
        switch type {
        case .weight:
            item = "weights"
        case .waist:
            item = "waist"
        case .chest:
            item = "chest"
        case .hips:
            item = "hips"
        }
        let ref = Database.database().reference()
        ref.child("USER_LIST").child(uid).child(item).child(key).removeValue()
        handler()
    }
    
    static func addMeasuring(date: Date, measuring: Measuring?, weight: Double, type: MeasuringType, handler: @escaping ((Measuring) -> ())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var item: String = ""
        switch type {
        case .weight:
            item = "weights"
        case .waist:
            item = "waist"
        case .chest:
            item = "chest"
        case .hips:
            item = "hips"
        }
        
        if let key = measuring?.generalKey {
            Database.database().reference().child("USER_LIST").child(uid).child("\(item)").child(key).child("weight").setValue(weight)
            handler(Measuring())
        } else {
            let milisecond = Int64((date.timeIntervalSince1970 * 1000.0).rounded())
            let userData = ["key": "", "timeInMillis": milisecond, "weight": weight] as [String : Any]
            Database.database().reference().child("USER_LIST").child(uid).child(item).child("\(milisecond)").setValue(userData)
            let model = Measuring()
            model.key = ""
            model.date = date
            model.type = type
            model.timeInMillis = Int(milisecond)
            model.weight = weight
            model.generalKey = "\(Int(milisecond))"
            handler(model)
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
        let flow = UserInfo.sharedInstance.registrationFlow
        let birthday: Date = flow.dateOfBirth ?? Date()
        if let uid = Auth.auth().currentUser?.uid {
            let age = Calendar.current.dateComponents([.year], from: birthday, to: Date())
            //let difficultyLevel = UserInfo.sharedInstance.registrationLoadСomplexity
            let exerciseStress = UserInfo.sharedInstance.registrationPhysicalActivity
            let female = (flow.gender ?? 1) == 0
            let height: Int = flow.growth
            let weight: Double = flow.weight
        
            //var boo: Double = 0.0
            var waterCount: Int = 0
//            if female {
//                boo = (9.99 * Double(weight) + 6.25 * Double(height) - 4.92 * Double(age) - 161) * 1.1
//                waterCount = 30 * weight
//            } else {
//                boo = (9.99 * Double(weight) + 6.25 * Double(height) - 4.92 * Double(age) + 5) * 1.1
//                waterCount = 40 * weight
//            }
//            let K = FirebaseDBManager.getLoadFactor(activity: UserInfo.sharedInstance.registrationPhysicalActivity)
//            let SPK = getTarget(spk: boo * K, complexity: UserInfo.sharedInstance.registrationLoadСomplexity)
            
//            let maxCarbo = Int(SPK * 0.5 / 3.75)
//            let maxFat = Int(SPK * 0.2 / 9)
//            let maxKcal = Int(SPK)
//            let maxProt = Int(SPK * 0.3 / 4)
            
            var BMR: Double = 0.0
            let secondAge = Double(age.year ?? 0)
            if flow.gender == 0 {
                BMR = (10 * flow.weight) + (6.25 * Double(flow.growth)) - (5 * secondAge) - 161
            } else {
                BMR = (10 * flow.weight) + (6.25 * Double(flow.growth)) - (5 * secondAge) + 5
            }
            let target: Int? = flow.target
            let targetActivity: CGFloat? = flow.loadActivity
            let activity = (BMR * RegistrationFlow.fetchActivityCoefficient(value: flow.loadActivity))
            let result = RegistrationFlow.fetchResultByAdjustmentCoefficient(target: flow.target, count: activity).displayOnly(count: 0)
            
            var fat: Int = 0
            var protein: Int = 0
            var carbohydrates: Int = 0
            
            if flow.gender == 0 {
                fat = (Int((result * 0.25).displayOnly(count: 0))/9) + 16
                protein = (Int((result * 0.4).displayOnly(count: 0))/4) - 16
                carbohydrates = (Int((result * 0.35).displayOnly(count: 0))/4) - 16
            } else {
                fat = (Int((result * 0.25).displayOnly(count: 0))/9) + 36
                protein = (Int((result * 0.4).displayOnly(count: 0))/4) - 36
                carbohydrates = (Int((result * 0.35).displayOnly(count: 0))/4) - 36
            }
            
            let numberOfDay = Calendar(identifier: .iso8601).ordinality(of: .day, in: .month, for: Date())!
            let month = Calendar(identifier: .iso8601).ordinality(of: .month, in: .year, for: Date())!
            let year = Calendar(identifier: .iso8601).ordinality(of: .year, in: .era, for: Date())!
            
            let userData = ["age": age.year ?? 20, "exerciseStress": exerciseStress, "female": female, "firstName": firstName, "lastName": lastName, "photoUrl": photoURL, "waterCount": waterCount, "weight": weight, "height" : height, "numberOfDay": numberOfDay, "month": month, "year": year, "maxFat": fat, "maxKcal": result, "maxProt": protein, "maxCarbo" : carbohydrates, "updateOfIndicator" : true, "email" : flow.email, "target" : target ?? 0, "target_Activity" : targetActivity ?? 0.0] as [String : Any]
            Database.database().reference().child("USER_LIST").child(uid).child("profile").setValue(userData)
            //Amplitude.instance().logEvent("create_acount")
        }
    }

    static func checkFilledProfile(handler: @escaping ((Bool) -> ())) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("USER_LIST").child(uid).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshotValue = snapshot.value as? [String:AnyObject] {
                    UserDefaults.standard.set(true, forKey: "firstLoadComplete")
                    UserDefaults.standard.synchronize()
                    UserInfo.sharedInstance.currentUser = User(dictionary: snapshotValue)
                    UserInfo.sharedInstance.userGender = UserInfo.sharedInstance.currentUser?.female == true ? .girl : .man
                    handler(false)
                } else {
                    handler(true)
//                    fillDefaultUserInDatabase()
//                    checkFilledProfile()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    static func checkProfileInDataBase(handler: @escaping ((Bool) -> ())) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("USER_LIST").child(uid).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
                if let _ = snapshot.value as? [String:AnyObject] {
                    handler(false)
                } else {
                    handler(true)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    static func fillDefaultUserInDatabase() {
        UserInfo.sharedInstance.registrationAge = "0"
        //UserInfo.sharedInstance.registrationLoadСomplexity = TargetType.easy.rawValue
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
    
    static func checkValidPromo(text: String, handler: @escaping ((Bool) -> ())) {
        let ref: DatabaseReference = Database.database().reference()
        let someText = text.replacingOccurrences(of: ".", with: "*").replacingOccurrences(of: "#", with: "*").replacingOccurrences(of: "$", with: "*").replacingOccurrences(of: "[", with: "*").replacingOccurrences(of: "[", with: "*").replacingOccurrences(of: "]", with: "*")
        ref.child("PROMO_STORAGE").child("\(someText)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshotValue = snapshot.value as? [String:AnyObject] {
                let item = Promo(key: "", dictionary: snapshotValue)
                if item.activated == false {
                    if let uid = Auth.auth().currentUser?.uid {
                        let userData = ["duration": item.duration, "id": item.id, "startActivated": Date().millisecondsSince1970, "type": item.type, "valid" : true] as [String : Any]
                    ref.child("PROMO_STORAGE").child("\(someText)").child("activated").setValue(true)
                    ref.child("PROMO_STORAGE").child("\(someText)").child("userOwner").setValue(uid)
                    ref.child("USER_LIST").child(uid).child("userPromo").childByAutoId().setValue(userData)
                        handler(true)
                    }
                } else {
                    handler(false)
                }
            } else {
                handler(false)
            }
        }) { (error) in
            handler(false)
        }
    }
    
    static func fetchUserPromo(handler: @escaping ((Bool) -> ())) {
        let ref: DatabaseReference = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            ref.child("USER_LIST").child(uid).child("userPromo").observeSingleEvent(of: .value, with: { (snapshot) in
                if let snapshotValue = snapshot.value as? [String: [String:AnyObject]] {
                    var promoArray: [Promo] = []
                    for (key, items) in snapshotValue {
                        let item = Promo(key: key, dictionary: items)
                        promoArray.append(item)
                    }
                    if promoArray.isEmpty {
                        handler(false)
                    } else {
                        var activePromo: Promo?
                        for item in promoArray where item.valid == true {
                            activePromo = item
                            break
                        }
                        if let active = activePromo, let generalKey = active.generalKey, !generalKey.isEmpty {
                            if (Date().millisecondsSince1970 <= (active.duration ?? 0) + (active.startActivated ?? 0)) {
                                handler(true)
                            } else {
                                ref.child("USER_LIST").child(uid).child("userPromo").child(generalKey).child("valid").setValue(false)
                                handler(false)
                            }
                        } else {
                            handler(false)
                        }
                    }
                } else {
                    handler(false)
                }
            }) { (error) in
                handler(false)
            }
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

extension Date {
    
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
