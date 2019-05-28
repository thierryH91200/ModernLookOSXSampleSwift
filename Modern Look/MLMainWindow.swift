//
//  MLMainWindow.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLMainWindow: NSWindow {
    
    static let shared = MLMainWindow()

    @IBOutlet weak var pbContent: NSView!
    @IBOutlet weak var pbToolbar: MLToolbar!
    
    var mlTextView: MLTextView?
    var fieldEditorMarker = NSColor.clear
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing bufferingType: NSWindow.BackingStoreType, defer flag: Bool)
    {
        super.init(contentRect: contentRect, styleMask: [.borderless , .resizable], backing: bufferingType, defer: flag)
        
        self.isOpaque = false
        backgroundColor = NSColor.clear
        isMovableByWindowBackground = true
        styleMask  = [.borderless , .resizable]
        hasShadow = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.windowDidDeminiaturize(_:)), name: NSWindow.didDeminiaturizeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.windowWillClose(_:)), name: NSWindow.willCloseNotification, object: self)
    }
    
    override func becomeMain() {
        super.becomeMain()
        NSApp.addWindowsItem(self, title: title, filename: false)
    }
    
    @objc func windowWillClose(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: NSWindow.didDeminiaturizeNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: NSWindow.willCloseNotification, object: self)
    }
    
    @objc func windowDidDeminiaturize(_ notification: Notification) {
        invalidateShadow()
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override var canBecomeMain: Bool {
        return true
    }
    
    func showContent(_ cv: NSView) {
        cv.alphaValue = 0
        cv.wantsLayer = true
        
        pbContent.removeConstraints(pbContent.constraints)
        
        NSAnimationContext.current.duration = 1.0
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        if pbContent.subviews.count > 0 {
            pbContent.subviews[0].alphaValue = 0.0
        }
        
        pbContent.subviews = [cv]
        
        let viewsDictionary = [ "c" : cv ]
        pbContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[c]|", options: [], metrics: nil, views: viewsDictionary))
        pbContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[c]|", options: [], metrics: nil, views: viewsDictionary))
        
        NSAnimationContext.beginGrouping()
        cv.animator().alphaValue = 1.0
        NSAnimationContext.endGrouping()
    }
    
    func showToolBar(_ cv: NSView) {
        
        cv.alphaValue = 0
        
        pbToolbar.removeConstraints(pbToolbar.constraints)
        NSAnimationContext.current.duration = 1.0
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        if pbToolbar.subviews.count > 0 {
            pbToolbar.subviews[0].alphaValue = 0.0
        }
        
        pbToolbar.subviews = [cv]
        
        let viewsDictionary = [ "c" : cv ]
        pbToolbar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[c]|", options: [], metrics: nil, views: viewsDictionary))
        pbToolbar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[c]|", options: [], metrics: nil, views: viewsDictionary))
        
        NSAnimationContext.beginGrouping()
        cv.animator().alphaValue = 1.0
        NSAnimationContext.endGrouping()
    }

    override func sendEvent(_ event: NSEvent) {
        if event.type == .leftMouseUp {
            MLPopupWindowManager.shared.hidePopup()
        }
        super.sendEvent(event)
    }
    
    override func fieldEditor(_ createFlag: Bool, for object: Any?) -> NSText? {
        if (object is MLTableView) || (object is MLOutlineView) {
            if !(mlTextView != nil) {
                mlTextView = MLTextView( frame : frame)
                mlTextView?.fieldEditorMarker = fieldEditorMarker
            }
            return mlTextView
        }
        let ret = super.fieldEditor(createFlag, for: object)
        return ret
    }
    
    override func cancelOperation(_ sender: Any?) {
        print("cancelOperation - MLMainWindow")
    }
    
    func relativeCenter(_ window: NSWindow?) {
        
        let mr = NSApplication.shared.mainWindow!.frame
        let mp = NSPoint(x: mr.midX, y: mr.midY)
        
        let r = window?.frame
        let wo = NSPoint(x: mp.x - ((r?.size.width ?? 0.0) / 2.0), y: mp.y - ((r?.size.height ?? 0.0) / 2.0))
        window?.setFrameOrigin(wo)
    }
}
