//
//  UIView+Nib.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 4/8/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import Foundation
import UIKit

public func instancetype<T>(object: Any?) -> T? {
    return object as? T
}

extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func setupFromNib() {
        let view = loadFromNib()
        addSubview(view)
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func loadFromNib() -> UIView {
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError()
        }
        return view
    }
    
    static func place(view: UIView, on container: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(view)
        
        view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        
        view.layoutSubviews()
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: self.className, bundle: nil)
    }
    
    class func fromXib(_ name: String? = nil) -> Self? {
        return instancetype(object: Bundle.main.loadNibNamed(name ?? self.className, owner: nil, options: nil)?.last)
    }
}

extension UIView {
    
    func fadeIn(secondView: UIView) {
        self.alpha = 0
        secondView.alpha = 0
        self.isHidden = false
        secondView.isHidden = false
        UIView.animate(withDuration: 0.0,
                       animations: {
                        self.alpha = 1
                        secondView.alpha = 1
        },
                       completion: { (value: Bool) in
                        //
        }
        )
    }
    
    func fadeOut(secondView: UIView) {
        UIView.animate(withDuration: 0.0,
                       animations: {
                        self.alpha = 0
                        secondView.alpha = 0
        },
                       completion: { (value: Bool) in
                        self.isHidden = true
                        secondView.isHidden = true
                        //
        }
        )
    }
    
    func hideAnimated(in stackView: UIStackView) {
        if !self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = true
                    stackView.layoutIfNeeded()
            },
                completion: nil
            )
        }
    }
    
    func showAnimated(in stackView: UIStackView) {
        if self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.isHidden = false
                    stackView.layoutIfNeeded()
            },
                completion: nil
            )
        }
    }
}

extension UIView {
    
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
    }
}

extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
    
}
