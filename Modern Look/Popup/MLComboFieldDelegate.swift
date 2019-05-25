//
//  MLComboFieldDelegate.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 22/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

final class MLComboFieldDelegate : NSObject {
    
//        var description: String = ""
    
    var popupContent: MLPopupContent?
    var dontSearch = false
    var combo: MLComboField?
    
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
        if !showPopup(for: control!) {
            if combo?.stringValue != "" {
                popupContent?.moveSelection(to: combo?.stringValue)
            } else {
                popupContent?.selectFirstItem()
            }
        } else {
            popupContent?.moveSelectionUp(false)
        }
    }
    
    func handleMouseClick(_ control: NSControl?) {
        if (control is MLComboField) {
            combo = control as? MLComboField
        }
        displayPopupFirstTime(control)
    }
    
    
}

extension MLComboFieldDelegate : MLPopupContentDelegate {
    func selectionDidChange(_ sel: Any?, fromUpDown updown: Bool) {
        let o = sel as? NSObject
        if updown == true {
            combo?.stringValue = o?.description ?? ""
        }
        combo?.selectedItem = o
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
    
    func controlTextDidChange(_ obj: Notification) {
        
        let control = obj.object as? NSControl
        
        combo = nil
        if control is MLComboField {
            combo = control as? MLComboField
        }
        if !(combo != nil) {
            return
        }
        showPopup(for: control!)
        
        
        if dontSearch  == true {
            dontSearch = false
            return
        }
        
        //    NSTextField* tfc = (NSTextField*)control;
        var editor: NSTextView? = nil
        if (control?.currentEditor() is NSTextView) {
            editor = control?.currentEditor() as? NSTextView
        }
        
        if !(editor != nil) {
            return
        }
        
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
        combo = nil
        if (control is MLComboField) {
            combo = control as? MLComboField
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

