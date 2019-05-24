//
//  MLPopupContent.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 22/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

protocol MLPopupContentDelegate {
    func selectionDidChange(_ sel: Any?, fromUpDown updown: Bool)
    func requestClose()
}

class MLPopupContent: NSViewController {
    
    var delegate: MLPopupContentDelegate?
    
    func moveSelectionUp(_ up: Bool) {
    }
    
    @discardableResult
    func moveSelection(to str: String?) -> String? {
        return nil
    }
    
    func selectFirstItem() {
    }
    
}
