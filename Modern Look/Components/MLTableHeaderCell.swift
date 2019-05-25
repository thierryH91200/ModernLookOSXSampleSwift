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
        
        var textCell = cellFrame
        textCell.origin.x += 4
        textCell.size.width -= 8
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = alignment
        
        let attrs : [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font!,
            .foregroundColor: textColor!
        ]
        
        stringValue.draw(in: textCell, withAttributes: attrs as [NSAttributedString.Key : Any])
        
        NSColor.gridColor.set()
        let sepLine = NSBezierPath()
        var point = cellFrame.origin
        point.y = 8
        point.x += cellFrame.size.width
        sepLine.move(to: point)
        
        point.y += 10 //cellFrame.size.height - 16;
        
        sepLine.line(to: point)
        sepLine.stroke()
        
        NSColor.black.set()
        let bottomLine = NSBezierPath()
        point = cellFrame.origin
        point.y += cellFrame.size.height
        bottomLine.move(to: point)
        
        point.x += cellFrame.size.width
        bottomLine.line(to: point)
        bottomLine.stroke()
    }
}
