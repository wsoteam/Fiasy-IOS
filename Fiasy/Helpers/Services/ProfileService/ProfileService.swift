//
//  ProfileService.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Moya
import RxSwift
import UIKit

class ProfileService : ProfileServiceProtocol {
    
    private var profileProvider: AppMoyaProvider<AuthProvider>!
    
    init() {
        self.profileProvider = AppMoyaProvider<AuthProvider>()
    }
    
//    func loadMapList() -> Observable<[TicketReponse]> {
//        return companyProvider.rx.request(.requestList).mapArray(TicketReponse.self).asObservable()
//    }
//
//    func finishTicket(id: Int) -> Observable<Verify> {
//        return companyProvider.rx.request(.finishTicket(id)).mapObject(Verify.self).asObservable()
//    }
//
//    func cancelTicket(id: Int, message: String) -> Observable<Verify> {
//        return companyProvider.rx.request(.cancelTicket(id, message)).mapObject(Verify.self).asObservable()
//    }
//
//    func applyTicket(id: Int) -> Observable<Verify> {
//        return companyProvider.rx.request(.applyTicket(id)).mapObject(Verify.self).asObservable()
//    }
}
