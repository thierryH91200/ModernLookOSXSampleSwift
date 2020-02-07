//
//  MLTextView.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

final class MLTextView: NSTextView {
    
    var fieldEditorMarker =  NSColor.clear
    
    
    override init(frame frameRect: NSRect)
    {
        super.init(frame: frameRect)
        
        isFieldEditor = true
        super.focusRingType = .none
    }
    
    override init(frame: NSRect, textContainer:NSTextContainer?) {
        super.init(frame: frame, textContainer:textContainer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var drawsBackground: Bool {
        get {
            return super.drawsBackground
        }
        set(drawsBackground) {
            super.drawsBackground = false
        }
    }
    
    override var focusRingType: NSFocusRingType {
        get {
            return super.focusRingType
        }
        set {
            super.focusRingType = .none
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let bounds = self.bounds
        fieldEditorMarker.set()
        
        let bottomLine = NSBezierPath()
        var p = CGPoint.zero
        p.y = bounds.size.height - 1
        bottomLine.move(to: p)
        p.x += bounds.size.width
        bottomLine.line(to: p)
        bottomLine.lineWidth = 2.0
        bottomLine.stroke()
    }
    
}
