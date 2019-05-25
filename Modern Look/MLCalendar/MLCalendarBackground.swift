//
//  MLCalendarBackground.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

final class MLCalendarBackground: NSView {
    
    var backgroundColor: NSColor = .white
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = NSColor.white
    }
    
    override func draw(_ dirtyRect: NSRect) {
        backgroundColor.set()
        bounds.fill()
    }
    
}
