//
//  MLHoverButton.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 24/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

final class MLHoverButton: NSButton {
    
    var backgroundColor = NSColor.clear
    @objc var hoveredBackgroundColor  = NSColor.selectedTextBackgroundColor
    @objc var foregroundColor: NSColor = NSColor.blue
    var _hoveredForegroundColor = NSColor.blue
    
    var circleBorder: CGFloat = 0.0
    var drawsOn = false
    
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
        hoveredForegroundColor = .white
        hoveredBackgroundColor = .selectedTextBackgroundColor
        backgroundColor = .clear
        foregroundColor = .controlTextColor
        circleBorder = 8
        drawsOn = false
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
    
    @objc var hoveredForegroundColor : NSColor  {
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
            
            let imageRect = NSRect(origin: CGPoint.zero, size: image!.size)
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
            .foregroundColor: foregroundColor
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
        var circleRect: NSRect = bounds
        
        if circleRect.size.width > circleRect.size.height {
            circleRect.size.width = circleRect.size.height
        } else if circleRect.size.width < circleRect.size.height {
            let originalH: CGFloat = circleRect.size.height
            circleRect.size.height = circleRect.size.width
            circleRect.origin.y = (originalH - circleRect.size.height) / 2.0
        }
        
        var textRect = bounds
        textRect.origin.x += circleRect.size.width + 4
        textRect.size.width -= circleRect.size.width + 4
        
        var bg = backgroundColor
        var fc: NSColor? = nil
        isOn = hoovered && isHighlighted == false  // || (self.state == NSOnState);
        if drawsOn && (state == .on) {
            isOn = true
        }
        if isOn {
            bg = hoveredBackgroundColor
            fc = hoveredForegroundColor
        } else {
            bg = backgroundColor
            fc = foregroundColor
        }
        
        let bgPath = NSBezierPath(ovalIn: circleRect)
        bg.set()
        bgPath.fill()
        
        if (image != nil) {
            
            let targetRect = circleRect.insetBy(dx: circleBorder, dy: circleBorder)
            var i: NSImage? = nil
            
            if isOn {
                i = tintedImage
            } else {
                i = image
            }
            
            var imageRect = NSRect.zero
            var width = i?.size.width
            var height = i?.size.height
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
            
            i?.draw(in: imageRect)
            drawText(title, in: textRect, with: fc!)
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
                .foregroundColor: fc!
            ]
            
            let size = (sign?.size(withAttributes: attrs))!
            
            let r = NSRect(x: circleRect.origin.x,
                           y: circleRect.origin.y + ((circleRect.size.height - size.height) / 2.0) - 2,
                           width: circleRect.size.width,
                           height: size.height)
            
            sign?.draw(in: r, withAttributes: attrs)
            drawText(text!, in: textRect, with: fc!)
            
        }
        NSGraphicsContext.restoreGraphicsState()
    }
    
}

// https://stackoverflow.com/questions/45562662/how-can-i-use-string-slicing-subscripts-in-swift-4
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
//    let newStr = str.substring(from: index) // Swift 3
//    let newStr = String(str[index...]) // Swift 4
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
//    let newStr = str.substring(to: index) // Swift 3
//    let newStr = String(str[..<index]) // Swift 4
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
//    let range = firstIndex..<secondIndex // If you have a range
//    let newStr = = str.substring(with: range) // Swift 3
//    let newStr = String(str[range])  // Swift 4
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        let range = startIndex..<endIndex
        return String(self[range]) 
    }
}


