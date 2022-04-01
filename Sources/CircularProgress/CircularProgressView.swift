import UIKit
import Combine

public class CircularProgressView: UIView {
    
    public let progressItem: CircularProgressItem
    public var configuration: CircularProgressConfiguration { progressItem.configuration }
    
    private var progressObserver: AnyCancellable?
    private var backgroundLayer: CircularProgressLayer?
    private var progressLayer: CircularProgressLayer?
    
    public override var frame: CGRect {
        didSet {
            backgroundLayer?.frame = bounds
            progressLayer?.frame = bounds
        }
    }
    
    public init(configuration: CircularProgressConfiguration) {
        
        self.progressItem = CircularProgressItem(configuration: configuration)
        super.init(
            frame: CGRect(
                    origin: .zero, 
                    size: CGSize(
                        width: configuration.outerRadius * 2,
                        height: configuration.outerRadius * 2
                    )
            )
        )
        
        setupObservers()
        setupLayers()
    }
    
    public convenience init(
        lineWidth: Double = CircularProgressConfiguration.defaultConfiguration.lineWidth,
        outerRadius: Double = CircularProgressConfiguration.defaultConfiguration.outerRadius,
        direction: CircularShape.Direction = CircularProgressConfiguration.defaultConfiguration.direction,
        fillColor: CircularColor = CircularProgressConfiguration.defaultConfiguration.fillColor,
        backgroundColor: CircularColor = CircularProgressConfiguration.defaultConfiguration.backgroundColor,
        animationDuration: TimeInterval? = CircularProgressConfiguration.defaultConfiguration.animationDuration,
        animationStyle: CircularAnimation.Style? = CircularProgressConfiguration.defaultConfiguration.animationStyle
    ) {
        
        var configuration = CircularProgressConfiguration.defaultConfiguration
        
        configuration.shape = CircularShape(
            lineWidth: lineWidth,
            outerRadius: outerRadius,
            direction: direction
        )
        
        configuration.fillColor = fillColor
        configuration.backgroundColor = backgroundColor
        
        if let animationDuration = animationDuration,
           let animationStyle = animationStyle
        {
            configuration.animation = CircularAnimation(
                duration: animationDuration,
                style: animationStyle
            )
        }
        
        self.init(configuration: configuration)
    }
    
    public override init(frame: CGRect) {
        
        self.progressItem = CircularProgressItem(
            configuration: CircularProgressConfiguration.defaultConfiguration
        )
        
        super.init(frame: frame)
        
        setupObservers()
        setupLayers()
    }
    
    private func setupObservers() {
        progressObserver = progressItem.$progress.sink { [weak self] in
            self?.progressLayer?.progress = max(0.0, min($0, 1.0))
        }
    }
    
    private func setupLayers() {
        
        let configuration = progressItem.configuration
        
        let backgroundLayer = CircularProgressLayer(
            lineWidth: configuration.lineWidth,
            outerRadius: configuration.outerRadius,
            fillColor: configuration.backgroundColor.cgColor
        )
        
        backgroundLayer.frame = bounds
        backgroundLayer.contentsScale = UIScreen.main.scale
        backgroundLayer.progress = 1.0
        layer.addSublayer(backgroundLayer)
        
        self.backgroundLayer = backgroundLayer
        
        let progressLayer = CircularProgressLayer(
            lineWidth: configuration.lineWidth,
            outerRadius: configuration.outerRadius,
            fillColor: configuration.fillColor.cgColor,
            animationDuration: configuration.animationDuration,
            animationStyle: configuration.animationStyle,
            isUpsideDown: configuration.direction == .upward
        )
        
        progressLayer.frame = bounds
        progressLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(progressLayer)
        
        self.progressLayer = progressLayer
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
