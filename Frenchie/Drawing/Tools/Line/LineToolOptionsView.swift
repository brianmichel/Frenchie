import UIKit

protocol LineToolOptionsViewDelegate: class {
    func selected(color: UIColor, optionsView: LineToolOptionsView)
}

final class LineToolOptionsView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    private let flowLayout = UICollectionViewFlowLayout()
    private let collectionView: UICollectionView

    weak var delegate: LineToolOptionsViewDelegate?

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 100)
    }

    private let colors = UIColor.drawingColorPalette

    var selectedColor: UIColor? {
        guard let index = collectionView.indexPathsForSelectedItems?.first else {
            return nil
        }

        return colors[safe: index.item]
    }

    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        super.init(frame: frame)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.contentInset = .zero

        backgroundColor = .white

        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        collectionView.register(LineToolOptionsColorCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        addSubview(collectionView)

        layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.frame = bounds
    }

    func selectColor(color: UIColor, animated: Bool = false) {
        guard let index = colors.firstIndex(of: color) else {
            return
        }

        collectionView.selectItem(at: IndexPath(item: index, section: 0),
                                  animated: animated,
                                  scrollPosition: .centeredVertically)

        delegate?.selected(color: color, optionsView: self)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? LineToolOptionsColorCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.color = colors[indexPath.row]

        if let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) {
            cell.isSelected = isSelected
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (bounds.width - 10) / 7
        let itemHeight = (bounds.height - 10) / 2
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = colors[indexPath.row]

        delegate?.selected(color: color, optionsView: self)
    }
}
