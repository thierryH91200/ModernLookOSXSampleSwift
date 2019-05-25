//
//  MLAlertWindow.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 22/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import Cocoa

class MLAlertWindow: MLCenteredWindow {
    
    override func cancelOperation(_ sender: Any?) {
        NSApp.stopModal( withCode: .cancel)
    }
    
    override var canBecomeMain: Bool {
        return false
    }
}
