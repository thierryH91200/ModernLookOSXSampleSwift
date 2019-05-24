//
//  MLTableView.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLTableView: NSTableView {
    
    var _selectionColor = NSColor.blue
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    func commonInit() {
        
        enclosingScrollView?.borderType = .noBorder
        let chv = headerView
        chv?.frame = NSRect(x: 0, y: 0, width: 120, height: 24)
        for col in tableColumns {
            col.headerCell = MLTableHeaderCell(textCell: col.headerCell.stringValue)
            
            let oc = col.headerCell as? MLTableHeaderCell
            let cell = MLTableHeaderCell(textCell: oc?.stringValue) //col.title];
            cell.textColor = oc?.textColor
            cell.backgroundColor = oc?.backgroundColor
            cell.drawsBackground = oc!.drawsBackground
            cell.font = oc?.font
            cell.alignment = oc!.alignment
            col.headerCell = cell
        }
    }
    
    @objc open var selectionColor: NSColor
        {
        get { return _selectionColor }
        set {
            _selectionColor = newValue
            selectionHighlightStyle = .none
        }
    }
    
    // cell based
    override func drawRow(_ row: Int, clipRect: NSRect) {
        var bgColor: NSColor? = nil
        if NSApplication.shared.isActive {
            bgColor = selectionColor
        } else {
            bgColor = NSColor(calibratedWhite: 0.800, alpha: 1.000)
        }
        
        let selectedRowIndexes = self.selectedRowIndexes as NSIndexSet
        if selectedRowIndexes.contains(row) {
            bgColor?.setFill()
            rect(ofRow: row).fill()
        }
        
        super.drawRow(row, clipRect: clipRect)
    }
    
    // view based
    public func tableView(_ tableView: NSTableView, rowViewForItem item: Any) -> NSTableRowView? {
        return MLTableRowView()
    }
    
}

// view based
final class MLTableRowView: NSTableRowView {
    override func drawSelection(in dirtyRect: NSRect) {
        if self.selectionHighlightStyle != .none {
            let selectionRect = NSInsetRect(self.bounds, 2.5, 2.5)
            let colorBack = NSColor.selectedControlColor
            colorBack.setStroke()
            colorBack.setFill()
            let selectionPath = NSBezierPath.init(roundedRect: selectionRect, xRadius: 6, yRadius: 6)
            selectionPath.fill()
            selectionPath.stroke()
        }
    }
    
}
