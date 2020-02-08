//
//  UIView+Helpers.swift
//  Frenchie
//
//  Created by Brian Michel on 2/8/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

extension UIView {
    func image(scale: CGFloat = 0.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, scale)

        defer {
            UIGraphicsEndImageContext()
        }

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        layer.render(in: context)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }

        return image
    }
    
    static func makeDivider(_ width: CGFloat, height: CGFloat = 0.5, origin: CGPoint? = nil) -> UIView {
        let dividerLine = IntrinsicContentSizeView()
        
        dividerLine.frame.size.width = width
        dividerLine.frame.size.height = height
        
        if origin != nil {
            dividerLine.frame.origin = origin!
        }
        
        dividerLine.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        return dividerLine
    }
}
