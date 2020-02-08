import UIKit

protocol DrawingFramer {
    func frame(drawingView: UIView) -> UIImage?
}

struct StandardDrawingFramer: DrawingFramer {
    let topText: String
    let bottomText: String

    func frame(drawingView: UIView) -> UIImage? {
        let frameView = StandardDrawingFrameView(topText: topText,
                                             bottomText: bottomText,
                                             artworkView: drawingView)

        frameView.frame.size = frameView.intrinsicContentSize

        return frameView.image()
    }
}
