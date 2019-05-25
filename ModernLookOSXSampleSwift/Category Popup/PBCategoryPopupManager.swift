//
//  PBCategoryPopupManager.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 25/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import Cocoa

class PBCategoryPopupManager: MLComboFieldDelegate {
    
    @IBOutlet weak var budgets: NSArrayController!
    dynamic var budget = [PBBudget]()


    override func createPopupContent() -> MLPopupContent? {
        
        budget = PBEntityManager.shared.loadBudgets()
        budgets.content = budget

        let pbBudget = budgets.arrangedObjects as! [PBBudget]
        let b = pbBudget[budgets.selectionIndex]

        let c = PBCategoryContent(budget: b)
        return c
    }

}
