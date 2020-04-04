//
//  PBCategoryContent.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 25/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

@objc
class PBCategoryContent: MLPopupContent {
    
    @IBOutlet var budgetController: NSObjectController!
    @IBOutlet var categories: NSTreeController!
    @IBOutlet weak var tree: NSOutlineView!
    
    var disableSelectionNotification = false
    @objc var budget: PBBudget?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    convenience init(budget: PBBudget?) {
        
        self.init()
        
        self.budget = budget
        self.disableSelectionNotification = false
    }
    
    override func loadView() {
        super.loadView()
        tree.expandItem(nil, expandChildren: true)
        tree.delegate = self
    }
    
    func makeSelectionVisible() {
        let selRect = tree.rect(ofRow: tree.selectedRow)
        tree.scrollToVisible(selRect)
    }
    
    override func moveSelectionUp(_ up: Bool) {
        
        var i = tree.selectedRow
        if up {
            i -= 1
        } else {
            i += 1
        }
        let indexSet = NSIndexSet(index: i)
        tree.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
        makeSelectionVisible()
    }
    
    
    func child(byName name: String, children: [PBCategory], indexes: [Int]) -> Bool {
        
        var ret = false
        var indexes = indexes
        for i in 0..<children.count {
            let cat = children[i]
            indexes.append( i )
            if cat.name.hasPrefix(name) {
                ret = true
                break
            } else {
                ret = child(byName: name, children: cat.subCategories, indexes: indexes)
                if ret == false {
                    indexes.removeLast()
                } else {
                    break
                }
            }
        }
        return ret
    }
    
    override func moveSelection(to str: String?) -> String? {

        disableSelectionNotification = true
        let indexes: [Int] = []
        if child(byName: str!, children: budget!.categories, indexes: indexes) {
            
            var selection: IndexPath? = nil
            
            for n in indexes  {
                if selection != nil {
                    selection = selection?.appending(n)
                } else {
                    selection = IndexPath(index: n)
                }
            }
            categories.setSelectionIndexPath( selection )
            let sa = categories.selectedObjects
            let category = sa.first as? PBCategory
            let name = category?.name
            disableSelectionNotification = false
            return name
        }
        
        disableSelectionNotification = false
        makeSelectionVisible()
        return nil //i != self.tree.selectedRow;
    }
}

extension  PBCategoryContent : NSOutlineViewDelegate {
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        
        if disableSelectionNotification == false {
            let sa = categories.selectedObjects
            delegate?.selectionDidChange(sa.first, fromUpDown: true)
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool {
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldShowCellExpansionFor tableColumn: NSTableColumn?, item: Any) -> Bool {
        return false
    }

}
