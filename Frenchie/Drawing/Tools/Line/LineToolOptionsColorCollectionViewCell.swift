import UIKit

final class LineToolOptionsColorCollectionViewCell: UICollectionViewCell {
    private let colorWellView = ColorWellView()
    private let selectionImageView = UIImageView(image: UIImage(named: "icon_drawing-checkmark"))

    var color: UIColor? {
        didSet {
            colorWellView.color = color
        }
    }

    override var isHighlighted: Bool {
        didSet {
            colorWellView.alpha = isHighlighted ? 0.5 : 1.0
        }
    }

    override var isSelected: Bool {
        didSet {
            colorWellView.alpha = 1.0
            selectionImageView.isHidden = !isSelected
            selectionImageView.tintColor = color?.blackOrWhiteTintColorForLuminosity
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(colorWellView)
        contentView.addSubview(selectionImageView)

        selectionImageView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        colorWellView.frame = contentView.bounds
        selectionImageView.center = contentView.center
    }
}
