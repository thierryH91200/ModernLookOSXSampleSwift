//
//  AppDelegate.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 20/04/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    var mainWindowController : MainWindowController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        initializeAndShowMainWindow()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed (_ sender: NSApplication) -> Bool {
        return true
    }

    func initializeAndShowMainWindow() {
        mainWindowController = MainWindowController()
        mainWindowController?.showWindow(self)
    }
}



