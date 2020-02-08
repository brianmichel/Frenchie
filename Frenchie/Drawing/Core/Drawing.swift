import UIKit

// From https://github.com/brianmichel/Sketchy/blob/master/Sketchy/Classes/Drawing.swift
struct Point {
    let location: CGPoint
    let velocity: CGPoint

    func midpoint(previous: Point) -> Point {
        let previousLocation = previous.location
        let currentLocation = self.location

        let midpointX = (previousLocation.x + currentLocation.x) / 2.0
        let midpointY = (previousLocation.y + currentLocation.y) / 2.0

        return Point(location: CGPoint(x: midpointX, y: midpointY), velocity: self.velocity)
    }
}

protocol Shape {
    var points: [Point] { get }

    init(point: Point)
}

final class Line: Shape {
    let layer = CAShapeLayer()

    private let bezierPath = UIBezierPath()

    var points: [Point] = []

    init(point: Point) {
        bezierPath.move(to: point.location)
        points.append(point)
    }

    deinit {
        layer.removeFromSuperlayer()
    }

    func addLineToPoint(point: Point) {
        points.append(point)
        bezierPath.addLine(to: point.location)

        layer.path = bezierPath.cgPath
    }

    func addQuadCurve(point: Point) {
        if let lastPoint = points.last {
            let midpoint = point.midpoint(previous: lastPoint)
            bezierPath.addQuadCurve(to: midpoint.location, controlPoint: lastPoint.location)
            points.append(point)
        }

        layer.path = bezierPath.cgPath
    }
}

protocol CanvasTool {
    var size: CGSize { get }
    var toolView: UIView { get }
    var toolOptionsView: UIView? { get }

    func dragged(to: CGPoint, on: Canvas)
    func activated(at: CGPoint, on: Canvas)
    func deactivated(at: CGPoint, on: Canvas)
}

protocol Canvas {
    var size: CGSize { get }
    var tool: CanvasTool? { get set }
    var hasDrawing: Bool { get }
    func add(_ layer: CALayer)
}
