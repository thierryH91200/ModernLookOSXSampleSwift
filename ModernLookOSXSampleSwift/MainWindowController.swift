//
//  MainWindowController.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MainWindowController: NSWindowController {
    
    
    var settingsView: SettingsView?
    var accountsView: AccountsView?
    var budgetView: BudgetView?
    var predictionView: PredicitionView?
    var toolBar: ToolBar?
    
    var budgets = [PBBudget]()
    
    @IBOutlet weak var pbToolBar: MLToolbar!
    @IBOutlet weak var pbContentView: MLContentView!
    
    @IBOutlet var win: MLMainWindow!
        
    let mlAlert = MLAlert()
    
    override var windowNibName: NSNib.Name? {
        return "MainWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
        self.toolBar = ToolBar()
        let vc1 = (self.toolBar?.view)!
        win.showToolBar( vc1)
        
        self.budgetView = BudgetView()
        let vc = (self.budgetView?.view)!
        win.showContent(vc)
    }
}


