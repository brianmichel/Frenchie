import UIKit

final class StandardDrawingFrameView: UIView {

    override var intrinsicContentSize: CGSize {
        return stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()

    private let topLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        return label
    }()

    private let bottomLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()

    private let artworkImageView = UIImageView()

    init(topText: String?, bottomText: String?, artworkView: UIView) {
        super.init(frame: .zero)
        backgroundColor = .white

        topLabel.text = topText
        bottomLabel.text = bottomText

        bottomLabel.textAlignment = .center

        artworkImageView.image = artworkView.image()

        let topStackView = UIStackView()
        topStackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        topStackView.isLayoutMarginsRelativeArrangement = true
        topStackView.addArrangedSubview(topLabel)
        topStackView.distribution = .fillEqually

        let dividerView = UIView.makeDivider(bounds.width)

        stackView.addArrangedSubview(topStackView)
        stackView.addArrangedSubview(dividerView)
        stackView.addArrangedSubview(artworkImageView)
        stackView.addArrangedSubview(bottomLabel)

        NSLayoutConstraint.activate([
            topStackView.heightAnchor.constraint(equalToConstant: 44),
            bottomLabel.heightAnchor.constraint(equalToConstant: 44)
            ])

        addSubview(stackView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        stackView.frame = bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
