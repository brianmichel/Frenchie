import UIKit

protocol LineToolDelegate: class {
    func didSetColor(color: UIColor, for lineTool: LineTool)
}

final class LineTool: CanvasTool, LineToolOptionsViewDelegate {
    private var line: Line?
    private var shapeLayer = CAShapeLayer()

    private let lineOptionsView = LineToolOptionsView()

    weak var delegate: LineToolDelegate?

    var color: UIColor = .darkGray {
        didSet {
            delegate?.didSetColor(color: color, for: self)
        }
    }

    var layer: CALayer {
        return shapeLayer
    }

    let toolView: UIView

    var size: CGSize {
        return CGSize(width: 50, height: 50)
    }

    let toolOptionsView: UIView?

    init() {
        toolOptionsView = lineOptionsView

        toolView = UIView()
        toolView.frame.size = size
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = 5.0

        lineOptionsView.delegate = self
    }

    func activated(at: CGPoint, on: Canvas) {
        line = Line(point: Point(location: at, velocity: .zero))
        shapeLayer = makeNewShapeLayer()
        on.add(shapeLayer)
        shapeLayer.path = line?.layer.path
    }

    func dragged(to: CGPoint, on: Canvas) {
        line?.addQuadCurve(point: Point(location: to, velocity: .zero))
        shapeLayer.path = line?.layer.path
    }

    func deactivated(at: CGPoint, on: Canvas) {
    }

    private func makeNewShapeLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.strokeColor = color.cgColor
        layer.opacity = 0.90
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        layer.lineWidth = 10.0
        
        return layer
    }

    func setColor(color: UIColor, animated: Bool = false) {
        lineOptionsView.selectColor(color: color, animated: animated)
    }

    // MARK - LineToolOptionsViewDelegate
    func selected(color: UIColor, optionsView: LineToolOptionsView) {
        self.color = color
    }
}
