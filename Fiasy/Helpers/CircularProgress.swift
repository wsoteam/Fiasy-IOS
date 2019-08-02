//
//  CircularProgress.swift
//  Fiasy
//
//  Created by Eugen Lipatov on 6/25/19.
//  Copyright © 2019 Eugen Lipatov. All rights reserved.
//

import UIKit

class CircularProgress: UIView {
    
    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var tracklayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    var progressColor:UIColor = UIColor.red {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor:UIColor = UIColor.white {
        didSet {
            tracklayer.strokeColor = trackColor.cgColor
        }
    }
    
    fileprivate func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2.0
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * Double.pi), endAngle: CGFloat(1.5 * Double.pi), clockwise: true)
        
        tracklayer.path = circlePath.cgPath
        tracklayer.fillColor = UIColor.clear.cgColor
        tracklayer.strokeColor = trackColor.cgColor
        tracklayer.lineWidth = 5.0;
        tracklayer.strokeEnd = 1.0
        tracklayer.cornerRadius = 2.5
        layer.addSublayer(tracklayer)
        
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 5.0;
        progressLayer.strokeEnd = 0.0
        progressLayer.cornerRadius = 2.5
        layer.addSublayer(progressLayer)
        
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float, handler: @escaping (() -> ())) {
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLayer.strokeEnd = CGFloat(value)
        
        CATransaction.setCompletionBlock { [weak self] in
            handler()
        }
        progressLayer.add(animation, forKey: "animateCircle")
        CATransaction.commit()
    }
    
}
