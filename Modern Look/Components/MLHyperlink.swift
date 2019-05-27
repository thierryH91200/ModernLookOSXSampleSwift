//
//  MLHyperlink.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 27/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLHyperlink: NSTextField {
    
    var hoveredTextColor: NSColor?
    var hasUnderline = false
    
    var trackingArea: NSTrackingArea?
    var hoovered = false
    
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        let fnt: NSFont? = font
        let regular = NSFont.systemFont(ofSize: 0)
        var restoreFont = false
        if regular != font {
            restoreFont = true
        }
        commonInit()
        if restoreFont {
            font = fnt
        }
    }
    
    override init(frame frameRect: NSRect) {
        
        
        
        super.init(frame: frameRect)
        commonInit()
    }
    
    override func viewDidEndLiveResize() {
        createTrackingArea()
    }
    
    func commonInit() {
        
        font = NSFont(name: "Helvetica Neue Thin", size: 16.0)
        isBordered = false
        focusRingType = .none
        createTrackingArea()
        hoovered = false
        hoveredTextColor = NSColor.blue
        backgroundColor = NSColor.clear
    }
    
    func createTrackingArea() {
        
        if trackingArea != nil {
            if let trackingArea = trackingArea {
                removeTrackingArea(trackingArea)
            }
        }
        trackingArea = NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeInActiveApp], owner: self, userInfo: nil)
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
    
    override func mouseDown(with theEvent: NSEvent) {
        
        
        sendAction(action, to: target)
        
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        NSGraphicsContext.saveGraphicsState()
        
        let bounds: NSRect = self.bounds
        var drawColor = NSColor.clear
        
        if hoovered == true {
            drawColor = hoveredTextColor!
        } else {
            if stringValue != "" {
                drawColor = textColor!
            } else {
                drawColor = NSColor.tertiaryLabelColor
            }
        }
        
        var text = ""
        if stringValue != ""  {
            text = stringValue
        } else {
            text = placeholderString ?? ""
        }
        
        let aParagraphStyle = NSMutableParagraphStyle()
        aParagraphStyle.lineBreakMode = .byWordWrapping
        aParagraphStyle.alignment = alignment
        let attrs : [ NSAttributedString.Key :Any ] = [
            .paragraphStyle: aParagraphStyle,
            .font: font!,
            .foregroundColor: drawColor
        ]
        
        text.draw(in: bounds, withAttributes: attrs)
        
        if self.hasUnderline {
            
            let bounds: NSRect = bounds
            textColor?.set()
            
            let bottomLine = NSBezierPath()
            var p = NSPoint.zero //bounds.origin;
            p.y = bounds.size.height
            bottomLine.move(to: p)
            p.x += bounds.size.width
            bottomLine.line(to: p)
            bottomLine.stroke()
            
            
        } else if self.hoovered {
            let size: NSSize = text.size(withAttributes: attrs)
            
            var x1: CGFloat = 0.0
            var x2: CGFloat = 0.0
            
            
            switch alignment {
            case .natural, .justified, .left:
                x1 = 0
                x2 = size.width
            case .right:
                x2 = bounds.size.width
                x1 = x2 - size.width
            case .center:
                x1 = (bounds.size.width - size.width) / 2.0
                x2 = x1 + size.width
            default:
                break
            }
            
            let bottomLine = NSBezierPath()
            var p = NSPoint.zero //bounds.origin;
            p.y = bounds.size.height
            p.x = x1
            bottomLine.move(to: p)
            p.x = x2
            bottomLine.line(to: p)
            bottomLine.stroke()
            
        }
        
        NSGraphicsContext.restoreGraphicsState()
        
    }
}
