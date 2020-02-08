//
//  RootViewController.swift
//  Frenchie
//
//  Created by Brian Michel on 2/8/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    private let drawingCoordinator = DrawingCoordinator(framingOptions: DrawingFramingOptions(topText: "Wow you did great",
                                                                                            bottomText: "Show your friends"))
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        drawingCoordinator.start(on: self)
    }
}

