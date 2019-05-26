//
//  SettingsView.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 24/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class SettingsView: NSViewController {
    
    dynamic var budgets = [PBBudget]()
    @IBOutlet var arrayController: NSArrayController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        budgets = PBEntityManager.shared.loadBudgets()
        arrayController.content = budgets
    }
}

class PBBudgetArrayController : NSArrayController {
    
    override func add(_ sender: Any?) {
        let b = PBBudget()
        b.name = "New Budget"
        self.add(b)
        PBEntityManager.shared.budgets.append(b)
    }
}
