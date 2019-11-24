//
//  ArticleTabInteractor.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/24/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import RxSwift
import Swinject
import Amplitude_iOS

protocol ArticleTabInteractorInput {
    func loadArticleList()
}

protocol ArticleTabInteractorOutput: class {
    func didLoadArticles(list: [Article])
}

class ArticleTabInteractor: ArticleTabInteractorInput {

    weak var output: ArticleTabInteractorOutput?
    private let profileService: ProfileServiceProtocol
    private var dispose = DisposeBag()
    
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    func loadArticleList() {
        profileService.loadArticles().subscribe(onNext: { [weak self] (response) in
            guard let strongSelf = self else { return }
            strongSelf.output?.didLoadArticles(list: response.results)
        }).disposed(by: dispose)   
    }
}
