//
//  MLAlert.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 22/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

enum MLAlertResponse : NSApplication.ModalResponse.RawValue {
    case no = -1000
    case cancel = 0
    case yes = 1
}

final class MLAlert: NSWindowController {
    
    @IBOutlet weak var title: NSTextField!
    @IBOutlet weak var message: NSTextField!
    @IBOutlet weak var cancel: NSButton!
    @IBOutlet weak var yes: NSButton!
    @IBOutlet weak var no: NSButton!
    @IBOutlet weak var toolbar: MLToolbar!
    
    init() {
        super.init(window: nil)
        Bundle.main.loadNibNamed("MLAlertYesNoCancel", owner: self, topLevelObjects: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var windowNibName: NSNib.Name? {
        return  "MLAlertYesNoCancel"
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
//        let rctWindow = NSMakeRect(0, 0, 210, 306)
//        let window = NSWindow(contentRect: rctWindow, styleMask: [.titled, .fullSizeContentView], backing: .buffered, defer: true)
//
//        self.window?.frame = window.frame
//        window?.contentView = MLWindowContent()
        window?.maxSize = NSSize(width: 200, height: 200)
//        let frame = window?.frame
    }
    
    func showQuestion(_ question: String, title: String, withCancel: Bool,  titles: [String]) -> MLAlertResponse {
        
        if withCancel == false {
            cancel.isHidden = true
        }
        self.title.stringValue = title
        self.message.stringValue = question
        if titles.count == 3 {
            self.cancel.title = titles[0]
            self.yes.title = titles[1]
            self.no.title = titles[2]
        } else {
            self.yes.title = titles[0]
            self.no.title = titles[1]
        }
        self.resizeButtons()
        
        let res = self.runAlert()
        self.window?.close()
        return res
    }
    
    func showQuestion(_ question: String, title: String, withCancel: Bool) -> MLAlertResponse {
        return showQuestion(question, title: title, withCancel: withCancel, titles: ["Cancel", "Yes", "No"])
    }
    
    func showError(_ question: String, title: String, buttonsTitle butonTitle: String) -> MLAlertResponse {
        
        let alert = MLAlert()

        self.toolbar.backgroundColor = .textBackgroundColor
        self.cancel.isHidden = true
        self.yes.isHidden = true
        
        self.title.stringValue = title
        self.message.stringValue = question
        self.no.title = butonTitle
        self.resizeButtons()
        
        let res = self.runAlert()
        self.window?.close()
        return res
    }
    
    func showError(_ question: String, title: String) -> MLAlertResponse {
        return showError(question, title: title, buttonsTitle: "Back")
    }
    
    func resizeButtons() {

        var cr = cancel.bounds
        var yr = yes.bounds
        var nr = no.bounds
        
        cr.size.width = cancel.frame.size.width + 10
        yr.size.width = yes.frame.size.width + 10
        nr.size.width = no.frame.size.width + 10
        
        if cr.size.width < 85 {
            cr.size.width = 85
        }
        if yr.size.width < 85 {
            yr.size.width = 85
        }
        if nr.size.width < 85 {
            nr.size.width = 85
        }
        
        no.bounds = nr
        yes.bounds = yr
        cancel.bounds = cr
        
        no.needsDisplay = true
        yes.needsDisplay = true
        cancel.needsDisplay = true
    }
    
    func runAlert() -> MLAlertResponse {
        MLMainWindow.shared.relativeCenter(window)
        let runSessionRes = NSApplication.shared.runModal(for: window!)
        window?.close()
        
        let response = MLAlertResponse(rawValue: runSessionRes.rawValue)!
        return response
    }
    
    func windowWillClose(_ notification: Notification) {
    }
    
    @IBAction func doCancel(_ sender: Any) {
        NSApp.stopModal(withCode: .cancel)
    }
    
    @IBAction func doYes(_ sender: Any) {
        NSApp.stopModal(withCode: .OK)
    }
    
    @IBAction func doNo(_ sender: Any) {
        NSApp.stopModal()
    }
    
}
