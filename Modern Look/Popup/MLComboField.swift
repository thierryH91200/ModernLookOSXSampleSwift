//
//  MLComboField.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 22/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLComboField: MLTextField {
    
    var selectedItem: Any?

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func selectText(_ sender: Any?) {
        super.selectText(sender)
        
        let insertionPoint = stringValue.count
        let range = NSRange(location: insertionPoint, length: 0)

        let textEditor = window?.fieldEditor(true, for: self)
        textEditor?.selectedRange = range
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        super.mouseDown(with: theEvent)
        
        let d = delegate as? MLComboFieldDelegate
        d?.handleMouseClick(self)
        
        print("Mouse down!")
    }
    
    func hidePopup() {
        MLPopupWindowManager.shared.hidePopup()
    }
    
    override func textDidEndEditing(_ notification: Notification) {
        MLPopupWindowManager.shared.hidePopup()
        
        let insertionPoint = stringValue.count
        let range = NSRange(location: insertionPoint, length: 0)
        
        let textEditor = window?.fieldEditor(true, for: self)
        textEditor?.selectedRange = range
        
        super.textDidEndEditing(notification)
    }
    
    
}
