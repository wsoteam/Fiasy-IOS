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
    @discardableResult func sendSendsay(_ mail: String) -> Observable<Suggest>  
    @discardableResult func searchSuggestProduct(search: String) -> Observable<Suggest>
    @discardableResult func searchProduct(search: String) -> Observable<PaginationProduct>
    @discardableResult func loadMoreProducts(link: String) -> Observable<PaginationProduct>
    
    @discardableResult func loadArticles() -> Observable<PaginationArticle>
    
//    func logout()
}
