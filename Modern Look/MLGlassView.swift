//
//  MLGlassView.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLGlassView: NSView {
    
    var backgroundColor = NSColor.controlBackgroundColor
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        backgroundColor = .controlBackgroundColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .controlBackgroundColor
    }
    
    func commonInit() {
        backgroundColor = .controlBackgroundColor
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}
