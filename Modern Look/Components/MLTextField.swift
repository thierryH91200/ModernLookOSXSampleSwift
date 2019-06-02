//
//  MLCalendarCell.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLTextField: NSTextField {
    
    @IBInspectable var lineWidth : CGFloat  = 1.0
    
    @IBInspectable var isBottom: Bool = true
    @IBInspectable var isLeft: Bool = true
    @IBInspectable var isTop: Bool = false
    @IBInspectable var isRight: Bool = false

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        font = NSFont(name: "Helvetica Neue Thin", size: 16.0)
        isBordered = false
        backgroundColor = .clear
        focusRingType = .none
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSGraphicsContext.saveGraphicsState()
        
        let bounds = self.bounds
        textColor?.set()
        
        let line = NSBezierPath()

        if isBottom == true {
            var point = CGPoint.zero
            point.y = bounds.size.height
            line.move(to: point)
            point.x += bounds.size.width
            line.line(to: point)
            line.lineWidth = lineWidth
            line.stroke()
        }
        
        if isLeft == true {
            var point = CGPoint.zero
            line.move(to: point)
            point.y = bounds.size.height
            line.line(to: point)
            line.lineWidth = lineWidth
            line.stroke()
        }

        if isTop == true {
            var point = CGPoint.zero
            line.move(to: point)
            point.x += bounds.size.width
            line.line(to: point)
            line.lineWidth = lineWidth
            line.stroke()
        }

        if isRight == true {
            var point = CGPoint.zero
            point.x += bounds.size.width
            line.move(to: point)
            point.y = bounds.size.height
            line.line(to: point)
            line.lineWidth = lineWidth
            line.stroke()
        }

        NSGraphicsContext.restoreGraphicsState()
    }
    
}
