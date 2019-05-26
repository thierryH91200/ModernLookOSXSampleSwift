//
//  MainWindowController.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 21/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class MainWindowController: NSWindowController , MLCalendarViewDelegate{
    
    //@IBOutlet weak var settingsView: MLContentView!
    @IBOutlet weak var mlRadioGroupManager: MLRadioGroupManager!
    
    
    var settingsView: SettingsView?
    var accountsView: AccountsView?
    var budgetView: BudgetView?
    var predictionView: PredicitionView?
    
    var budgets = [PBBudget]()
    
    
    @IBOutlet weak var pbContentView: MLContentView!
    
    var calendarPopover: NSPopover?
    @IBOutlet var win: MLMainWindow!
    
    @IBOutlet weak var comboBox: NSComboBox!
    @IBOutlet weak var popUp: NSPopUpButton!
    @IBOutlet weak var combo: MLComboField!
    
    let mlAlert = MLAlert()
    
    override var windowNibName: NSNib.Name? {
        return "MainWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
//        budgets = PBEntityManager.shared.loadBudgets()
//        if PBEntityManager.shared.budgets.count > 0 {
//            budgets.setSelectionIndex(0)
//        }
        
        
        self.budgetView = BudgetView()
        let vc = (self.budgetView?.view)!
        
        win.showContent(vc)
    }
    
    func createCalendarPopover() {
        
        var myPopover = calendarPopover
        if myPopover == nil {
            myPopover = NSPopover()
            let cp = MLCalendarView()
            cp.delegate = self
            myPopover?.contentViewController = cp
            myPopover?.appearance = NSAppearance(named: .aqua) //]LightContent];
            myPopover?.animates = true
            myPopover?.behavior = .transient
            //        myPopover.delegate = self;
        }
        calendarPopover = myPopover
    }
    
    @IBAction func showCalendar(_ sender: Any) {
        createCalendarPopover()
        let btn = sender as? NSButton
        let cellRect = btn?.bounds
        if let btn = btn {
            calendarPopover?.show(relativeTo: cellRect ?? NSRect.zero, of: btn, preferredEdge: .maxY)
        }
    }
    
    @IBAction func showAlert(_ sender: Any) {
        
        let res = mlAlert.showQuestion("question", title: "hello", withCancel: true)
        switch res {
        case .yes:
            break
        case .no:
            break
        case .cancel:
            break
        }
        
    }
    
    func didSelectDate(_ selectedDate: Date?) {
        calendarPopover?.close()
    }
    
    @IBAction func pageSelectionChanged(_ sender: MLRadioGroupManager) {
        
        var  vc = NSView()
        
        switch sender.selectedItem {
        case 1:
            print("settingsView" )
            self.settingsView = SettingsView()
            vc = (self.settingsView?.view)!
            
        case 2:
            print("accountsView" )
            self.accountsView = AccountsView()
            vc = (self.accountsView?.view)!
            
        case 3:
            print("budgetView" )
            self.budgetView = BudgetView()
            vc = (self.budgetView?.view)!
            
        case 4:
            print("predictionView" )
            self.predictionView = PredicitionView()
            vc = (self.predictionView?.view)!
            
        default:
            print(sender.selectedItem )
            
            break
        }
        win.showContent(vc)
    }
}


//class PBCategoryPopupManager : MLComboFieldDelegate{
//    override func createPopupContent() -> MLPopupContent? {
//        let b = (budgets.arrangedObjects)[budgets.selectionIndex] as? PBBudget
//        let c = PBCategoryContent(budget: b)
//        return c
//    }
//}

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

class PBPayee :  PBEntity{
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
