//
//  DispatchOnce.swift
//  Frenchie
//
//  Created by Brian Michel on 2/8/20.
//  Copyright © 2020 Brian Michel. All rights reserved.
//

import Foundation

struct DispatchOnce {
    private let operationQueue = OperationQueue()
    
    init(function: @escaping () -> Void) {
        operationQueue.isSuspended = true
        operationQueue.addOperation(function)
    }
    
    func perform() {
        operationQueue.isSuspended = false
    }
}
