import UIKit

final class CanvasContainerView: UIView {
    override var intrinsicContentSize: CGSize {
        return bounds.size
    }

    private let canvasView = CanvasView(frame: .zero)
    private var toolOptionsView = UIView(frame: .zero)

    var hasDrawing: Bool {
        return canvasView.hasDrawing
    }

    var tool: CanvasTool? {
        set {
            canvasView.tool = newValue
            setupOptionsView(for: newValue)
        }
        get {
            return canvasView.tool
        }
    }

    private(set) var optionsVisible: Bool = false

    var viewForSnapshotting: UIView {
        return canvasView
    }

    override var backgroundColor: UIColor? {
        get {
            return canvasView.backgroundColor
        }
        set {
            canvasView.backgroundColor = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        toolOptionsView.alpha = 0

        addSubview(canvasView)
        addSubview(toolOptionsView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        canvasView.frame = bounds
        toolOptionsView.frame.size.width = bounds.width
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupOptionsView(for tool: CanvasTool?) {
        toolOptionsView.alpha = 0.0
        toolOptionsView.subviews.forEach({ $0.removeFromSuperview() })

        guard let optionsView = tool?.toolOptionsView else {
            return
        }

        optionsView.translatesAutoresizingMaskIntoConstraints = false

        toolOptionsView.addSubview(optionsView)
        NSLayoutConstraint.activate(optionsView.pin(to: toolOptionsView))

        toolOptionsView.frame.size = optionsView.intrinsicContentSize
        toolOptionsView.frame.size.width = bounds.width
    }

    func setOptionsVisible(_ visible: Bool, animated: Bool = false) {
        guard optionsVisible != visible else {
            return
        }

        let duration = animated ? 0.1666 : 0.0
        let alpha: CGFloat = visible ? 1.0 : 0.0
        let minY: CGFloat = visible ? bounds.maxY - toolOptionsView.frame.height : bounds.maxY

        if visible {
            toolOptionsView.frame.origin.y = bounds.maxY
        }

        optionsVisible = visible

        UIView.animate(withDuration: duration, animations: {
            self.toolOptionsView.frame.origin.y = minY
            self.toolOptionsView.alpha = alpha
        })
    }

    @objc func undo() {
        canvasView.undo()
    }

    func clear() {
        canvasView.clear()
    }

    func nextBackground() {
        canvasView.nextBackground()
    }
}
