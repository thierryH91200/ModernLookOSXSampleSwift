//
//  PBEntityManager.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 25/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

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
        
        if let payees = currentBudget!.payees.first(where: { $0.uid == uid }) {
            return payees
        }
        return nil

    }
    
    func category(byUID uid: String?) -> PBCategory? {
        
        if let cat = currentBudget!.categories.first(where: { $0.uid == uid }) {
            return cat
        }
        return nil
    }
    
    func account(byUID uid: String?) -> PBAccount? {
        
        if let acc = currentBudget!.accounts.first(where: { $0.uid == uid }) {
            return acc
        }
        return nil

    }
    
    func saveSetup() {
    }
    
    
}
