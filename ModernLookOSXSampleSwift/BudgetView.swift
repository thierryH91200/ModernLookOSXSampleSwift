//
//  BudgetView.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 24/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class BudgetView: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

struct Stack<Element> {
    fileprivate var array: [Element] = []
    
    mutating func push(_ element: Element) {
        array.append(element)
    }
    
    mutating func pop() -> Element? {
        return array.popLast()
    }
    
    func peek() -> Element? {
        return array.last
    }
    
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    var count: Int {
        return array.count
    }

}

struct Account {
    
    var name = "name"
    var budgeted = true
    
    init () {
    }
    
    init(name: String = "name", budgeted: Bool = true)
    {
        self.name = name
        self.budgeted  = budgeted
    }
    
}

struct PBBudget {
    
    var name = "name"
    var budgeted = true
    
    init () {
    }
    
    init(name: String = "name", budgeted: Bool = true)
    {
        self.name = name
        self.budgeted  = budgeted
    }
}

//struct PBCategory {
//    var budget: PBBudget?
//    var parent: PBCategory?
//    var subCategories: [AnyHashable] = []
//    var name = ""
//    var seq: NSNumber?
//}

