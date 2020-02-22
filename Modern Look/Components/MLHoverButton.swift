//
//  MLHoverButton.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 24/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLHoverButton: NSButton {
    
    var backgroundColor              = NSColor.windowBackgroundColor
    @objc var foregroundColor        = NSColor.labelColor

    @objc var hoveredBackgroundColor = NSColor.selectedTextBackgroundColor

    var _hoveredForegroundColor      = NSColor.selectedTextBackgroundColor
    @objc var hoveredForegroundColor : NSColor  {
        get { return _hoveredForegroundColor }
        set {
            _hoveredForegroundColor = newValue
            
            if (image != nil) {
                tintedImage = imageTinted(with: hoveredForegroundColor)
            }
        }
    }

    var circleBorder: CGFloat = 8.0
    var isDrawsOn = false
    
    var trackingArea: NSTrackingArea?
    var hoovered = false
    var tintedImage: NSImage?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    func commonInit() {

        createTrackingArea()
        hoovered = false
        hoveredForegroundColor = .unemphasizedSelectedTextColor
        hoveredBackgroundColor = .unemphasizedSelectedTextBackgroundColor
        backgroundColor = .windowBackgroundColor
        foregroundColor = .labelColor
        circleBorder = 8
        isDrawsOn = false
    }
    
    override func viewDidEndLiveResize() {
        createTrackingArea()
    }
    
    func createTrackingArea() {
        if trackingArea != nil {
            removeTrackingArea(trackingArea!)
        }
        
        let circleRect = bounds
        trackingArea = NSTrackingArea(rect: circleRect, options: [.mouseEnteredAndExited, .activeInActiveApp], owner: self, userInfo: nil)
        if let trackingArea = trackingArea {
            addTrackingArea(trackingArea)
        }
        
    }
    
    override func mouseEntered(with theEvent: NSEvent) {
        hoovered = true
        needsDisplay = true
    }
    
    override func mouseExited(with theEvent: NSEvent) {
        hoovered = false
        needsDisplay = true
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
            
            let imageRect = NSRect(origin: CGPoint.zero, size: image!.size)
            __NSRectFillUsingOperation(imageRect, .sourceAtop)
            image?.unlockFocus()
        }
        return image
    }
    
    
    func drawText(_ text: String, in rect: NSRect, with foregroundColor: NSColor) {
        
        let bgPath = NSBezierPath(rect: rect)
        NSColor.textBackgroundColor.set()
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
        
        let r = NSRect(x: rect.origin.x,
                       y: rect.origin.y + ((rect.size.height - size.height) / 2.0) - 2,
                       width: rect.size.width,
                       height: size.height)
        text.draw(in: r, withAttributes: attrs)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        var isOn = false
        NSGraphicsContext.saveGraphicsState()

        var circleRect = bounds
        if circleRect.size.width > circleRect.size.height {
            circleRect.size.width = circleRect.size.height
        } else if circleRect.size.width < circleRect.size.height {
            let originalH = circleRect.size.height
            circleRect.size.height = circleRect.size.width
            circleRect.origin.y = (originalH - circleRect.size.height) / 2.0
        }
        
        var textRect = bounds
        textRect.origin.x += circleRect.size.width + 4
        textRect.size.width -= circleRect.size.width + 4
        
        var backGroundColor = backgroundColor
        var foregroundcolor: NSColor? = nil
        isOn = hoovered && isHighlighted == false  || (self.state == .on)
        if isDrawsOn == true && (state == .on) {
            isOn = true
        }
        if isOn == true {
            backGroundColor = hoveredBackgroundColor
            foregroundcolor = hoveredForegroundColor
        } else {
            backGroundColor = backgroundColor
            foregroundcolor = foregroundColor
        }
        
        let bgPath = NSBezierPath(ovalIn: circleRect)
        backGroundColor.set()
        bgPath.fill()
        
        if (image != nil) {
            
            let targetRect = circleRect.insetBy(dx: circleBorder, dy: circleBorder)
            var ima: NSImage? = nil
            
            if isOn == true {
                ima = tintedImage
            } else {
                ima = image
            }
            
            var imageRect = NSRect.zero
            var width = ima?.size.width
            var height = ima?.size.height
            if (width ?? 0.0) > targetRect.size.width {
                width = targetRect.size.width
            }
            if height! > targetRect.size.height {
                height = targetRect.size.height
            }
            imageRect.size.width = width!
            imageRect.size.height = height!
            
            imageRect.origin.x = (circleRect.size.width - imageRect.size.width) / 2.0
            imageRect.origin.y = (circleRect.size.height - imageRect.size.height) / 2.0
            
            ima?.draw(in: imageRect)
            drawText(title, in: textRect, with: foregroundcolor!)
        }
            
        else {
            var sign: String? = nil
            var text: String? = nil
            let components = title.components(separatedBy: "|")
            if components.count == 2 {
                sign = components[0]
                text = components[1]
            } else {
                sign = title.substring(to: 1)
                text = title.substring(from: 1)
            }
            
            let aParagraphStyle = NSMutableParagraphStyle()
            aParagraphStyle.lineBreakMode = .byWordWrapping
            aParagraphStyle.alignment = .center
            
            let attrs : [NSAttributedString.Key : Any ] = [
                .paragraphStyle: aParagraphStyle,
                .font: font!,
                .foregroundColor: foregroundcolor!,
                .backgroundColor : backgroundColor
            ]
            
            let size = (sign?.size(withAttributes: attrs))!
            
            let r = NSRect(x: circleRect.origin.x,
                           y: circleRect.origin.y + ((circleRect.size.height - size.height) / 2.0) - 2,
                           width: circleRect.size.width,
                           height: size.height)
            
            sign?.draw(in: r, withAttributes: attrs)
            print(text!, "without image")
            drawText(text!, in: textRect, with: foregroundcolor!)
        }
        NSGraphicsContext.restoreGraphicsState()
    }
    
}

// https://stackoverflow.com/questions/45562662/how-can-i-use-string-slicing-subscripts-in-swift-4
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        let range = startIndex..<endIndex
        return String(self[range]) 
    }
}


