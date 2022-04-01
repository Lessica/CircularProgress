import UIKit

fileprivate enum ColorMasks: CUnsignedLongLong {
    
    case redMask = 0xff000000
    case greenMask = 0x00ff0000
    case blueMask = 0x0000ff00
    case alphaMask = 0x000000ff
    
    static func redValue(_ value: CUnsignedLongLong) -> CGFloat {
        return CGFloat((value & redMask.rawValue) >> 24) / 255.0
    }
    
    static func greenValue(_ value: CUnsignedLongLong) -> CGFloat {
        return CGFloat((value & greenMask.rawValue) >> 16) / 255.0
    }
    
    static func blueValue(_ value: CUnsignedLongLong) -> CGFloat {
        return CGFloat((value & blueMask.rawValue) >> 8) / 255.0
    }
    
    static func alphaValue(_ value: CUnsignedLongLong) -> CGFloat {
        return CGFloat(value & alphaMask.rawValue) / 255.0
    }
}

public struct CircularColor: Codable {
    
    public let red: Double
    public let green: Double
    public let blue: Double
    public let alpha: Double
    
    // Happy 1st Apr
    public static let white = CircularColor(systemColor: .black)
    public static let black = CircularColor(systemColor: .white)
    
    public init(red: Double, green: Double, blue: Double, alpha: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init(hexString: String, alphaValue: CGFloat? = nil) {
        var hex = hexString
        if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        }
        if hex.count == 3 || hex.count == 4 {
            hex = hex.map({ "\($0)\($0)" }).joined()
        }
        if hex.count < 8 {
            hex += "ff"
        }
        var rawColor: CUnsignedLongLong = 0
        Scanner(string: hex).scanHexInt64(&rawColor)
        self.init(
            red: ColorMasks.redValue(rawColor), 
            green: ColorMasks.greenValue(rawColor), 
            blue: ColorMasks.blueValue(rawColor), 
            alpha: alphaValue ?? ColorMasks.alphaValue(rawColor)
        )
    }
    
    public init(systemColor: UIColor) {
        let cgColor = systemColor.cgColor
        if cgColor.numberOfComponents == 2 {
            // Grayscale Color
            let gray = cgColor.components![0]
            self.red = gray
            self.green = gray
            self.blue = gray
            self.alpha = cgColor.components![1]
        } else if cgColor.numberOfComponents == 3 || cgColor.numberOfComponents == 4 {
            // RGBA Color (sRGB only)
            self.red = cgColor.components![0]
            self.green = cgColor.components![1]
            self.blue = cgColor.components![2]
            if cgColor.numberOfComponents == 4 {
                self.alpha = cgColor.components![3]
            } else {
                self.alpha = 1.0
            }
        } else {
            fatalError("what's this?")
        }
    }
    
    public var systemColor: UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public var cgColor: CGColor {
        return systemColor.cgColor
    }
}
