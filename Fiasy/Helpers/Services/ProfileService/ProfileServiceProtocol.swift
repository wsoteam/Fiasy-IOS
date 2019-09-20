//
//  ProfileServiceProtocol.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 8/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Moya
import RxSwift

protocol ProfileServiceProtocol {
    
    @discardableResult func loadProducts() -> Observable<PaginationProduct>
    @discardableResult func searchProduct(search: String) -> Observable<PaginationProduct>
    @discardableResult func loadMoreProducts(link: String) -> Observable<PaginationProduct>
    
//    func logout()
}
