import Foundation

public struct CircularShape: Codable {
    
    public enum Direction: Codable {
        case downward
        case upward
    }
    
    public let lineWidth: Double
    public let outerRadius: Double
    public let direction: Direction
    
    public init(lineWidth: Double, outerRadius: Double, direction: CircularShape.Direction) {
        self.lineWidth = lineWidth
        self.outerRadius = outerRadius
        self.direction = direction
    }
}
