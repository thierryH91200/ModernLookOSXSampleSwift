//
//  MLColoredButton.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLColoredButton: NSButton {
    
    let ML_COLORED_BUTTON_ROUNDED_RECT_RADIUS = CGFloat(5)

    var backgroundColor = NSColor.white
    var textColor = NSColor.black

    override  init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = NSColor.clear
        textColor = NSColor.black
        isBordered = false
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        NSGraphicsContext.saveGraphicsState()
        var bounds = self.bounds
        bounds = bounds.insetBy(dx: 0.5, dy: 0.5)
        
        let borderPath = NSBezierPath(roundedRect: bounds, xRadius: ML_COLORED_BUTTON_ROUNDED_RECT_RADIUS, yRadius: ML_COLORED_BUTTON_ROUNDED_RECT_RADIUS)
        
        if isHighlighted == true {
            NSColor.gray.set()
        } else {
            backgroundColor.set()
        }
        borderPath.fill()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = alignment
        
        let attrs : [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font!,
            .foregroundColor: textColor
        ]
        title.draw(in: bounds, withAttributes: attrs)
        
        NSColor.lightGray.set()
        borderPath.lineWidth = 0.3
        borderPath.stroke()
        
        NSGraphicsContext.restoreGraphicsState()
        
    }
    
}
