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
            return "search/"
        case .searchSuggestProducts:
            return "search/suggest/"
        case .loadArticles:
            return "articles/"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .productsList, .loadMoreProducts, .searchProducts, .searchSuggestProducts, .loadArticles:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .searchProducts(let search):
            let parameters: [String: Any] = ["search": search]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .searchSuggestProducts(let search):
            let parameters: [String: Any] = ["name_suggest__completion": search]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
//        case .changeAvatar, .removeNotification:
//            return ["Content-type": "multipart/form-data"]
        default:
            return ["Content-type": "application/json"]
        }
    }
}
