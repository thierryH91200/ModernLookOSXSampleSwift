//
//  MLWindowContent.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLWindowContent: MLGlassView {
    
    override func draw(_ rect: NSRect) {
        
        NSGraphicsContext.saveGraphicsState()
        let bounds = self.bounds
        let borderPath = NSBezierPath(roundedRect: bounds, xRadius: ML_MAIN_WINDOW_ROUNDED_RECT_RADIUS, yRadius: ML_MAIN_WINDOW_ROUNDED_RECT_RADIUS)
        backgroundColor.set()
        borderPath.fill()
        
        NSGraphicsContext.restoreGraphicsState()
    }

}
