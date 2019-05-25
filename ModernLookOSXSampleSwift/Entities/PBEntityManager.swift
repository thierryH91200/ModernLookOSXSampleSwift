//
//  PBEntityManager.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 25/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import Cocoa

class PBEntityManager: NSObject {
    
    var currentBudget: PBBudget?
    var budgets: [PBBudget] = []
    
    static let shared = PBEntityManager()
    
    
    //instance as? PBEntityManager
    //do {
    //    if !entityManager {
    //        entityManager = PBEntityManager()
    //        entityManager.loadBudgets()
    //    }
    //    return entityManager
    //}
    
    override init() {
        super.init()
        budgets = [PBBudget]()
    }
    
    func loadBudgets() -> [PBBudget] {
        let bt = PBBudgetTemplates()
        budgets.append(bt.createHomeBudget()!)
        budgets.append(bt.createSmallOfficeBudget()!)
        return budgets
    }
    
    func cleanup() {
    }
    
    func payee(byUID uid: String) -> PBPayee? {
        var ret: PBPayee? = nil
        for p in currentBudget!.payees {
            if (p.uid == uid) {
                ret = p
                break
            }
        }
        return ret
    }
    
    func category(byUID uid: String?) -> PBCategory? {
        var ret: PBCategory? = nil
        for c in currentBudget!.categories {
            if (c.uid == uid) {
                ret = c
                break
            }
        }
        return ret
    }
    
    func account(byUID uid: String?) -> PBAccount? {
        var ret: PBAccount? = nil
        for a in currentBudget!.accounts {
            if (a.uid == uid) {
                ret = a
                break
            }
        }
        return ret
    }
    
    func saveSetup() {
    }
    
    
}
