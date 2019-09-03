//
//  BaseProvider.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Moya

protocol BaseProvider: AccessTokenAuthorizable {}

extension BaseProvider {
    var baseURL: URL { return URL(string: "http://116.203.193.111:8000/api/v1/")! }
    var path: String {
        return ""
    }
    var method: Moya.Method {
        return .get
    }
    var task: Task {
        return .requestPlain
    }
    var sampleData: Data {
        return "Not used?".data(using: .utf8)!
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var authorizationType: AuthorizationType {
        return .basic
    }
}
