//
//  MLTableHeaderCell.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLTableHeaderCell: NSTableHeaderCell {
    override init(textCell aString: String?) {
        super.init(textCell: aString!)
        controlTint = .clearControlTint
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView?) {
        
        //    [self.backgroundColor set];
        NSColor.white.set()
        cellFrame.fill()
        
        var textCell: NSRect = cellFrame
        textCell.origin.x += 4
        textCell.size.width -= 8
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = alignment
        
        let attrs = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        
        stringValue.draw(in: textCell, withAttributes: attrs as [NSAttributedString.Key : Any])
        
        NSColor.gridColor.set()
        let sepLine = NSBezierPath()
        var p: NSPoint = cellFrame.origin
        p.y = 8
        p.x += cellFrame.size.width
        sepLine.move(to: p)
        
        p.y += 10 //cellFrame.size.height - 16;
        
        sepLine.line(to: p)
        sepLine.stroke()
        
        NSColor.black.set()
        let bottomLine = NSBezierPath()
        p = cellFrame.origin
        p.y += cellFrame.size.height
        bottomLine.move(to: p)
        
        p.x += cellFrame.size.width
        bottomLine.line(to: p)
        bottomLine.stroke()
    }
}
