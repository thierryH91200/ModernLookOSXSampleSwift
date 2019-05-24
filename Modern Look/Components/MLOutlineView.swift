//
//  MLOutlineView.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MLOutlineView: NSOutlineView {
    
    var savedTreeState: [Any] = []
    var oldVisibleRect = NSRect.zero
    var savedSortDescriptors: [NSSortDescriptor] = []
    var _selectionColor = NSColor.blue
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    func commonInit() {
        
        selectionColor = NSColor.blue
        savedTreeState = [Any]()
        oldVisibleRect = NSRect.zero
        
        enclosingScrollView?.borderType = .noBorder
        
        let chv = headerView
        chv?.frame = NSRect(x: 0, y: 0, width: 120, height: 24)
        for col in tableColumns {
            
            let headerCell = col.headerCell
            let cell = MLTableHeaderCell(textCell: headerCell.stringValue)
            
            cell.textColor = headerCell.textColor
            cell.backgroundColor = headerCell.backgroundColor
            cell.drawsBackground = headerCell.drawsBackground
            cell.font = headerCell.font
            cell.alignment = headerCell.alignment
            col.headerCell = cell
        }
    }
    
    func saveTreeState() {
        
        savedTreeState = [Any]()
        let sv = enclosingScrollView
        oldVisibleRect = (sv?.contentView.documentVisibleRect)!
        
        savedSortDescriptors = sortDescriptors
        
        let select = NSNumber(value: selectedRow)
        savedTreeState.append(select)
        
        for i in 0..<numberOfRows {
            let node = item(atRow: i) as? NSTreeNode
            let expanded: Bool = isItemExpanded(node)
            savedTreeState.append(NSNumber(value: expanded))
        }
    }
    
    func restoreTreeState() {
        sortDescriptors = savedSortDescriptors
        let sr = savedTreeState.first as? NSNumber
        for i in 1..<savedTreeState.count {
            let n = savedTreeState[i] as! NSNumber
            
            if n.boolValue == true {
                expandItem(item(atRow: i - 1))
            }
        }
        let selection = NSIndexSet(index: sr?.intValue ?? 0)
        selectRowIndexes(selection as IndexSet, byExtendingSelection: false)
        let sv = enclosingScrollView
        sv?.contentView.scroll(to: oldVisibleRect.origin)
    }
    
    @objc open var selectionColor: NSColor
        {
        get { return _selectionColor }
        set {
            _selectionColor = newValue
            selectionHighlightStyle = .none
        }
    }
    
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
    public func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        return MLTableRowView()
    }

}
