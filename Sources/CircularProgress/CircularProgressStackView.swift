import UIKit

public class CircularProgressStackView: UIView {
    
    public var spacing: CGFloat?  // set to nil to allow custom layouts
    
    public var managedSubviews: [CircularProgressView] {
        return subviews.compactMap { $0 as? CircularProgressView }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if let spacing = spacing {
            
            var offsetX: CGFloat = 0
            for subview in subviews {
                
                guard let subview = subview as? CircularProgressView else { continue }
                
                let width = bounds.width - offsetX * 2
                guard width >= 0 else {
                    fatalError("stack overflow?")
                }
                
                subview.frame = CGRect(
                    x: offsetX,
                    y: offsetX,
                    width: width,
                    height: width
                )
                
                offsetX += subview.configuration.lineWidth + spacing
            }
        } else {
            subviews.forEach {
                $0.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            }
        }
    }
}
