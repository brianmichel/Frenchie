import UIKit

struct DrawingFramingOptions {
    let topText: String
    let bottomText: String
}

final class DrawingCoordinator: DrawingViewControllerDelegate {
    private let drawingViewController = DrawingViewController()
    private let drawingFramer: DrawingFramer

    init(framingOptions: DrawingFramingOptions) {
        drawingFramer = StandardDrawingFramer(topText: framingOptions.topText, bottomText: framingOptions.bottomText)
        drawingViewController.delegate = self
        drawingViewController.modalPresentationStyle = .fullScreen
    }

    func start(on viewController: UIViewController) {
        viewController.addChildViewControllerCompletely(drawingViewController)
        
        drawingViewController.view.frame = viewController.view.bounds
    }

    // MARK: - DrawingViewControllerDelegate

    func didTapCloseButton(button: UIBarButtonItem, for controller: DrawingViewController) {
        drawingViewController.dismiss(animated: true, completion: nil)
    }

    func didTapShareButton(button: UIBarButtonItem, in view: UIView, for controller: DrawingViewController) {
        guard let image = drawingFramer.frame(drawingView: view) else {
            return
        }

        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)

        controller.present(activityController, animated: true, completion: nil)
    }
} 
