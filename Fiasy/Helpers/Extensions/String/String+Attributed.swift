//
//  String+Attributed.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/27/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Foundation

extension String {
    
    var capitalizeFirst: String {
        if count == 0 { return self }
        return String(self[startIndex]).capitalized + String(dropFirst())
    }
    
    func add(prefix: String) -> String {
        return hasPrefix(prefix) ? self : prefix + self
    }
    
    func hasSpecialCharacters() -> Bool {
        
        let specialCharacters = "!~`@#$%^&*+();:={}[],.<>?\\/\"\'"
        let characterSet = CharacterSet(charactersIn: specialCharacters)
        if (self.rangeOfCharacter(from: characterSet) != nil) {
            return true
        } else {
            return false
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
