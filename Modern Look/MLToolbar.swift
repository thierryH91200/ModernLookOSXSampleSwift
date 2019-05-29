//
//  MLToolbar.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

let ML_MAIN_WINDOW_ROUNDED_RECT_RADIUS = CGFloat(5)


@IBDesignable
final class MLToolbar: MLGlassView {
    
    var closeButton = NSButton()
    var minimizeButton = NSButton()
    var maximizeButton = NSButton()
    
    var trackingArea : NSTrackingArea?
    
    var _isVerticalButtons = true
    @IBInspectable 
    var isVerticalButtons : Bool {
        get { return _isVerticalButtons }
        set {
            _isVerticalButtons = newValue
            createTrackingArea()
        }
    }

    var _hiddenButtons = false
    var hiddenButtons : Bool {
        get { return _hiddenButtons }
        set {
            _hiddenButtons = newValue
            if newValue == true {
                closeButton.removeFromSuperviewWithoutNeedingDisplay()
                minimizeButton.removeFromSuperviewWithoutNeedingDisplay()
                maximizeButton.removeFromSuperviewWithoutNeedingDisplay()
            }
            createTrackingArea()
        }
    }
    
    var _justClose = false
    var justClose : Bool {
        get { return _justClose }
        set {
            _justClose = newValue
            if newValue == true  {
                minimizeButton.isHidden = newValue
                maximizeButton.isHidden = newValue
            }
            createTrackingArea()
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

//        if frameRect.size.height > 20 {
//            isVerticalButtons = true
//        } else {
//            isVerticalButtons = false
//        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func commonInit() {
        
        super.commonInit()
        
        if self.hiddenButtons == false {
            
            closeButton = NSWindow.standardWindowButton(.closeButton, for: .closable)!
            minimizeButton = NSWindow.standardWindowButton(.miniaturizeButton, for: .miniaturizable)!
            maximizeButton = NSWindow.standardWindowButton(.zoomButton, for: .resizable)!
            
            closeButton.setButtonType(.momentaryChange)
            
            let b = bounds
            var y = b.size.height
            
            let bh = closeButton.bounds.size.height
            let bw = closeButton.bounds.size.width
            
            y = y - bh - 5
            let x : CGFloat = 8
            
            closeButton.setFrameOrigin(NSPoint(x: x, y: y))
            minimizeButton.setFrameOrigin(NSPoint(x: x + 2 + bw, y: y))
            maximizeButton.setFrameOrigin(NSPoint(x: x + 2 + bw + 2 + bw, y: y))
            
            addSubview(closeButton)
            addSubview(minimizeButton)
            addSubview(maximizeButton)
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
            
            let x = CGFloat(8)
            var y = b.size.height
            
            let buttonHeight = closeButton.bounds.size.height
            let buttonWidth = closeButton.bounds.size.width
            y = y - buttonHeight - 5
            
            if self.justClose == true {
                buttonsRect.origin = CGPoint(x: x, y: y)
                buttonsRect.size = NSMakeSize(buttonWidth, buttonHeight + 3)
            } else {
                buttonsRect.origin = CGPoint(x: x, y: y - buttonHeight - 3 - buttonHeight - 3)
                buttonsRect.size = NSMakeSize(buttonWidth, buttonHeight + 3 + buttonHeight + 3 + buttonHeight)
            }

            closeButton.setFrameOrigin(CGPoint(x: x, y: y))
            minimizeButton.setFrameOrigin(CGPoint(x: x, y: y - buttonHeight - 3))
            maximizeButton.setFrameOrigin(CGPoint(x: x, y: y - buttonHeight - 3 - buttonHeight - 3))

        } else {

            let x = CGFloat(8)
            var y = b.size.height
            
            let buttonHeight = closeButton.bounds.size.height
            let buttonWidth = closeButton.bounds.size.width
            y = y - buttonHeight - 5

            if self.justClose == true {
                buttonsRect.origin = CGPoint(x: x, y: y)
                buttonsRect.size = NSMakeSize(buttonWidth + 2, buttonHeight)
            } else {
                buttonsRect.origin = CGPoint(x: x, y: y)
                buttonsRect.size = NSMakeSize(buttonWidth + 2 + buttonWidth + buttonWidth, buttonHeight)
            }
            
            closeButton.setFrameOrigin(CGPoint(x: x, y: y))
            minimizeButton.setFrameOrigin(CGPoint(x: x + 2 + buttonWidth, y: y))
            maximizeButton.setFrameOrigin(CGPoint(x: x + 2 + buttonWidth + 2 + buttonWidth, y: y))
        }
        
        print( buttonsRect )
    
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
    
    override func draw(_ dirtyRect: NSRect) {
        
        NSGraphicsContext.saveGraphicsState()
        
        var lowerBounds = bounds
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
        
        if isVerticalButtons == true && hiddenButtons == false && justClose == false {
            
            let sepLine = NSBezierPath()
            var origin = bounds.origin
            origin.x += 29
            sepLine.move(to: origin)
            origin.y += bounds.size.height
            sepLine.line(to: origin)
            sepLine.lineWidth = 0.4
            sepLine.stroke()
        }
        
//        NSColor.red.set()
//        __NSFrameRect(trackingArea!.rect)

        NSGraphicsContext.restoreGraphicsState()
    }
    
}
