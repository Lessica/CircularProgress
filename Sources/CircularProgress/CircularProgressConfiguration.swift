import Foundation

public struct CircularProgressConfiguration {
    
    public var shape: CircularShape
    public var lineWidth: Double { shape.lineWidth }
    public var outerRadius: Double { shape.outerRadius }
    public var direction: CircularShape.Direction { shape.direction }
    
    public var fillColor: CircularColor
    public var backgroundColor: CircularColor
    
    public var animation: CircularAnimation?
    public var animationDuration: TimeInterval? { animation?.duration }
    public var animationStyle: CircularAnimation.Style? { animation?.style }
    
    public static let defaultConfiguration = CircularProgressConfiguration(
        shape: CircularShape(
            lineWidth: 8.0,
            outerRadius: 133.0,
            direction: .downward
        ),
        fillColor: CircularColor.white,
        backgroundColor: CircularColor.black,
        animation: CircularAnimation.defaultAnimation
    )
}
