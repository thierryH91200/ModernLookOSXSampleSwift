//
//  MLMainWindow.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLMainWindow: NSWindow {
    
    var buttons: [NSView] = []
    var isVerticalButtons = true
    var value = CGFloat(8)

    static let shared = MLMainWindow()

    @IBOutlet weak var pbContent: NSView!
    @IBOutlet weak var pbToolbar: MLToolbar!
    
    var mlTextView: MLTextView?
    var fieldEditorMarker = NSColor.clear
    
    override func makeKeyAndOrderFront(_ sender: Any?) {
      titlebarAppearsTransparent = true
      isMovableByWindowBackground = true
      titleVisibility = .hidden

      super.makeKeyAndOrderFront(sender)

//      [NSWindow.didResizeNotification, NSWindow.didMoveNotification].forEach { notification in
//        NotificationCenter.default.addObserver(self, selector: #selector(moveWindowButtons), name: notification, object: self)
//      }
      setupButtons()
    }

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing bufferingType: NSWindow.BackingStoreType, defer flag: Bool)
    {
        super.init(contentRect: contentRect, styleMask: [.borderless , .resizable], backing: bufferingType, defer: flag)
        
        self.isOpaque = false
        backgroundColor = NSColor.clear
        isMovableByWindowBackground = true
        styleMask  = [.borderless , .resizable, .closable, .miniaturizable]
        hasShadow = true
//        setupButtons()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.windowDidDeminiaturize(_:)), name: NSWindow.didDeminiaturizeNotification, object: self)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.windowWillClose(_:)), name: NSWindow.willCloseNotification, object: self)
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
        let mp = CGPoint(x: mr.midX, y: mr.midY)
        
        let r = window?.frame
        let wo = CGPoint(x: mp.x - ((r?.size.width ?? 0.0) / 2.0), y: mp.y - ((r?.size.height ?? 0.0) / 2.0))
        window?.setFrameOrigin(wo)
    }
    
    // MARK: - Helper
    fileprivate func setupButtons() {
        
        let contentView = self.contentView!

        if buttons.count == 0 {
            
            ([.closeButton, .miniaturizeButton, .zoomButton] as [NSWindow.ButtonType]).forEach { type in
              guard let button = standardWindowButton(type) else { return }
              button.setFrameOrigin(NSMakePoint(button.frame.origin.x, 12))
                buttons.append(button)
            }

            
//            let close = self.standardWindowButton(NSWindow.ButtonType.closeButton)
//            let minimize = self.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)
//            let maximize = self.standardWindowButton(NSWindow.ButtonType.zoomButton)
//
//            buttons.append(close!)
//            buttons.append(minimize!)
//            buttons.append(maximize!)
        }
        
        buttons.forEach { (btn) in
             btn.superview?.willRemoveSubview(btn)
             btn.removeFromSuperview()
             
             btn.viewWillMove(toSuperview: contentView)
             contentView.addSubview(btn)
             btn.viewDidMoveToSuperview()
         }

        contentView.translatesAutoresizingMaskIntoConstraints = true
        if isVerticalButtons == true {
            
            var offsetY = CGFloat(8)
            for button in buttons {
                
                button.removeConstraints(button.constraints)
                button.translatesAutoresizingMaskIntoConstraints = false

                let constX = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: value)
                let constY = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: offsetY)
                let widthConstraint = button.widthAnchor.constraint(equalToConstant: 14)
                let heightConstraint = button.heightAnchor.constraint(equalToConstant: 14)

                contentView.addConstraints([ constX, constY, widthConstraint, heightConstraint])
                offsetY += 17
            }
        } else {
            
            var offsetX = CGFloat(8)
            for button in buttons {
                
                button.removeConstraints(button.constraints)
                button.translatesAutoresizingMaskIntoConstraints = false

                let constX = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: offsetX)
                let constY = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: value)
                let widthConstraint = button.widthAnchor.constraint(equalToConstant: 14)
                let heightConstraint = button.heightAnchor.constraint(equalToConstant: 14)

                contentView.addConstraints([ constX, constY, widthConstraint, heightConstraint])
                offsetX += 17
            }
            
        }
        contentView.layoutSubtreeIfNeeded()
        contentView.superview!.viewDidEndLiveResize()
    }

}
