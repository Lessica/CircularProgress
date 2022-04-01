import Foundation

public struct CircularAnimation: Codable {
    
    public enum Style: Codable {
        case linear
        case easeInEaseOut
        case spring
    }
    
    public let duration: Double
    public let style: Style
    
    public static let defaultAnimation = CircularAnimation(duration: 0.6, style: .spring)
}
