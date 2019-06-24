//
//  DispatchQueue.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/21/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}
