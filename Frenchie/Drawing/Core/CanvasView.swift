import UIKit

final class CanvasView: UIView, Canvas {

    private let backgroundsView = DrawingBackgroundsView(images: [
        UIImage(named: "coloring_bacon"),
        UIImage(named: "coloring_bananas"),
        UIImage(named: "coloring_boxes"),
        UIImage(named: "coloring_coffee"),
        UIImage(named: "coloring_good-food"),
        UIImage(named: "coloring_peace"),
        UIImage(named: "coloring_radish"),
        UIImage(named: "coloring_smiles"),
        UIImage(named: "coloring_taco"),
        UIImage(named: "coloring_tree"),
        UIImage()
        ])

    private let layerContainerView = UIView()

    var hasDrawing: Bool {
        return drawnLayers.count > 0
    }

    override var intrinsicContentSize: CGSize {
        return bounds.size
    }

    var size: CGSize {
        return bounds.size
    }

    private var drawnLayers = [CALayer]()

    var tool: CanvasTool? {
        willSet {
            guard let oldView = tool?.toolView else {
                return
            }

            oldView.removeFromSuperview()
        }
        didSet {
            if let view = tool?.toolView {
                view.alpha = 0.0
                addSubview(view)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(backgroundsView)
        addSubview(layerContainerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundsView.frame = bounds
        layerContainerView.frame = bounds
    }

    func undo() {
        if let lastLayer = drawnLayers.popLast() {
            lastLayer.removeFromSuperlayer()
        }
    }

    func nextBackground() {
        backgroundsView.nextBackground()
    }

    @objc func clear() {
        drawnLayers.forEach({ $0.removeFromSuperlayer() })
        drawnLayers.removeAll()
    }

    func add(_ layer: CALayer) {
        layer.frame = bounds
        drawnLayers.append(layer)
        layerContainerView.layer.addSublayer(layer)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let touch = touches.first else {
            return
        }

        tool?.toolView.center = touch.location(in: self)
        tool?.toolView.alpha = 1.0
        tool?.activated(at: touch.location(in: self), on: self)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        guard let touch = touches.first else {
            return
        }

        tool?.toolView.center = touch.location(in: self)
        tool?.dragged(to: touch.location(in: self), on: self)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        tool?.toolView.alpha = 0.0

        guard let touch = touches.first else {
            return
        }
        tool?.deactivated(at: touch.location(in: self), on: self)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        tool?.toolView.alpha = 0.0

        guard let touch = touches.first else {
            return
        }
        tool?.deactivated(at: touch.location(in: self), on: self)
    }
}
