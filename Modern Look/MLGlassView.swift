//
//  MLGlassView.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLGlassView: NSView {
    
    var backgroundColor = NSColor.windowBackgroundColor
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        backgroundColor = NSColor.windowBackgroundColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = NSColor.windowBackgroundColor
    }
    
    func commonInit() {
        backgroundColor = NSColor.windowBackgroundColor
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}
