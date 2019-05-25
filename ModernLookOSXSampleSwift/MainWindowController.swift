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
        
        self.budgetView = BudgetView()
        let vc = (self.budgetView?.view)!
        
        Commun.shared.addSubview(subView: vc, toView: pbContentView)

        vc.translatesAutoresizingMaskIntoConstraints = false
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["vc"] = vc
        pbContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[vc]|", options: [], metrics: nil, views: viewBindingsDict))
        pbContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[vc]|", options: [], metrics: nil, views: viewBindingsDict))

    }
    
    func createCalendarPopover() {
        
        var myPopover: NSPopover? = calendarPopover
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
        //        win.showContent(settingsView)
        
        createCalendarPopover()
        let btn = sender as? NSButton
        let cellRect: NSRect? = btn?.bounds
        if let btn = btn {
            calendarPopover?.show(relativeTo: cellRect ?? NSRect.zero, of: btn, preferredEdge: .minX)
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
        Commun.shared.addSubview(subView: vc, toView: pbContentView)
        
        vc.translatesAutoresizingMaskIntoConstraints = false
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["vc"] = vc
        pbContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[vc]|", options: [], metrics: nil, views: viewBindingsDict))
        pbContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[vc]|", options: [], metrics: nil, views: viewBindingsDict))

    }
}


//class PBCategoryPopupManager : MLComboFieldDelegate{
//    override func createPopupContent() -> MLPopupContent? {
//        let b = (budgets.arrangedObjects)[budgets.selectionIndex] as? PBBudget
//        let c = PBCategoryContent(budget: b)
//        return c
//    }
//}

