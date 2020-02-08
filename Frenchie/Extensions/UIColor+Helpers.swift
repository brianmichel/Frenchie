//
//  UIColor+Helpers.swift
//  Frenchie
//
//  Created by Brian Michel on 2/8/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

extension UIColor {
    static let drawingColorPalette = [
        UIColor(hex: 0xF7323F),
        UIColor(hex: 0xFFFF01),
        UIColor(hex: 0x00FF01),
        UIColor(hex: 0x00FFFF),
        UIColor(hex: 0x0000FF),
        UIColor(hex: 0xFF00FF),
        UIColor(hex: 0xFFFF7B),
        UIColor(hex: 0x00FF7B),
        UIColor(hex: 0x7BFFFF),
        UIColor(hex: 0x7B7BFF),
        UIColor(hex: 0xFF007C),
        UIColor(hex: 0xFF7B3A),
        UIColor(hex: 0x000000),
        UIColor(hex: 0xFFFFFF)
    ]
    
    var luminosity: CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return CGFloat(
            sqrtf(
                0.241 * powf(Float(red), 2) +
                0.691 * powf(Float(green), 2) +
                0.068 * powf(Float(blue), 2)
        ))
    }

    var blackOrWhiteTintColorForLuminosity: UIColor {
        return luminosity > 0.90 ? .black : .white
    }
    
    // From SO Answer: http://stackoverflow.com/a/24263296/213906
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}
