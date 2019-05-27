//
//  MLPopupWindowManager.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 22/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

final class MLPopupWindowManager: NSObject {
    
    weak var control: NSControl?
    var popupWindow: MLPopupWindow?
    
    var originalHeight: CGFloat = 0.0
    
    static let shared = MLPopupWindowManager()
    
    override init() {
        super.init()
        var contentRect = NSRect.zero
        contentRect.size.height = 200
        popupWindow = MLPopupWindow(contentRect: contentRect, styleMask: .borderless, backing: .buffered, defer: false)
        popupWindow?.isMovableByWindowBackground = false
        popupWindow?.isExcludedFromWindowsMenu = true
        popupWindow?.hasShadow = true
        //        [self.popupWindow setTitleVisibility:NSWindowTitleHidden];
    }
    
    func showPopup(for control: NSControl?, withContent content: NSView?) -> Bool {
        
        guard self.control != control else { return true }
        
        if (self.control != nil) {
            hidePopup()
        }
        self.control = control
        originalHeight = (content?.bounds.size.height)!
        if let content = content {
            popupWindow?.contentView = content
        }
        layoutPopupWindow()
        control?.window?.addChildWindow(popupWindow!, ordered: .above)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.windowDidResize(_:)), name: NSWindow.didResizeNotification, object: control?.window)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidResignActive(_:)), name: NSApplication.didResignActiveNotification, object: NSApplication.shared)
        
        return false
    }
    
    @objc func applicationDidResignActive(_ note: Notification) {
        hidePopup()
    }
    
    func hidePopup() {
        if (popupWindow != nil) {
            popupWindow?.orderOut(self)
            control?.window?.removeChildWindow(popupWindow!)
            NotificationCenter.default.removeObserver(self)
        }
        control = nil
    }
    
    func layoutPopupWindow() {
        
        guard self.control != nil else { return }
        
        var screenFrame = NSRect.zero
        if (popupWindow != nil) && ((popupWindow?.screen) != nil) {
            screenFrame = (popupWindow?.screen?.visibleFrame)!
        } else {
            screenFrame = NSScreen.main?.visibleFrame ?? NSRect.zero
        }
        
        let screenRect: NSRect = (control?.window!.convertToScreen(control!.frame))!
        var frame = NSRect.zero
        let contentRect = control?.bounds
        frame.size.width = (contentRect?.size.width)!
        frame.size.height = originalHeight
        frame.origin.x = screenRect.origin.x
        frame.origin.y = screenRect.origin.y - originalHeight
        
        let x1 = frame.origin.x
        let y1 = frame.origin.y
        let x2 = x1 + frame.size.width
        
        if x1 < screenFrame.origin.x {
            frame.origin.x = screenFrame.origin.x
        }
        if y1 < screenFrame.origin.y {
            frame.origin.y = screenRect.origin.y + (contentRect?.size.height)!
        }
        if x2 > screenFrame.size.width {
            frame.origin.x -= x2 - screenFrame.size.width
        }
        popupWindow?.setFrame(frame, display: false)
        
    }
    
    func windowDidResignKey(_ notification: Notification) {
        hidePopup()
    }
    
    @objc func windowDidResize(_ notification: Notification) {
        layoutPopupWindow()
    }
    
}
