//
//  MLComboFieldDelegate.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 22/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLComboFieldDelegate : NSObject {
        
    var popupContent: MLPopupContent?
    var dontSearch = false
    var comboField: MLComboField?
    
    override init() {
        super.init()
        dontSearch = false
    }
    
    func createPopupContent() -> MLPopupContent? {
        return nil
    }
    
    @discardableResult
    func showPopup(for control: NSControl) -> Bool {
        if !(popupContent != nil) {
            popupContent = createPopupContent()
            popupContent?.delegate = self
        }
        return MLPopupWindowManager.shared.showPopup(for: control, withContent: popupContent?.view)
    }
    
    func displayPopupFirstTime(_ control: NSControl?) {
        
        if showPopup(for: control!) == false {
            if comboField?.stringValue != "" {
                popupContent?.moveSelection(to: comboField?.stringValue)
            } else {
                popupContent?.selectFirstItem()
            }
        } else {
            popupContent?.moveSelectionUp(false)
        }
    }
    
    func handleMouseClick(_ control: NSControl?) {
        if (control is MLComboField) {
            comboField = (control as! MLComboField)
        }
        displayPopupFirstTime(control)
    }

}

extension MLComboFieldDelegate : MLPopupContentDelegate {
    
    func selectionDidChange(_ sel: Any?, fromUpDown updown: Bool) {
        let object = sel as? PBCategory
        if updown == true {
            let description = object?.name
            print(description!)
            comboField?.stringValue = description!
        }
        comboField?.selectedItem = object
    }
    
    func requestClose() {
        MLPopupWindowManager.shared.hidePopup()
    }
}

extension MLComboFieldDelegate :  NSTextFieldDelegate {
    
    func control(_ control: NSControl, isValidObject object: Any?) -> Bool {
        return true
    }
    
    func control(_ control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
        showPopup(for: control)
        return true
    }
    
    func controlTextDidChange(_ notification: Notification) {
        
        let control = notification.object as? NSControl
        
        comboField = nil
        if control is MLComboField {
            comboField = (control as! MLComboField)
        }
        if comboField == nil {
            return
        }
        showPopup(for: control!)
        
        if dontSearch  == true {
            dontSearch = false
            return
        }
        
        var editor: NSTextView?
        if (control?.currentEditor() is NSTextView) {
            editor = control?.currentEditor() as? NSTextView
        }
        
        guard editor != nil else { return }
        
        let s = popupContent?.moveSelection(to: control?.stringValue)
        if s != "" {
            let insertionPoint: Int = (editor?.selectedRanges[0].rangeValue.location)!
            editor!.string = s!
            var r: NSRange?
            r?.length = s!.count - insertionPoint
            r?.location = insertionPoint
            if let r = r {
                editor?.selectedRange = r
            }
        }
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        comboField = nil
        if (control is MLComboField) {
            comboField = control as? MLComboField
        }
        if commandSelector == #selector( NSResponder.moveUp(_:)) {
            if showPopup(for: control) {
                popupContent?.moveSelectionUp(true)
            }
            return true
        }
        if commandSelector == #selector(NSResponder.deleteBackward(_:)) {
            dontSearch = true
            return false
        }
        if commandSelector == #selector(NSResponder.moveDown(_:)) {
            displayPopupFirstTime(control)
            return true
        }
        if commandSelector == #selector(NSResponder.cancelOperation(_:)) {
            MLPopupWindowManager.shared.hidePopup()
            return true
        }
        return false
    }
    
    func control(_ control: NSControl, textView: NSTextView, completions words: [String], forPartialWordRange charRange: NSRange, indexOfSelectedItem index: UnsafeMutablePointer<Int>) -> [String] {
        return []
    }
    
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        MLPopupWindowManager.shared.hidePopup()
        return true
    }
    
    
    
    
}

