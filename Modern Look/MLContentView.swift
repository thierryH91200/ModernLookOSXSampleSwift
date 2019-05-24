//
//  MLContentView.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLContentView: MLGlassView {

    override func draw(_ rect: NSRect) {
        
        NSGraphicsContext.saveGraphicsState()
        
        var upperBounds = self.bounds
        upperBounds.size.height -= 10
        upperBounds.origin.y += 10
        
        let borderPath = NSBezierPath(roundedRect: self.bounds, xRadius: 5, yRadius: 5)
        borderPath.appendRect(upperBounds)
        backgroundColor.set()
        borderPath.fill()
        
        NSGraphicsContext.restoreGraphicsState()
    }
}

