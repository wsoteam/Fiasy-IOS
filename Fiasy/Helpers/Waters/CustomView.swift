//
//  CustomView.swift
//
//  Code generated using QuartzCode 1.50.0 on 26/09/2016.
//  www.quartzcodeapp.com
//

import UIKit

class CustomView: UIView, CAAnimationDelegate {
    
    var updateLayerValueForCompletedAnimation : Bool = false
    var animationAdded : Bool = false
    var completionBlocks : Dictionary<CAAnimation, (Bool) -> Void> = [:]
    var layers : Dictionary<String, AnyObject> = [:]
    
    
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProperties()
        setupLayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupProperties()
        setupLayers()
    }
    
    var oldAnimProgress: CGFloat = 0{
        didSet{
            if(!self.animationAdded){
                removeAllAnimations()
                addOldAnimation()
                self.animationAdded = true
                layer.speed = 0
                layer.timeOffset = 0
            } else{
                let totalDuration : CGFloat = 2.41
                let offset = oldAnimProgress * totalDuration
                layer.timeOffset = CFTimeInterval(offset)
            }
        }
    }
    
    func setupProperties(){
        
    }
    
    func setupLayers(){
        let water = CALayer()
        water.anchorPoint     = CGPoint(x: 0.5, y: 1)
        water.frame           = CGRect(x: 0, y: self.frame.size.height, width: self.frame.width, height: 0)
        // цвет воды
        water.backgroundColor = #colorLiteral(red: 0.2511603832, green: 0.6474531293, blue: 0.8728806376, alpha: 1).withAlphaComponent(0.3).cgColor
        self.layer.addSublayer(water)
        layers["water"] = water
        let path = CAShapeLayer()
        path.frame     = CGRect(x: 0, y: 0, width: self.frame.width, height: 10)
        
        // цвет волн
        path.fillColor =  #colorLiteral(red: 0.2511603832, green: 0.6474531293, blue: 0.8728806376, alpha: 1).withAlphaComponent(0.3).cgColor
        //        path.lineWidth = 1
        //        path.strokeColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        path.path      = pathPath().cgPath
        water.addSublayer(path)
        layers["path"] = path
        let path2 = CAShapeLayer()
        path2.isHidden  = true
        path2.frame     = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.size.height)
        path2.fillColor = UIColor(red:0.243, green: 0.584, blue:0.725, alpha: 0.3).cgColor
        path2.lineWidth = 0
        path2.path      = path2Path().cgPath
        water.addSublayer(path2)
        layers["path2"] = path2
        let path3 = CAShapeLayer()
        path3.isHidden  = true
        path3.frame     = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
        path3.fillColor = UIColor(red:0.243, green: 0.584, blue:0.725, alpha:0.3).cgColor
        path3.lineWidth = 0
        path3.path      = path3Path().cgPath
        water.addSublayer(path3)
        layers["path3"] = path3
        
        let rectangle = CAShapeLayer()
        rectangle.frame       = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.size.height)
        rectangle.fillColor   = nil
        rectangle.strokeColor = UIColor(red:0.329, green: 0.329, blue:0.329, alpha:0.3).cgColor
        rectangle.lineWidth   = 0
        rectangle.path        = rectanglePath().cgPath
        self.layer.addSublayer(rectangle)
        layers["rectangle"] = rectangle
    }
    
    //MARK: - Animation Setup
    
    func addOldAnimation(completionBlock: ((_ finished: Bool) -> Void)? = nil){
        if completionBlock != nil{
            let completionAnim = CABasicAnimation(keyPath:"completionAnim")
            completionAnim.duration = 2.63
            completionAnim.delegate = self
            completionAnim.setValue("old", forKey:"animId")
            completionAnim.setValue(false, forKey:"needEndAnim")
            layer.add(completionAnim, forKey:"old")
            if let anim = layer.animation(forKey: "old"){
                completionBlocks[anim] = completionBlock
            }
        }
        
        self.layer.speed = 1
        self.animationAdded = false
        
        let fillMode : String = CAMediaTimingFillMode.forwards.rawValue
        
        ////Water animation
        let waterBoundsAnim       = CABasicAnimation(keyPath:"bounds")
        waterBoundsAnim.fromValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0));
        waterBoundsAnim.toValue   = NSValue(cgRect: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height));
        waterBoundsAnim.duration  = 2.06
        
        let waterOldAnim : CAAnimationGroup = QCMethod.group(animations: [waterBoundsAnim], fillMode:fillMode)
        layers["water"]?.add(waterOldAnim, forKey:"waterOldAnim")
        
        ////Path animation
        let pathPathAnim          = CAKeyframeAnimation(keyPath:"path")
        pathPathAnim.values       = [QCMethod.alignToBottomPath(path: pathPath(), layer:layers["path"] as! CALayer).cgPath, QCMethod.alignToBottomPath(path: path2Path(), layer:layers["path"] as! CALayer).cgPath, QCMethod.alignToBottomPath(path: path3Path(), layer:layers["path"] as! CALayer).cgPath]
        pathPathAnim.keyTimes     = [0, 0.486, 1]
        pathPathAnim.duration     = 0.8
        pathPathAnim.repeatCount  = 3
        pathPathAnim.autoreverses = true
        
        let pathTransformAnim          = CAKeyframeAnimation(keyPath:"transform")
        pathTransformAnim.values       = [NSValue(caTransform3D: CATransform3DIdentity),
                                          NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(2, 12, 0), CATransform3DMakeRotation(9 * CGFloat(M_PI/180), 0, -0, 1))),
                                          NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeTranslation(-3, 14, 0), CATransform3DMakeRotation(-7 * CGFloat(M_PI/180), -0, 0, 1)))]
        pathTransformAnim.keyTimes     = [0, 0.478, 1]
        pathTransformAnim.duration     = 0.9
        pathTransformAnim.beginTime    = 0.43
        pathTransformAnim.autoreverses = true
        
        let pathPositionAnim       = CABasicAnimation(keyPath:"position")
        pathPositionAnim.fromValue = NSValue(cgPoint: CGPoint(x: 0, y: 0.0));
        pathPositionAnim.toValue   = NSValue(cgPoint: CGPoint(x: 0, y: 0.0));
        pathPositionAnim.duration  = 1.19
        pathPositionAnim.beginTime = 1.22
        
        let pathOldAnim : CAAnimationGroup = QCMethod.group(animations: [pathPathAnim, pathTransformAnim, pathPositionAnim], fillMode:fillMode)
        layers["path"]?.add(pathOldAnim, forKey:"pathOldAnim")
    }
    
    //MARK: - Animation Cleanup
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        if let completionBlock = completionBlocks[anim]{
            completionBlocks.removeValue(forKey: anim)
            if (flag && updateLayerValueForCompletedAnimation) || anim.value(forKey: "needEndAnim") as! Bool{
                updateLayerValues(forAnimationId: anim.value(forKey: "animId") as! String)
                removeAnimations(forAnimationId: anim.value(forKey: "animId") as! String)
            }
            completionBlock(flag)
        }
    }
    
    func updateLayerValues(forAnimationId identifier: String){
        if identifier == "old"{
            QCMethod.updateValueFromPresentationLayer(forAnimation: (layers["water"] as! CALayer).animation(forKey: "waterOldAnim"), theLayer:(layers["water"] as! CALayer))
            QCMethod.updateValueFromPresentationLayer(forAnimation: (layers["path"] as! CALayer).animation(forKey: "pathOldAnim"), theLayer:(layers["path"] as! CALayer))
        }
    }
    
    func removeAnimations(forAnimationId identifier: String){
        if identifier == "old"{
            (layers["water"] as! CALayer).removeAnimation(forKey: "waterOldAnim")
            (layers["path"] as! CALayer).removeAnimation(forKey: "pathOldAnim")
        }
        self.layer.speed = 1
    }
    
    func removeAllAnimations(){
        for layer in layers.values{
            (layer as! CALayer).removeAllAnimations()
        }
        self.layer.speed = 1
    }
    
    //MARK: - Bezier Path
    
    func pathPath() -> UIBezierPath {
        let pathPath = UIBezierPath()
        pathPath.move(to: CGPoint(x: 1.326, y: 37.628))
        pathPath.addCurve(to: CGPoint(x: 3.239, y: 5.332), controlPoint1:CGPoint(x: -0.931, y: 24.693), controlPoint2:CGPoint(x: -0.315, y: 6.703))
        pathPath.addCurve(to: CGPoint(x: 38.084, y: 5.332), controlPoint1:CGPoint(x: 6.793, y: 3.962), controlPoint2:CGPoint(x: 16.214, y: -5.948))
        pathPath.addCurve(to: CGPoint(x: 73.297, y: 3.961), controlPoint1:CGPoint(x: 62.279, y: 17.812), controlPoint2:CGPoint(x: 35.93, y: 13.03))
        pathPath.addCurve(to: CGPoint(x: 113.518, y: 5.036), controlPoint1:CGPoint(x: 110.664, y: -5.108), controlPoint2:CGPoint(x: 102.33, y: 17.089))
        pathPath.addCurve(to: CGPoint(x: 142.677, y: 17.72), controlPoint1:CGPoint(x: 119.149, y: -1.029), controlPoint2:CGPoint(x: 132.805, y: 0.211))
        pathPath.addCurve(to: CGPoint(x: 150.684, y: 38.209), controlPoint1:CGPoint(x: 150.43, y: 31.471), controlPoint2:CGPoint(x: 149.889, y: -3.265))
        
        return pathPath
    }
    
    func path2Path() -> UIBezierPath {
        let path2Path = UIBezierPath()
        path2Path.move(to: CGPoint(x: 1.326, y: 34.987))
        path2Path.addCurve(to: CGPoint(x: 3.239, y: 2.692), controlPoint1:CGPoint(x: -0.931, y: 22.052), controlPoint2:CGPoint(x: -0.315, y: 4.062))
        path2Path.addCurve(to: CGPoint(x: 38.084, y: 2.692), controlPoint1:CGPoint(x: 6.793, y: 1.321), controlPoint2:CGPoint(x: 16.586, y: 12.701))
        path2Path.addCurve(to: CGPoint(x: 78.11, y: 5.414), controlPoint1:CGPoint(x: 59.581, y: -7.318), controlPoint2:CGPoint(x: 40.743, y: 14.483))
        path2Path.addCurve(to: CGPoint(x: 113.823, y: 2.692), controlPoint1:CGPoint(x: 115.476, y: -3.655), controlPoint2:CGPoint(x: 88.008, y: 9.924))
        path2Path.addCurve(to: CGPoint(x: 139.719, y: 5.414), controlPoint1:CGPoint(x: 121.792, y: 0.459), controlPoint2:CGPoint(x: 120.544, y: 11.445))
        path2Path.addCurve(to: CGPoint(x: 150.684, y: 35.568), controlPoint1:CGPoint(x: 148.404, y: 2.682), controlPoint2:CGPoint(x: 149.889, y: -5.906))
        
        return path2Path
    }
    
    func path3Path() -> UIBezierPath {
        let path3Path = UIBezierPath()
        path3Path.move(to: CGPoint(x: 1.326, y: 41.03))
        path3Path.addCurve(to: CGPoint(x: 3.239, y: 8.734), controlPoint1:CGPoint(x: -0.931, y: 28.095), controlPoint2:CGPoint(x: -0.315, y: 10.105))
        path3Path.addCurve(to: CGPoint(x: 39.599, y: 16.264), controlPoint1:CGPoint(x: 6.793, y: 7.364), controlPoint2:CGPoint(x: 18.102, y: 26.274))
        path3Path.addCurve(to: CGPoint(x: 82.193, y: 16.264), controlPoint1:CGPoint(x: 61.097, y: 6.255), controlPoint2:CGPoint(x: 44.826, y: 25.333))
        path3Path.addCurve(to: CGPoint(x: 121.831, y: 3.152), controlPoint1:CGPoint(x: 119.56, y: 7.195), controlPoint2:CGPoint(x: 96.016, y: 10.385))
        path3Path.addCurve(to: CGPoint(x: 141.943, y: 0.808), controlPoint1:CGPoint(x: 129.8, y: 0.919), controlPoint2:CGPoint(x: 122.768, y: 6.84))
        path3Path.addCurve(to: CGPoint(x: 150.684, y: 41.611), controlPoint1:CGPoint(x: 150.628, y: -1.923), controlPoint2:CGPoint(x: 149.889, y: 0.137))
        
        return path3Path
    }
    
    func rectanglePath() -> UIBezierPath{
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.size.height))
        return rectanglePath
    }
}

