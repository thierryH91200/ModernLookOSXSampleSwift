//
//  MLAlertWindow.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 22/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import Cocoa

class MLAlertWindow: MLCenteredWindow {
    
    let MLALERT_YES = 0
    let MLALERT_NO = 1
    let MLALERT_CANCEL = 2

    
    override func cancelOperation(_ sender: Any?) {
        NSApp.stopModal( withCode: .cancel)
    }
    
    override var canBecomeMain: Bool {
        return false
    }


}
