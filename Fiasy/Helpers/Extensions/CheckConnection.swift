//
//  CheckConnection.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/11/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Reachability

struct Network {
    
    static var reachability: Reachability!
    
    enum Status: String {
        case unreachable, wifi, wwan
    }
    enum Error: Swift.Error {
        case failedToSetCallout
        case failedToSetDispatchQueue
        case failedToCreateWith(String)
        case failedToInitializeWith(sockaddr_in)
    }
}
