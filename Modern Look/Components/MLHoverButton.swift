//
//  MLHoverButton.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 24/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

final class MLHoverButton: NSButton {
    
    var backgroundColor: NSColor?
    var hoveredBackgroundColor: NSColor?
    var foregroundColor: NSColor = NSColor.blue
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
        wantsLayer = true
        createTrackingArea()
        hoovered = false
        hoveredForegroundColor = NSColor.white
        hoveredBackgroundColor = NSColor.selectedTextBackgroundColor
        backgroundColor = NSColor.clear
        foregroundColor = NSColor.controlTextColor
        circleBorder = 8
        drawsOn = false
    }
    
    override func viewDidEndLiveResize() {
        createTrackingArea()
    }
    
    func createTrackingArea() {
        if trackingArea != nil {
            if let trackingArea = trackingArea {
                removeTrackingArea(trackingArea)
            }
        }
        let circleRect: NSRect = bounds
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
            
            let imageRect = NSRect(origin: NSPoint.zero, size: image!.size)
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
            //        CGFloat originalW = circleRect.size.width;
            circleRect.size.width = circleRect.size.height
            //        circleRect.origin.x = ((originalW - circleRect.size.width)/2.0);
        } else if circleRect.size.width < circleRect.size.height {
            let originalH: CGFloat = circleRect.size.height
            circleRect.size.height = circleRect.size.width
            circleRect.origin.y = (originalH - circleRect.size.height) / 2.0
        }
        
        var textRect: NSRect = bounds
textRect.origin.x += circleRect.size.width + 4
textRect.size.width -= circleRect.size.width + 4

var bg = backgroundColor
var fc: NSColor? = nil
isOn = hoovered && !isHighlighted // || (self.state == NSOnState);
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
bg?.set()
bgPath.fill()

        //    if(self.image) {
        //
        //    NSRect targetRect = NSInsetRect(circleRect, self.circleBorder, self.circleBorder);
        //
        //    NSImage* i = nil;
        //
        //    if(isOn) {
        //    i = self.tintedImage;
        //    } else {
        //    i = self.image;
        //    }
        //
        //    NSRect imageRect = NSZeroRect;
        //    CGFloat w = i.size.width;
        //    CGFloat h = i.size.height;
        //    if(w > targetRect.size.width) w = targetRect.size.width;
        //    if(h > targetRect.size.height) h = targetRect.size.height;
        //    imageRect.size.width = w;
        //    imageRect.size.height = h;
        //
        //    imageRect.origin.x = (circleRect.size.width - imageRect.size.width)/2.0f;
        //    imageRect.origin.y = (circleRect.size.height - imageRect.size.height)/2.0f;
        //
        //    [i drawInRect:imageRect];
        //    [self drawText:self.title inRect:textRect withColor:fc];
        //
        //    } else {
        //    NSString* sign = nil;
        //    NSString* text = nil;
        //    NSArray* components = [self.title componentsSeparatedByString:@"|"];
        //    if(components.count == 2) {
        //    sign = components[0];
        //    text = components[1];
        //    } else {
        //    sign = [self.title substringToIndex:1];
        //    text = [self.title substringFromIndex:1];
        //    }
        //    NSMutableParagraphStyle * aParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        //    [aParagraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        //    [aParagraphStyle setAlignment:NSCenterTextAlignment];
        //
        //    NSDictionary *attrs = @{NSParagraphStyleAttributeName: aParagraphStyle,NSFontAttributeName: self.font,NSForegroundColorAttributeName: fc};
        //
        //    NSSize size = [sign sizeWithAttributes:attrs];
        //
        //    NSRect r = NSMakeRect(circleRect.origin.x,// + (bounds.size.width - size.width)/2.0,
        //    circleRect.origin.y + ((circleRect.size.height - size.height)/2.0) - 2,
        //    circleRect.size.width,
        //    size.height);
        //
        //    [sign drawInRect:r withAttributes:attrs];
        //    [self drawText:text inRect:textRect withColor:fc];
        //    }
        //    [NSGraphicsContext restoreGraphicsState];
        //    }
        
    }
}
