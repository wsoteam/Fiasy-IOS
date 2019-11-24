//
//  EntryKit+EKAttributes.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 11/5/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit
import SwiftEntryKit

extension EKAttributes {
    
    mutating func fillAppConfigure(height: CGFloat) {
        
        position = .bottom
        displayDuration = .infinity
        entranceAnimation = .init(translate: .init(duration: 0.4))
        exitAnimation = .init(translate: .init(duration: 0.4))
        positionConstraints.verticalOffset = height
        precedence.priority = .low
        entryInteraction = .absorbTouches
        scroll = .disabled

        shadow = .active(
            with: .init(
                color: #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 0.3952760858),
                opacity: 8,
                radius: 8
            )
        )
        
        roundCorners = .all(radius: 10)
        positionConstraints.size = .init(
            width: .offset(value: 20),
            height: .intrinsic
        )
    }
}
