//
//  MLCheckbox.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 22/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLCheckbox: NSButton {
    
    var backgroundColor = NSColor.textBackgroundColor
    
    var _hoveredBackgroundColor = NSColor.windowBackgroundColor
    var hoveredBackgroundColor : NSColor {
        get { return _hoveredBackgroundColor }
        set { _hoveredBackgroundColor = newValue}
    }
    
    var foregroundColor = NSColor.controlAccentColor
    var _hoveredForegroundColor = NSColor.orange
    var circleBorder: CGFloat = 0.0
    var onImage: NSImage?
    
    var trackingArea: NSTrackingArea?
    var hoovered = false
    var justTurnedOff = false
    var tintedImage: NSImage?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    override func viewDidEndLiveResize() {
        createTrackingArea()
    }
    
    func commonInit() {

        createTrackingArea()
        justTurnedOff = false
        hoovered = false
        
        hoveredForegroundColor = .controlAccentColor
        hoveredBackgroundColor = .orange
        backgroundColor = .windowBackgroundColor
        foregroundColor = .labelColor
        circleBorder = 0.0
    }
    
    func createTrackingArea() {
        if trackingArea != nil {
            if let trackingArea = trackingArea {
                removeTrackingArea(trackingArea)
            }
        }
        let circleRect = bounds
        trackingArea = NSTrackingArea(rect: circleRect, options: [.mouseEnteredAndExited, .activeInActiveApp], owner: self, userInfo: nil)
        if let trackingArea = trackingArea {
            addTrackingArea(trackingArea)
        }
    }
    
    override func mouseEntered(with theEvent: NSEvent) {
        hoovered = true
        justTurnedOff = false
        needsDisplay = true
    }
    
    override func mouseExited(with theEvent: NSEvent) {
        hoovered = false
        justTurnedOff = false
        needsDisplay = true
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        super.mouseDown(with: theEvent)
        if hoovered == true {
            justTurnedOff = state == .off
        }
    }
    
    var hoveredForegroundColor : NSColor  {
        get { return _hoveredForegroundColor }
        set {
            _hoveredForegroundColor = newValue
            if (image != nil) {
                tintedImage = imageTinted(with: hoveredForegroundColor)
            }
        }
    }
    
    override var image : NSImage?  {
        get { return super.image }
        set {
            if newValue != nil {
                self.tintedImage = imageTinted(with: hoveredForegroundColor)
            } else {
                self.tintedImage = nil
            }
        }
    }
    
    func imageTinted(with tint: NSColor?) -> NSImage? {
        let image = self.image
        if tint != nil {
            image?.lockFocus()
            tint?.set()
            
            let imageRect = CGRect(origin: CGPoint.zero, size: image!.size)
            __NSRectFillUsingOperation(imageRect, .sourceAtop)
            image?.unlockFocus()
        }
        return image
    }
    
    func drawText(_ text: String, in rect: NSRect, with foregroundColor: NSColor) {
        
        let bgPath = NSBezierPath(rect: rect)
        NSColor.white.set()
        bgPath.fill()

        let aParagraphStyle = NSMutableParagraphStyle()
        aParagraphStyle.lineBreakMode = .byWordWrapping
        aParagraphStyle.alignment = alignment
        
        let attrs: [NSAttributedString.Key : Any] = [
                .paragraphStyle: aParagraphStyle,
                .font: font!,
                .foregroundColor: foregroundColor,
                .backgroundColor : backgroundColor

            ]
        var size = text.size(withAttributes: attrs)
        size.height = 17.0
        
        let r = CGRect(x: rect.origin.x,
                       y: rect.origin.y + ((rect.size.height - size.height) / 2.0) - 2,
                       width: rect.size.width,
                       height: size.height)
        text.draw(in: r, withAttributes: attrs)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        var isOn = false
        
        NSGraphicsContext.saveGraphicsState()
        
        let bgPath1 = NSBezierPath(ovalIn: bounds)
        NSColor.windowBackgroundColor.set()
        bgPath1.fill()
        
        var circleRect = bounds
        
        if circleRect.size.width > circleRect.size.height {
            circleRect.size.width = circleRect.size.height
        } else if circleRect.size.width < circleRect.size.height {
            let originalH = circleRect.size.height
            circleRect.size.height = circleRect.size.width
            circleRect.origin.y = (originalH - circleRect.size.height) / 2.0
        }
        
        var bg = backgroundColor
        var fc = foregroundColor
        
        isOn = (hoovered && isHighlighted == false) || (state == .on)
        if justTurnedOff == true {
            isOn = false
        }
        if isOn == true {
            bg = hoveredBackgroundColor
            fc = hoveredForegroundColor
        }
        
        let bgPath = NSBezierPath(ovalIn: circleRect)
        
        NSColor.textBackgroundColor.set()
        bgPath.fill()
        
        bg.set()
        bgPath.fill()

        var im: NSImage? = nil
        if isOn == true {
            im = onImage != nil ? onImage : tintedImage
        } else {
            im = image
        }
        
        let targetRect = circleRect.insetBy(dx: circleBorder, dy: circleBorder)
        
        var imageRect = NSRect.zero
        var width = (im?.size.width)!
        var height = (im?.size.height)!
        if width > targetRect.size.width {
            width = targetRect.size.width
        }
        if height > targetRect.size.height {
            height = targetRect.size.height
        }
        imageRect.size.width = width
        imageRect.size.height = height
        
        imageRect.origin.x = (circleRect.size.width - imageRect.size.width) / 2.0
        imageRect.origin.y = (circleRect.size.height - imageRect.size.height) / 2.0
        
        im?.draw(in: imageRect)
        
        var textRect = bounds
        textRect.origin.x += circleRect.size.width + 4
        textRect.size.width -= circleRect.size.width + 4

        drawText(title, in: textRect, with: fc)
        
        NSGraphicsContext.restoreGraphicsState()
    }
}
