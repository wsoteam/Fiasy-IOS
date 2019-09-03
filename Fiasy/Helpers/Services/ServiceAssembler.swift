//
//  ServiceAssembler.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Foundation
import Swinject

class ServiceAssembler: Assembly, SwinjectInitAssembler {
    
    required init() {}
    
    func assemble(container: Container) {
//        let appAccessTokenPlugin = AppAccessTokenPlugin()
//        let profileService = ProfileService(appAccessTokenPlugin: appAccessTokenPlugin)
//        let socketService = SocketService(profileService: profileService)
//        let notificationService = NotificationService(profileService: profileService, appAccessTokenPlugin: appAccessTokenPlugin)
        
        container.register(ProfileServiceProtocol.self) { r in
            return ProfileService()
            }.inObjectScope(.container)
    }
}

