//
//  MLRadioGroupManager.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 24/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import Cocoa

class MLRadioGroupManager: NSControl {
    
    var selectedItem: Int = 0
    
    @IBOutlet weak var groupView: NSView!
    
    @IBAction func buttonClicked(_ sender: NSButton) {
        if sender.state != .on {
            sender.state = .on
            return
        }
        if sender.state == .on {
            for v in groupView.subviews {
                if v == sender {
                    continue
                }
                if (v is NSButton) {
                    let b = v as? NSButton
                    b?.state = .off
                }
            }
        }
        selectedItem = sender.tag
        target?.performSelector(onMainThread: action!, with: self, waitUntilDone: true)
    }
    
    func setSelectedItem( selectedItem : Int) {
        let selectedItem = selectedItem
        for v in groupView.subviews {
            if (v is NSButton) {
                let b = v as? NSButton
                if b?.tag == selectedItem {
                    b?.state = .on
                } else {
                    b?.state = .off
                }
            }
        }
    }
}


