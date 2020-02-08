import UIKit

enum ColorWellArrowDirection: Int {
    case down = 0, up

    var opposite: ColorWellArrowDirection {
        switch self {
        case .down:
            return .up
        case .up:
            return .down
        }
    }
}

final class ColorWellArrowViewControl: UIControl {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 60, height: 44)
    }

    private let arrowImageView = UIImageView(image: UIImage(named: "icon_nav-carat")?.withRenderingMode(.alwaysTemplate))
    private let colorWellView = ColorWellView()

    private(set) var arrowDirection: ColorWellArrowDirection = .up

    var color: UIColor? {
        didSet {
            colorWellView.color = color
            arrowImageView.tintColor = color?.blackOrWhiteTintColorForLuminosity
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        arrowImageView.sizeToFit()
        arrowImageView.transform = transform(for: arrowDirection)

        addSubview(colorWellView)
        addSubview(arrowImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        colorWellView.frame = bounds
        arrowImageView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
    }

    func setArrowDirection(_ arrowDirection: ColorWellArrowDirection, animated: Bool = false) {
        guard arrowDirection != self.arrowDirection else {
            return
        }

        let duration = animated ? 0.2 : 0.0

        self.arrowDirection = arrowDirection

        UIView.animate(withDuration: duration, animations: {
            self.arrowImageView.transform = self.transform(for: arrowDirection)
        })
    }

    private func transform(for direction: ColorWellArrowDirection) -> CGAffineTransform {
        switch direction {
        case .up:
            return CGAffineTransform(rotationAngle: CGFloat(180.0 * .pi) / CGFloat(180.0))
        case .down:
            return CGAffineTransform.identity
        }
    }
}
