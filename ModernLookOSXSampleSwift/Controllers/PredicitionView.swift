//
//  PredicitionView.swift
//  ModernLookOSXSampleSwift
//
//  Created by thierry hentic on 24/05/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import AppKit
import WebKit

final class PredicitionView: NSViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        webView.navigationDelegate = self
        
        let resourcesPath = Bundle.main.resourcePath
        let urlRes = URL(fileURLWithPath: resourcesPath ?? "")
        let htmlPath = URL(fileURLWithPath: resourcesPath ?? "").appendingPathComponent("line.html").absoluteString
        let url = URL(string: htmlPath)!

        webView.loadFileURL(url, allowingReadAccessTo: urlRes)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    
}
