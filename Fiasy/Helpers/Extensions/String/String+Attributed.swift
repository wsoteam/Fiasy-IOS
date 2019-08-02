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
    
    func displayOnly(count: Int) -> Double {
        let string = String(format: "%.\(count)f", self)
        return Double(string) ?? 0.0
    }
}

extension StringProtocol {
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}
