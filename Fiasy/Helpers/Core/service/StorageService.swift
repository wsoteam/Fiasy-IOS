//
//  StorageService.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 10/7/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Foundation

public enum StorageService: String {
    case APP_LANGUAGE = "appLanguage"
    case APP_IDENTIFIER = "appIdentifier"
    case CODE           = "countryCode"
    case VERSION_NOTIFY = "versionNotify"
    case APPLE_LANGUAGES = "AppleLanguages"
    case RECENT_CONTACTS = "recentContacts"
    
    public static func get(by key: StorageService) -> AnyObject? {
        let value = UserDefaults.standard.object(forKey: key.rawValue) as AnyObject
        return value
    }
    
    public static func remove(by key: StorageService) {
        UserDefaults.standard.set(nil, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
}

extension String {
    public func save(by key: StorageService) {
        UserDefaults.standard.set(self, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
}

extension Array {
    public func save(by key: StorageService) {
        UserDefaults.standard.set(self, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
}
