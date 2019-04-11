//
//  User.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/11/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class User: NSObject {

    
    let email: String?
    
    init(jsonObject: [String: Any])
    {
        self.email = ""
        
    }

}
