//
//  advanced.swift
//  WallHe+
//
//  Created by Aniello Di Meglio (Admin) on 2021-12-05.
//

import Foundation
import Cocoa

class AdvancedViewController: NSViewController {
    
    @IBOutlet weak var dataField: NSTextField!
    @IBOutlet var logViewer_: NSTextView!
    
    var logValue: NSAttributedString = NSAttributedString(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataField.stringValue = vc.stopButton.stringValue
        logViewer_.textStorage?.append(logValue)
    }
    
}
