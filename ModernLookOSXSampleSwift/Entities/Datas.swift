//
//  Datas.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 26/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import Foundation

struct Stack<Element> {
    fileprivate var array: [Element] = []
    
    mutating func push(_ element: Element) {
        array.append(element)
    }
    
    mutating func pop() -> Element? {
        return array.popLast()
    }
    
    mutating func get(_ num : Int) -> Element? {
        return array[ num ]
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

class PBAccount :  PBEntity {
    
    var name = "name"
    var budgeted = true
    var budget: PBBudget?
    
    override init () {
    }
    
    init(name: String = "name", budgeted: Bool = true)
    {
        self.name = name
        self.budgeted  = budgeted
    }
    
}

class PBBudget : NSObject {
    
    @objc var name = "name"
    var budgeted = true
    
    var accounts: [PBAccount] = []
    var payees: [PBPayee] = []
    @objc var categories: [PBCategory] = []
    
    
    override init () {
    }
    
    init(name: String = "name", budgeted: Bool = true)
    {
        self.name = name
        self.budgeted  = budgeted
    }
}

class PBPayee :  PBEntity {
    var budget: PBBudget?
    var name = ""
    var categories: [PBCategory] = []
}

class PBCategory: PBEntity {
    var budget: PBBudget?
    var parent: PBCategory? = nil
    @objc var subCategories: [PBCategory] = []
    @objc var name = ""
    var seq: NSNumber?
    
    override init() {
        super.init()
    }
    
    init(name: String) {
        self.name = name
    }
    
    func isLeaf() -> Bool {
        return subCategories.isEmpty
    }
    
    
}

class PBEntity: NSObject {
    var uid = ""
}
