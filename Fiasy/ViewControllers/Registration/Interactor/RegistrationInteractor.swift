//
//  RegistrationInteractor.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 12/4/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import UIKit
import RxSwift
import Swinject
import Amplitude_iOS

protocol RegistrationInteractorInput {
    func sendSendsay(email: String)
}

class RegistrationInteractor: RegistrationInteractorInput {
    
    //weak var output: SearchProductInteractorOutput?
    private let profileService: ProfileServiceProtocol
    private var dispose = DisposeBag()
    
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    func sendSendsay(email: String) {
        guard !email.isEmpty else { return }
        
        profileService.sendSendsay(email).subscribe(onNext: { [weak self] (response) in
            guard let strongSelf = self else { return }
            //print(response)
        }).disposed(by: dispose)
    }
}

