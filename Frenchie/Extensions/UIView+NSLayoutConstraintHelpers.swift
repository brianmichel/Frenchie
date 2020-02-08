//
//  UIView+NSLayoutConstraintHelpers.swift
//  Frenchie
//
//  Created by Brian Michel on 2/8/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

extension UIView {
    func pin(to view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ]
    }
}
