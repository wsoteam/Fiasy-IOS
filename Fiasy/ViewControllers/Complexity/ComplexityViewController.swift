//
//  ComplexityViewController.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import Firebase

class ComplexityViewController: UIViewController {
    
    //MARK: - Actions -
    @IBAction func targetClicked(_ sender: UIButton) {
        var target: TargetType = .easy
        switch sender.tag {
        case 0:
            target = .high
        case 1:
            target = .average
        case 2:
            target = .easy
        default:
            break
        }
        
        var boo: Double = 0.0
        let weight = UserInfo.sharedInstance.currentUser?.weight ?? 0
        let age = UserInfo.sharedInstance.currentUser?.age ?? 0
        let height = UserInfo.sharedInstance.currentUser?.height ?? 0
        if UserInfo.sharedInstance.currentUser?.female == true {
            boo = (9.99 * Double(weight) + 6.25 * Double(height) - 4.92 * Double(age) - 161) * 1.1
        } else {
            boo = (9.99 * Double(weight) + 6.25 * Double(height) - 4.92 * Double(age) + 5) * 1.1
        }
        let K = FirebaseDBManager.getLoadFactor(activity: UserInfo.sharedInstance.currentUser?.exerciseStress ?? "")
        let SPK = FirebaseDBManager.getTarget(spk: boo * K, complexity: target.rawValue)
        
        let ref = Database.database().reference()
        if let uid = Auth.auth().currentUser?.uid {
            UserInfo.sharedInstance.isReload = true
            ref.child("USER_LIST").child(uid).child("profile").child("difficultyLevel").setValue(target.rawValue)
            ref.child("USER_LIST").child(uid).child("profile").child("maxCarbo").setValue(Int(SPK * 0.5 / 3.75))
            ref.child("USER_LIST").child(uid).child("profile").child("maxFat").setValue(Int(SPK * 0.2 / 9))
            ref.child("USER_LIST").child(uid).child("profile").child("maxKcal").setValue(Int(SPK))
            ref.child("USER_LIST").child(uid).child("profile").child("maxProt").setValue(Int(SPK * 0.3 / 4))
            
            UserInfo.sharedInstance.currentUser?.maxCarbo = Int(SPK * 0.5 / 3.75)
            UserInfo.sharedInstance.currentUser?.maxFat = Int(SPK * 0.2 / 9)
            UserInfo.sharedInstance.currentUser?.maxKcal = Int(SPK)
            UserInfo.sharedInstance.currentUser?.maxProt = Int(SPK * 0.3 / 4)
        }
        
        UserInfo.sharedInstance.userTarget = target
        UserInfo.sharedInstance.registrationLoadСomplexity = target.rawValue
        UserInfo.sharedInstance.currentUser?.difficultyLevel = target.rawValue
        dismiss(animated: false) { [unowned self] in
            self.post("reloadContent")
        }
    }
}
