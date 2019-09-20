//
//  ProfileService.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Moya
import RxSwift
import RealmSwift
import ObjectMapper
import Moya_ObjectMapper

class ProfileService : ProfileServiceProtocol {
    
    private var profileProvider: AppMoyaProvider<AuthProvider>!
    
    init() {
        self.profileProvider = AppMoyaProvider<AuthProvider>()
    }
    
    func loadProducts() -> Observable<PaginationProduct> {
        return profileProvider.rx.request(.productsList).mapObject(PaginationProduct.self).asObservable()
    }
    
    func loadMoreProducts(link: String) -> Observable<PaginationProduct> {
        return profileProvider.rx.request(.loadMoreProducts(link)).mapObject(PaginationProduct.self).asObservable()
    }
    
    func searchProduct(search: String) -> Observable<PaginationProduct> {
        return profileProvider.rx.request(.searchProducts(search: search)).mapObject(PaginationProduct.self).asObservable()
    }
}
