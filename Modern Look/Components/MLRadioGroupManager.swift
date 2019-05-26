//
//  MLRadioGroupManager.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 24/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit

final class MLRadioGroupManager: NSControl {
    
    static let shared = MLRadioGroupManager()

    var selectedItem: Int = 0
    
    @IBOutlet weak var groupView: NSView!
    
    @IBAction func buttonClicked(_ sender: NSButton) {
        if sender.state != .on {
            sender.state = .on
            return
        }
        if sender.state == .on {
            for view in groupView.subviews {
                if view == sender {
                    continue
                }
                if (view is NSButton) {
                    let b = view as! NSButton
                    b.state = .off
                }
            }
        }
        selectedItem = sender.tag
        target?.performSelector(onMainThread: action!, with: self, waitUntilDone: true)
    }
    
    func setSelectedItem( selectedItem : Int) {
        let selectedItem = selectedItem
        
        for view in groupView.subviews {
            if (view is NSButton) {
                let button = view as! NSButton
                if button.tag == selectedItem {
                    button.state = .on
                } else {
                    button.state = .off
                }
            }
        }
    }
}


