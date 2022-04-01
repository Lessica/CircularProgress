import Foundation
import Combine

public class CircularProgressItem: NSObject {
    
    public let configuration: CircularProgressConfiguration
    @Published public var progress: Double // [0.0, 1.0]
    
    required init(configuration: CircularProgressConfiguration) {
        self.configuration = configuration
        progress = 0
    }
}
