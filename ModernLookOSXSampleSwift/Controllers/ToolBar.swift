//
//  ToolBar.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 28/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

class ToolBar: NSViewController { //}, MLCalendarViewDelegate {
    
    var settingsView: SettingsView?
    var accountsView: AccountsView?
    var budgetView: BudgetView?
    var predictionView: PredicitionView?
    
    var mainWindowController : MainWindowController!

    @IBOutlet weak var mlRadioGroupManager: MLRadioGroupManager!

    var calendarPopover: NSPopover?
    var calendarView: MLCalendarView?

    let mlAlert = MLAlert()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func createCalendarPopover() {
        
        var myPopover = self.calendarPopover
        if myPopover == nil {
            
            var appearance = NSAppearance(named: .darkAqua)
            
            if appearance!.isDarkMode == false {
                appearance = NSAppearance(named: .aqua)
            }
            
            myPopover = NSPopover()
            calendarView = MLCalendarView()
            calendarView?.delegate = self
            
            myPopover?.contentViewController = calendarView
            myPopover?.appearance = appearance
            myPopover?.animates = true
            myPopover?.behavior = .transient
            myPopover?.delegate = self
        }
        self.calendarPopover = myPopover
    }
    
    @IBAction func showCalendar(_ sender: Any) {
        createCalendarPopover()
        
        calendarView?.date = Date()
        calendarView?.selectedDate = Date()
        
        let button = sender as? NSButton
        let cellRect = button?.bounds
        if let button = button {
            calendarPopover?.show(relativeTo: cellRect ?? CGRect.zero, of: button, preferredEdge: .maxY)
        }
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
        }
        mainWindowController.win.showContent(vc)
    }
    
    @IBAction func hyperlinkAction(_ sender: Any) {
        
        print("Hyperlink Clicked")
    }
    
    @IBAction func appearanceSelection(_ sender: NSSegmentedControl) {
        let appearance: NSAppearance.Name = sender.selectedSegment == 0 ? .aqua : .darkAqua
        view.window?.appearance = NSAppearance(named: appearance)
    }
    
    @IBAction func showAlert(_ sender: Any) {
        
//        _ = mlAlert.window?.contentView
        
        let res = mlAlert.showQuestion("question ??", title: "showAlert", withCancel: true)
        switch res {
        case .yes:
            break
        case .no:
            break
        case .cancel:
            break
        }
    }

}

extension  ToolBar : MLCalendarViewDelegate {
    func didSelectDate(_ selectedDate: Date) {
        //        calendarPopover?.close()

    }
    
}

extension  ToolBar : NSPopoverDelegate {
    
    func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        return true
    }
    
    func detachableWindow(for popover: NSPopover) -> NSWindow? {
        //        disableDetachButton()
        return nil
    }
    
}

fileprivate extension NSAppearance {
    var isDarkMode: Bool {
        if #available(macOS 10.14, *) {
            if self.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}


