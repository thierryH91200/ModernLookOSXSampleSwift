//
//  MainWindowController.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MainWindowController: NSWindowController {
    
    var budgetView: BudgetView?
    var toolBar: ToolBar?
    
    var buttons = [NSView]()
    var budgets = [PBBudget]()
    
    @IBOutlet weak var pbToolBar: MLToolbar!
    @IBOutlet weak var pbContentView: MLContentView!
    @IBOutlet var win: MLMainWindow!
            
    override var windowNibName: NSNib.Name? {
        return "MainWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        self.toolBar = ToolBar()
        toolBar?.mainWindowController = self
        let vc1 = (self.toolBar?.view)!
        win.showToolBar( vc1)
        
        self.budgetView = BudgetView()
        let vc = (self.budgetView?.view)!
        win.showContent(vc)
        
//        let close = self.window?.standardWindowButton(NSWindow.ButtonType.closeButton)
//        let minimize = self.window?.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)
//        let maximize = self.window?.standardWindowButton(NSWindow.ButtonType.zoomButton)
//        
//        buttons.append(close!)
//        buttons.append(minimize!)
//        buttons.append(maximize!)
//        
//        var offsetX = 10
//        let contentView = self.win.contentView!
//        
//        buttons.forEach { (btn) in
//            btn.superview?.willRemoveSubview(btn)
//            btn.removeFromSuperview()
//            
//            btn.viewWillMove(toSuperview: contentView)
//            contentView.addSubview(btn)
//            btn.viewDidMoveToSuperview()
//        }
//        
//        buttons.forEach { (btn) in
//            btn.snp.makeConstraints({ (make) in
//                make.left.equalTo(contentView.snp.left).offset(10)
//                make.top.equalTo(contentView.snp.top).offset(offsetX)
//                make.height.equalTo(14)
//                make.width.equalTo(14)
//            })
//            offsetX += 22
//        }
//        contentView.layoutSubtreeIfNeeded()
//        contentView.superview!.viewDidEndLiveResize()

    }
}


