//
//  advanced.swift
//  WallHe+
//
//  Created by Aniello Di Meglio (Admin) on 2021-12-05.
//

import Foundation
import Cocoa

class AdvancedViewController: NSViewController {

    @IBOutlet var logViewer: NSTextView!
    @IBOutlet weak var filteredTags: NSTokenField!
    
    var tempLogView: NSTextView = NSTextView()
    var advancedPopoverView: NSPopover = NSPopover()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logViewer.maxSize = NSMakeSize(CGFloat(Float.greatestFiniteMagnitude), CGFloat(Float.greatestFiniteMagnitude))
        logViewer.isHorizontallyResizable = true
        logViewer.textContainer?.widthTracksTextView = false
        logViewer.textContainer?.containerSize = NSMakeSize(CGFloat(Float.greatestFiniteMagnitude), CGFloat(Float.greatestFiniteMagnitude))
        logViewer.textStorage?.append(NSAttributedString(string: logValue))
        logViewer.textContainer?.textView?.moveToEndOfDocument(nil)
        filteredTags.stringValue = vc.tokenFilter.stringValue
        logViewer.isEditable = true
        if filteredTags.acceptsFirstResponder {
            filteredTags.window?.makeFirstResponder(filteredTags)
        }
        var avc: AdvancedViewController = (storyboard!.instantiateController(withIdentifier: "AdvancedViewController") as? AdvancedViewController)!
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func sendTokens(_ sender: Any) {
        vc.tokenFilter = filteredTags
        print("in sendTokens")
    }
    
    func updateLogViewer(_ value: String) {
        if logViewer != nil
        {
            logViewer.textStorage?.append(NSAttributedString(string: value))
        }
    }
    
    @IBAction func update(_ sender: Any) {
        if logViewer != nil {
            logViewer.textContainer?.textView?.string = ""
            logViewer.textStorage?.append(NSAttributedString(string: logValue))
            logViewer.textContainer?.textView?.moveToEndOfDocument(sender)
        }
    }
    
    @IBAction func ok(_ sender: Any) {
        vc.tokenFilter = filteredTags
        print("filteredTags = \(vc.tokenFilter.stringValue)")
        print("is editable tags: \(filteredTags.isEditable)")
        dismiss(self)
    }

//    func addLogItem(_ filename: String) {
//        let formatter = DateFormatter()
//        let now = Date()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .short
//        let date = formatter.string(from: now)
//        //logViewer_.isEditable = true
//        logValue = logValue + "\(date) - \(filename)\n"
//        updateLogViewer(logValue)
//        print("Log view = \(logValue)")
//        //logViewer_.isEditable = false
//    }
}
