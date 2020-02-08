import UIKit
import Dispatch

protocol DrawingViewControllerDelegate: class {
    func didTapCloseButton(button: UIBarButtonItem, for controller: DrawingViewController)
    func didTapShareButton(button: UIBarButtonItem, in view: UIView, for controller: DrawingViewController)
}

final class DrawingViewController: UIViewController, LineToolDelegate {

    weak var delegate: DrawingViewControllerDelegate?

    private let toolbar = UIToolbar()
    private let currentColorControl = ColorWellArrowViewControl(frame: CGRect(x: 0, y: 0, width: 50, height: 44))

    private let stackView = UIStackView()
    private let canvasView = CanvasContainerView(frame: .zero)

    private let lineTool = LineTool()

    private lazy var revealDrawerOnce: DispatchOnce = {
        return DispatchOnce(function: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.setArrowDirection(.down, animated: true)
            })
        })
    }()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        title = "🎨🖌"

        lineTool.delegate = self
        currentColorControl.addTarget(self, action: #selector(tappedCurrentColorWell(colorWell:)), for: .touchUpInside)

        toolbar.tintColor = .black
        toolbar.isTranslucent = false
        canvasView.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = stackView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.insetsLayoutMarginsFromSafeArea = true

        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [
            UIBarButtonItem(image: UIImage(named: "icon_drawing-close"), style: .done, target: self, action: #selector(didTapCloseButton(button:))),
            flex,
            UIBarButtonItem(image: UIImage(named: "icon_drawing-undo"), style: .done, target: canvasView, action: #selector(CanvasContainerView.undo)),
            flex,
            UIBarButtonItem(customView: currentColorControl),
            flex,
            UIBarButtonItem(image: UIImage(named: "icon_drawing-remix"), style: .done, target: self, action: #selector(didTapRemixButton)),
            flex,
            UIBarButtonItem(image: UIImage(named: "icon_drawing-share"), style: .done, target: self, action: #selector(didTapShareButton(button:)))
        ]

        stackView.axis = .vertical
        stackView.addArrangedSubview(canvasView)
        stackView.addArrangedSubview(toolbar)

        canvasView.tool = lineTool

        lineTool.setColor(color: UIColor.drawingColorPalette[0])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        revealDrawerOnce.perform()
    }

    @objc private func tappedCurrentColorWell(colorWell: ColorWellArrowViewControl) {
        let newDirection = colorWell.arrowDirection.opposite
        setArrowDirection(newDirection, animated: true)
    }

    @objc private func didTapShareButton(button: UIBarButtonItem) {
        self.delegate?.didTapShareButton(button: button, in: self.canvasView.viewForSnapshotting, for: self)
    }

    @objc private func didTapCloseButton(button: UIBarButtonItem) {
        delegate?.didTapCloseButton(button: button, for: self)
    }

    @objc private func didTapRemixButton(button: UIBarButtonItem) {
        if canvasView.hasDrawing {
            let alertController = UIAlertController(title: "Clear drawing?", message: "Switching backgrounds will clear your current drawing.", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (action) in
                self.canvasView.clear()
                self.canvasView.nextBackground()
            }))

            present(alertController, animated: true, completion: nil)
        } else {
            canvasView.nextBackground()
        }
    }

    // MARK: - LineToolDelegate

    func didSetColor(color: UIColor, for lineTool: LineTool) {
        currentColorControl.color = color
    }

    // MARK:  - Helpers

    private func setArrowDirection(_ direction: ColorWellArrowDirection, animated: Bool) {
        currentColorControl.setArrowDirection(direction, animated: animated)
        canvasView.setOptionsVisible(direction == .down, animated: animated)
    }
}
