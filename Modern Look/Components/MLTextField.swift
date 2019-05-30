//
//  MLCalendarCell.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLTextField: NSTextField {
    
    var _lineWidth : CGFloat = 1.0
    
    @IBInspectable
    var lineWidth : CGFloat  {
        get { return _lineWidth }
        set { _lineWidth = newValue}
    }
    
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
        
        let bottomLine = NSBezierPath()
        var p = NSPoint.zero //bounds.origin;
        p.y = bounds.size.height
        bottomLine.move(to: p)
        p.x += bounds.size.width
        bottomLine.line(to: p)
        bottomLine.lineWidth = _lineWidth
        bottomLine.stroke()
        
        let heightLine = NSBezierPath()
        var p2 = NSPoint.zero //bounds.origin;
        heightLine.move(to: p2)
        p2.y = bounds.size.height
        heightLine.line(to: p2)
        heightLine.lineWidth = _lineWidth
        heightLine.stroke()

        NSGraphicsContext.restoreGraphicsState()
    }
    
}
