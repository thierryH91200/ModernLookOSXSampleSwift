//
//  MLCenteredWindow.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 22/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

final class MLCenteredWindow: MLMainWindow {
    
    override var canBecomeMain: Bool {
        return false
    }
    
    override func center() {
        let mr: NSRect = NSApplication.shared.mainWindow!.frame
        let mp = NSPoint(x: mr.midX, y: mr.midY)
        
        var r = frame
        let wo = NSPoint(x: mp.x - (r.size.width / 2.0), y: mp.y - (r.size.height / 2.0))
        r.origin = wo
        setFrameOrigin(wo)
    }
    
}
