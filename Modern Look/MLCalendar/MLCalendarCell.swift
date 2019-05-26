//
//  MLCalendarCell.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 20/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

final class MLCalendarCell: NSButton {
    
    var owner: MLCalendarView?
    var representedDate: Date?
    var isSelected = false
    var col = -1
    var row = -1
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        isBordered = false
        representedDate = nil
    }
    
    func isToday() -> Bool {
        guard representedDate != nil else  { return false }
        return MLCalendarView.shared.isSameDate(representedDate, date: Date())
    }
    
    func setSelected(_ selected: Bool) {
        self.isSelected = selected
        needsDisplay = true
    }
    
    func setRepresentedDate(_ representedDate: Date?) {
        self.representedDate = representedDate
        guard self.representedDate != nil else  {
            self.title = ""
            return }
        
        var calendar = Calendar.current
        if let time = TimeZone(abbreviation: "UTC") {
            calendar.timeZone = time as TimeZone
        }
        let unitFlags: Set<Calendar.Component> = [.day]
        let components = calendar.dateComponents(unitFlags, from: self.representedDate!)
        let day = components.day!
        self.title = String(format: "%ld", day)

    }
    
    override func draw(_ dirtyRect: NSRect) {
                
//        guard self.owner != nil else { return }
        
        NSGraphicsContext.saveGraphicsState()
        
        
        let bounds = self.bounds
        owner!.backgroundColor.set()
        NSColor.white.set()
        bounds.fill()
        
        if representedDate != nil {
            //selection
            if isSelected == true {
                var circeRect = bounds.insetBy(dx: 3.5, dy: 3.5)
                circeRect.origin.y += 1
                let bzc = NSBezierPath(ovalIn: circeRect)
                owner?.selectionColor.set()
                bzc.fill()
            }
        } else {
            title = ""
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center

        //title
        let attrs : [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font!,
            .foregroundColor: owner?.textColor ?? .black
        ]

        let size = title.size(withAttributes: attrs)
        let r = NSRect(x: bounds.origin.x,
                       y: bounds.origin.y + ((bounds.size.height - size.height) / 2.0) - 1,
                       width: bounds.size.width,
                       height: size.height)

        self.title.draw(in: r, withAttributes: attrs)

        //line
        let topLine = NSBezierPath()
        topLine.move(to: NSPoint(x: bounds.minX, y: bounds.minY))
        topLine.line(to: NSPoint(x: bounds.maxX, y: bounds.minY))
        owner?.dayMarkerColor.set()
        topLine.lineWidth = 0.3
        topLine.stroke()
        if isToday() {
            owner?.todayMarkerColor.set()
            let bottomLine = NSBezierPath()
            bottomLine.move(to: NSPoint(x: bounds.minX, y: bounds.maxY))
            bottomLine.line(to: NSPoint(x: bounds.maxX, y: bounds.maxY))
            bottomLine.lineWidth = 4.0
            bottomLine.stroke()
        }
        
        NSGraphicsContext.restoreGraphicsState()
        
    }
    
    
}
