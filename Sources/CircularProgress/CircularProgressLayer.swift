import UIKit

fileprivate class CircularProgressLayerAnimation: CAAction {
    
    let priorValue: Double
    let animationDuration: TimeInterval?
    let animationStyle: CircularAnimation.Style?
    
    init(priorValue: Double, animationDuration: TimeInterval?, animationStyle: CircularAnimation.Style?) {
        self.priorValue = priorValue
        self.animationDuration = animationDuration
        self.animationStyle = animationStyle
    }
    
    func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable : Any]?) {
        guard let animationDuration = animationDuration,
              let animationStyle = animationStyle,
              let layer = anObject as? CircularProgressLayer,
              let newValue = layer.value(forKey: event) as? Double
        else { return }
        
        var animation: CABasicAnimation
        if animationStyle == .spring {
            
            let spring = CASpringAnimation(keyPath: event)
            spring.damping = 9
            spring.mass = 0.35
            spring.initialVelocity = 0
            spring.stiffness = 85
            
            animation = spring
        } else {
            animation = CABasicAnimation(keyPath: event)
        }
        
        animation.duration = animationDuration  // * fabs(newValue - priorValue)
        
        switch animationStyle {
            case .linear:
                animation.timingFunction = CAMediaTimingFunction(name: .linear)
            case .easeInEaseOut:
                animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            case .spring:
                break
        }
        
        animation.fromValue = priorValue
        animation.toValue = newValue
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        
        layer.add(animation, forKey: event)
    }
}

class CircularProgressLayer: CALayer {
    
    let lineWidth: CGFloat
    let outerRadius: CGFloat
    let fillColor: CGColor
    
    let animationDuration: TimeInterval?
    let animationStyle: CircularAnimation.Style?
    
    let isUpsideDown: Bool
    
    @NSManaged var progress: Double
    
    init(
        lineWidth: CGFloat,
        outerRadius: CGFloat, 
        fillColor: CGColor, 
        animationDuration: TimeInterval? = nil,
        animationStyle: CircularAnimation.Style? = nil,
        isUpsideDown: Bool = false
    ) {
        
        self.lineWidth = lineWidth
        self.outerRadius = outerRadius
        self.fillColor = fillColor
        
        self.animationDuration = animationDuration
        self.animationStyle = animationStyle
        
        self.isUpsideDown = isUpsideDown
        
        super.init()
        self.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: outerRadius * 2,
                height: outerRadius * 2
            )
        )
        self.needsDisplayOnBoundsChange = true
        self.drawsAsynchronously = true
    }
    
    override init(layer: Any) {
        
        if let other = layer as? CircularProgressLayer {
            self.lineWidth = other.lineWidth
            self.outerRadius = other.outerRadius
            self.fillColor = other.fillColor
            self.animationDuration = other.animationDuration
            self.animationStyle = other.animationStyle
            self.isUpsideDown = other.isUpsideDown
        } else {
            fatalError()
        }
        
        super.init(layer: layer)
        self.needsDisplayOnBoundsChange = true
        self.drawsAsynchronously = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func defaultValue(forKey key: String) -> Any? {
        if key == #keyPath(CircularProgressLayer.progress) {
            return 0.0
        }
        return super.defaultValue(forKey: key)
    }
    
    override func action(forKey event: String) -> CAAction? {
        
        if let animationDuration = animationDuration,
           event == #keyPath(CircularProgressLayer.progress),
           let fromProgress = value(forKey: event) as? Double
        {
            return CircularProgressLayerAnimation(
                priorValue: fromProgress,
                animationDuration: animationDuration,
                animationStyle: animationStyle
            )
        }
        
        return super.action(forKey: event)
    }
    
    override class func needsDisplay(forKey key: String) -> Bool {
        
        if key == #keyPath(CircularProgressLayer.progress) {
            return true
        }
        
        return super.needsDisplay(forKey: key)
    }
    
    override func draw(in ctx: CGContext) {
        
        let progress = max(0.0, min(presentation()?.progress ?? progress, 1.0))
        let outerRadius = (presentation()?.bounds.width ?? bounds.width) / 2
        
        let path = UIBezierPath(
            arcCenter: CGPoint(x: outerRadius, y: outerRadius),
            radius: outerRadius - lineWidth / 2, 
            startAngle: (isUpsideDown ? 1 : -1) * 0.5 * .pi,
            endAngle: (isUpsideDown ? 1 : -1) * 0.5 * .pi + 2 * .pi * progress,
            clockwise: true
        ).cgPath.copy(
            strokingWithWidth: lineWidth,
            lineCap: .round,
            lineJoin: .round,
            miterLimit: 0
        )
        
        ctx.setFillColor(fillColor)
        ctx.addPath(path)
        ctx.fillPath()
    }
}
