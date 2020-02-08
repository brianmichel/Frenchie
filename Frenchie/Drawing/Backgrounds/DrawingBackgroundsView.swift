import UIKit

final class DrawingBackgroundViewCollectionCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    var image: UIImage? {
        set {
            imageView.image = newValue
        }
        get {
            return imageView.image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)

        NSLayoutConstraint.activate(imageView.pin(to: contentView))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class DrawingBackgroundsView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let images: [UIImage]
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        return layout
    }()
    
    private let collectionView: UICollectionView

    private var currentBackgroundIndex = 0

    init(images: [UIImage?]) {
        self.images = images.compactMap({ $0 })
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)

        collectionView.register(DrawingBackgroundViewCollectionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self

        addSubview(collectionView)
        NSLayoutConstraint.activate(collectionView.pin(to: self))

        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func nextBackground() {
        let nextIndex = (currentBackgroundIndex + 1) % images.count
        collectionView.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredHorizontally, animated: true)

        currentBackgroundIndex = nextIndex
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DrawingBackgroundViewCollectionCell else {
            return UICollectionViewCell()
        }

        cell.image = images[safe: indexPath.item]

        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bounds.size
    }
}
