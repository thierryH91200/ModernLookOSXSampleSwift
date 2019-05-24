//
//  MLToolbar.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

let ML_MAIN_WINDOW_ROUNDED_RECT_RADIUS = CGFloat(5)


class MLToolbar: MLGlassView {
    
    @objc var isVerticalButtons = true
    var hiddenButtons = false
    var justClose = false
    
    var closeButton = NSButton()
    var minimizeButton = NSButton()
    var maximizeButton = NSButton()
    
    var trackingArea : NSTrackingArea?
    
    override init(frame frameRect: NSRect) {
        if frameRect.size.height > 20 {
            isVerticalButtons = true
        } else {
            isVerticalButtons = false
        }
        
        super.init(frame: frameRect)
        //        self.verticalButtons = verticalButtons
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    @objc func setHiddenButtons(_ hiddenButtons: Bool) {
        self.hiddenButtons = hiddenButtons
        if self.hiddenButtons {
            closeButton.removeFromSuperviewWithoutNeedingDisplay()
            minimizeButton.removeFromSuperviewWithoutNeedingDisplay()
            maximizeButton.removeFromSuperviewWithoutNeedingDisplay()
        }
        createTrackingArea()
    }
    
    func setVerticalButtons(_ verticalButtons: Bool) {
        
        self.isVerticalButtons = verticalButtons
        let b = bounds

        if self.isVerticalButtons == true {
            
            var y = b.size.height
            let bh = closeButton.bounds.size.height
            y = y - bh - 5
            let x = CGFloat(8)
            
            closeButton.setFrameOrigin(CGPoint(x: x, y: y))
            minimizeButton.setFrameOrigin(CGPoint(x: x, y: y - bh - 3))
            maximizeButton.setFrameOrigin(CGPoint(x: x, y: y - bh - 3 - bh - 3))
            
        } else {
            
            var y = b.size.height
            let bh = closeButton.bounds.size.height
            let bw: CGFloat = closeButton.bounds.size.width
            y = y - bh - 5
            let x = CGFloat(8)

            closeButton.setFrameOrigin(CGPoint(x: x, y: y))
            minimizeButton.setFrameOrigin(CGPoint(x: x + 2 + bw, y: y))
            maximizeButton.setFrameOrigin(CGPoint(x: x + 2 + bw + 2 + bw, y: y))
        }
        createTrackingArea()
    }
    
    func createTrackingArea() {
        
        if trackingArea != nil {
            if let trackingArea = trackingArea {
                removeTrackingArea(trackingArea)
            }
        }
        
        guard hiddenButtons == false else { return }
        
        var buttonsRect = NSRect.zero
        let b = bounds
        
        if isVerticalButtons == true {
            
            var y = b.size.height
            let bh = closeButton.bounds.size.height
            let bw = closeButton.bounds.size.width
            y = y - bh - 5
            let x = CGFloat(8)
            
            if self.justClose == true{
                buttonsRect.origin = CGPoint(x: x, y: y)
                buttonsRect.size = NSMakeSize(bw, bh + 3)
            } else {
                buttonsRect.origin = CGPoint(x: x, y: y - bh - 3 - bh - 3)
                buttonsRect.size = NSMakeSize(bw, bh + 3 + bh + 3 + bh)
                
            }
        } else {
            
            var y = b.size.height
            let bh = closeButton.bounds.size.height
            let bw = closeButton.bounds.size.width
            y = y - bh - 5
            let x = CGFloat(8)

            if self.justClose == true {
                buttonsRect.origin = CGPoint(x: x, y: y)
                buttonsRect.size = NSMakeSize(bw + 2, bh)
            } else {
                buttonsRect.origin = CGPoint(x: x, y: y)
                buttonsRect.size = NSMakeSize(bw + 2 + bw + bw, bh)
            }
        }
        
        trackingArea = NSTrackingArea(rect: buttonsRect, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        addTrackingArea(trackingArea!)
    }
    
    override func mouseEntered(with theEvent: NSEvent) {
        closeButton.isHighlighted = true
        minimizeButton.isHighlighted = true
        maximizeButton.isHighlighted = true
    }
    
    override func mouseExited(with theEvent: NSEvent) {
        closeButton.isHighlighted = false
        minimizeButton.isHighlighted = false
        maximizeButton.isHighlighted = false
    }
    
    func setJustClose(_ justClose: Bool) {
        self.justClose = justClose
        if justClose {
            minimizeButton.isHidden = justClose
            maximizeButton.isHidden = justClose
        }
        createTrackingArea()
    }
    
    override func commonInit() {
        
        super.commonInit()
        
        setVerticalButtons(true) // ?????????
        hiddenButtons = false
        justClose = false
        
        if self.hiddenButtons == false {

            closeButton = NSWindow.standardWindowButton(.closeButton, for: NSWindow.StyleMask.closable)!
            minimizeButton = NSWindow.standardWindowButton(.miniaturizeButton, for: NSWindow.StyleMask.miniaturizable)!
            maximizeButton = NSWindow.standardWindowButton(.zoomButton, for: NSWindow.StyleMask.resizable)!
            
            closeButton.setButtonType(.momentaryChange)
            
            let b: NSRect = bounds
            var y: CGFloat = b.size.height
            
            let bh: CGFloat = closeButton.bounds.size.height
            let bw: CGFloat = closeButton.bounds.size.width
            
            y = y - bh - 5
            
            let x: CGFloat = 8
            closeButton.setFrameOrigin(NSPoint(x: x, y: y))
            minimizeButton.setFrameOrigin(NSPoint(x: x + 2 + bw, y: y))
            maximizeButton.setFrameOrigin(NSPoint(x: x + 2 + bw + 2 + bw, y: y))
            
            addSubview(closeButton)
            addSubview(minimizeButton)
            addSubview(maximizeButton)
        }
        createTrackingArea()
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        NSGraphicsContext.saveGraphicsState()
        
        var lowerBounds: NSRect = bounds
        lowerBounds.size.height -= 10
        
        let borderPath = NSBezierPath(roundedRect: bounds, xRadius: ML_MAIN_WINDOW_ROUNDED_RECT_RADIUS, yRadius: ML_MAIN_WINDOW_ROUNDED_RECT_RADIUS)
        borderPath.appendRect(lowerBounds)
        backgroundColor.set()
        borderPath.fill()
        
        
        NSColor.black.set()
        let bottomLine = NSBezierPath()
        var p = bounds.origin
        bottomLine.move(to: p)
        p.x += bounds.size.width
        bottomLine.line(to: p)
        bottomLine.stroke()
        
        if isVerticalButtons && !hiddenButtons && !justClose {
            
            let sepLine = NSBezierPath()
            var origin = bounds.origin
            origin.x += 29
            sepLine.move(to: origin)
            origin.y += bounds.size.height
            sepLine.line(to: origin)
            sepLine.lineWidth = 0.4
            sepLine.stroke()
        }
        NSGraphicsContext.restoreGraphicsState()
    }
    
}
