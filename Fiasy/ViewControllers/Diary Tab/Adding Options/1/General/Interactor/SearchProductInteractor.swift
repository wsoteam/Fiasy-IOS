//
//  SearchProductInteractor.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/2/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import RxSwift
import Swinject
import Amplitude_iOS

protocol SearchProductInteractorInput {
    func searchProduct(search: String)
    func loadSuggest(by text: String)
    func loadMoreProducts(pagination: PaginationProduct)
}

protocol SearchProductInteractorOutput: class {
    func didLoadSuggest(list: [ProductInfo])
    func didLoadBySearch(_ pagination: PaginationProduct)
    func didLoadMoreProducts(_ products: [SecondProduct])
}

class SearchProductInteractor: SearchProductInteractorInput {
    
    weak var output: SearchProductInteractorOutput?
    private let profileService: ProfileServiceProtocol
    private var dispose = DisposeBag()
    
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }

    func loadMoreProducts(pagination: PaginationProduct) {
        guard let link = pagination.next, !link.isEmpty else { return }
        profileService.loadMoreProducts(link: link).subscribe(onNext: { [weak self] (response) in
            guard let strongSelf = self else { return }
            strongSelf.output?.didLoadMoreProducts(response.secondResults)
        }).disposed(by: dispose)
    }
    
    func loadSuggest(by text: String) {
        profileService.searchSuggestProduct(search: text).subscribe(onNext: { [weak self] (response) in
            guard let strongSelf = self else { return }
            if let first = response.list.first {
                var results: [ProductInfo] = []
                for item in first.results {
                    var contains: Bool = false
                    for second in results where second.name == item.name {
                        contains = true
                        break
                    }
                    if !contains {
                        results.append(item)
                    }
                }
                strongSelf.output?.didLoadSuggest(list: results)
            }
        }).disposed(by: dispose)
    }

    func searchProduct(search: String) {
        profileService.searchProduct(search: search).subscribe(onNext: { [weak self] (response) in
            guard let strongSelf = self else { return }
            Amplitude.instance()?.logEvent("search_success", withEventProperties: ["search_item" : search]) // +
            strongSelf.output?.didLoadBySearch(response)
        }).disposed(by: dispose)
    }
}
