//
//  AuthProvider.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Moya

enum AuthProvider: BaseProvider {
    case productsList
    case loadArticles
    case sendSendsay(String)
    case searchSuggestProducts(search: String)
    case searchProducts(search: String)
    case loadMoreProducts(String)
}

extension AuthProvider : TargetType {

    var baseURL: URL {
        switch self {
        case .loadMoreProducts(let link):
            return URL(string: link)!
        default:
            return URL(string: "http://116.203.193.111:8000/api/v1/")!
        }
    }

    var path: String {
        switch self {
        case .productsList, .searchProducts:
            switch Locale.current.languageCode {
            case "es":
                // испанский
                return "es/search/"
            case "pt":
                // португалия (бразилия)
                return "pt/search/"
            case "en":
                // английский
                return "en/search/"
            case "de":
                // немецикий
                return "de/search/"
            default:
                // русский
                return "search/"
            }
        case .searchSuggestProducts:
            switch Locale.current.languageCode {
            case "es":
                // испанский
                return "es/search/suggest/"
            case "pt":
                // португалия (бразилия)
                return "pt/search/suggest/"
            case "en":
                // английский
                return "en/search/suggest/"
            case "de":
                // немецикий
                return "de/search/suggest/"
            default:
                // русский
                return "search/suggest/"
            }
        case .loadArticles:
            return "articles/"
        case .sendSendsay:
            return "sendsay/set"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .productsList, .loadMoreProducts, .searchProducts, .searchSuggestProducts, .loadArticles:
            return .get
        case .sendSendsay:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .sendSendsay(let mail):
            let parameters: [String: Any] = ["email": mail, "os" : "IOS"]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .searchProducts(let search):
            if getPreferredLocale.languageCode == "ru" {
                let parameters: [String: Any] = ["search": search]
                return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            } else {
                let parameters: [String: Any] = ["search": search, "brand" : "null"]
                return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            }
        case .searchSuggestProducts(let search):
            let parameters: [String: Any] = ["name_suggest__completion": search]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var getPreferredLocale: Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-type": "application/json", "cache-control": "no-cache"]
        }
    }
}
