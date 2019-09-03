//
//  AuthProvider.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Moya

enum AuthProvider: BaseProvider {
    //case userData
}

extension AuthProvider : TargetType {
    
//    var path: String {
//        switch self {
//        case .userData: fallthrough
//        case .changeAvatar:
//            return ""
//        case .loadAllAddress:
//            return "meter/item/"
//        case .loadKnowledgeBase:
//            return "faq/"
//        case .loadKnowledgeDetails(let id):
//            return "faq/\(id)/"
//        case .changePhone, .changePhoneResend, .changePhoneWithVerify:
//            return "phone_change/"
//        case .phoneVerify:
//            return "phone/verify/"
//        case .resetPassword:
//            return "password-remind/"
//        case .loadNotifications, .markReadNotifications:
//            return "push_items/"
//        case .removeNotification:
//            return "push_delete/"
//        case .loadMeterDetails(let id):
//            return "meter/item/\(id)/"
//        default:
//            return ""
//        }
//    }
    
//    var method: Moya.Method {
//        switch self {
//        case .userData, .loadNotifications, .loadKnowledgeBase, .loadKnowledgeDetails, .changePhoneResend, .loadAllAddress, .loadMeterDetails:
//            return .get
//        case .markReadNotifications:
//            return .put
//        case .resetPassword, .removeNotification, .phoneVerify, .changePhone, .changePhoneWithVerify, .changeName, .changeAvatar:
//            return .post
//        }
//    }
    
//    var task: Task {
//        switch self {
//        case .changeAvatar(let avatar):
//            var multipartFormDatas = [MultipartFormData]()
//            multipartFormDatas.append(MultipartFormData(provider: .data(avatar.pngData()!), name: "avatar", fileName: "image.jpeg", mimeType: "image/jpeg"))
//            return .uploadMultipart(multipartFormDatas)
//        case .changeName(let firstName, let lastName):
//            let parameters: [String: Any] = ["last_name": lastName, "first_name": firstName]
//            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
//        case .changePhoneWithVerify(_, let code):
//            let parameters: [String: Any] = ["verify_code": code]
//            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
//        default:
//            return .requestPlain
//        }
//    }
    
    var headers: [String: String]? {
        switch self {
//        case .changeAvatar, .removeNotification:
//            return ["Content-type": "multipart/form-data"]
        default:
            return ["Content-type": "application/json"]
        }
    }
}
