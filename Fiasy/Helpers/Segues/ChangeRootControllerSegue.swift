//
//  ChangeRootControllerSegue.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/26/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class ChangeRootControllerSegue: UIStoryboardSegue {
    
    override func perform() {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        
        let destinationViewController = self.destination
        
        UIView.transition(with: keyWindow, duration: 0.3, options: UIView.AnimationOptions.transitionFlipFromLeft, animations: {
            keyWindow.rootViewController = destinationViewController
        }, completion: nil)
    }
}
