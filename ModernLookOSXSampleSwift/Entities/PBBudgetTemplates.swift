//
//  PBBudgetTemplates.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 25/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import Cocoa

class PBBudgetTemplates: NSObject {
    
    func createHomeBudget() -> PBBudget? {
        
        let ret = PBBudget()
        ret.name = "Home Budget"
        var c: PBCategory? = nil
        
        c = createCategory(withName: "Monthly Bills", andParent: nil)
        if let c = c {
            ret.categories.append(c)
        }
        createSubCategories(withName: [
            "Rent/Morgage",
            "Phone",
            "Internet",
            "Cable TV",
            "Electricity",
            "Water",
            "Natural Gas/Propane/Oil"
            ], forParent: c)
        
        c = createCategory(withName: "Insurances", andParent: nil)
        ret.categories.append(c!)
        createSubCategories(withName: ["Car Insurance", "Life Insurance", "Health Insurance"], forParent: c)
        
        c = createCategory(withName: "Pleasure", andParent: nil)
        ret.categories.append(c!)
        createSubCategories(withName: [
            "Coffee",
            "Shopaholic",
            "Restaurants",
            "iTunes Spendings",
            "App Store Spendings"
            ], forParent: c)
        
        c = createCategory(withName: "Everyday Expenses", andParent: nil)
        ret.categories.append(c!)
        createSubCategories(withName: [
            "Groceries",
            "Fuel",
            "Spending Money",
            "Medical",
            "Clothing",
            "Household Goods"
            ], forParent: c)
        
        c = createCategory(withName: "Saving Goals", andParent: nil)
        ret.categories.append(c!)
        createSubCategories(withName: ["Christmas Presents", "Birthdays", "Car Replacement", "Vacation"], forParent: c)
        
        c = createCategory(withName: "Debt", andParent: nil)
        ret.categories.append(c!)
        createSubCategories(withName: ["Car Payment", "Student Loan Payment", "Personal Loan Payment"], forParent: c)
        
        return ret
    }
    
    func createSmallOfficeBudget() -> PBBudget? {
        
        let ret = PBBudget()
        ret.name = "Office Budget"
        var c: PBCategory? = nil
        
        c = createCategory(withName: "Marketing", andParent: nil)
        ret.categories.append(c!)
        createSubCategories(withName: [
            "Printing",
            "AdWords",
            "Facebook",
            "Twitter",
            "Referral Fees",
            "Comissions"
            ], forParent: c)
        
        c = createCategory(withName: "Services", andParent: nil)
        ret.categories.append(c!)
        createSubCategories(withName: ["Accounting", "Legal", "Contractors"], forParent: c)
        
        c = createCategory(withName: "Office", andParent: nil)
        ret.categories.append(c!)
        createSubCategories(withName: ["Rent", "Telephone/Fax", "Internet", "Cleaning"], forParent: c)
        
        c = createCategory(withName: "Travel", andParent: nil)
        ret.categories.append(c!)
        createSubCategories(withName: ["Automobile", "Hotels/Lodging", "Airfare", "Other"], forParent: c)
        
        c = createCategory(withName: "Taxes & Licenses", andParent: nil)
        ret.categories.append(c!)
        createSubCategories(withName: ["Unemployment", "Payroll", "Quaterlies"], forParent: c)
        
        return ret
    }
    
    func createCategory(withName name: String, andParent parent: PBCategory?) -> PBCategory? {
        let ret = PBCategory()
        ret.name = name
        if parent != nil {
            ret.parent = parent
            parent?.subCategories.append(ret)
        }
        return ret
    }
    
    func createSubCategories(withName names: [String], forParent parent: PBCategory?) {
        for name in names {
            _ = createCategory(withName: name, andParent: parent)
        }
    }
    
}
