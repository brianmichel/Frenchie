import UIKit

final class ColorWellView: UIView {
    private enum Constants {
        static let heightWidthRatio: CGFloat = 0.725
        static let colorWellHorizontalInset: CGFloat = 10
    }
    private let colorWell = UIView()

    var color: UIColor? {
        didSet {
            colorWell.backgroundColor = color

            guard let newColor = color else {
                return
            }

            if newColor.luminosity == 1.0 {
                colorWell.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
                colorWell.layer.borderWidth = 1.0
            } else {
                colorWell.layer.borderColor = nil
                colorWell.layer.borderWidth = 0.0
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        addSubview(colorWell)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let width = bounds.width - Constants.colorWellHorizontalInset
        let height = width * Constants.heightWidthRatio
        colorWell.frame.size = CGSize(width: width, height: height)
        colorWell.layer.cornerRadius = height / 2.0
        colorWell.center = center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
