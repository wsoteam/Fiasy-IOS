//
//  AppMoyaProvider.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Moya

extension Notification.Name {
    static let AppRecieveNoAuthStatusCode = Notification.Name("AppRecieveNoAuthStatusCode")
}

class AppMoyaProvider<Target: TargetType>: MoyaProvider<Target> {
    
    override func request(_ target: Target, callbackQueue: DispatchQueue?, progress: ProgressBlock?, completion: @escaping Completion) -> Cancellable {
        return super.request(target, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case .success(let response):
//                if response.statusCode == 401 {
//                    NotificationCenter.default.post(name: NSNotification.Name.AppRecieveNoAuthStatusCode, object: nil)
//                }
                completion(result)
            case .failure(_):
                completion(result)
            }
        }
    }
}
