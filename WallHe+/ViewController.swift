//
//  ViewController.swift
//  WallHe+
//
//  Created by Aniello Di Meglio on 2021-11-11.
//
//  Copyright (C) 2021 Aniello Di Meglio
//
//  MIT License

import Cocoa
import SwiftUI

class ViewController: NSViewController {
    @IBOutlet weak var pathName: NSTextField!
    @IBOutlet weak var delaySelect: NSPopUpButton!
    @IBOutlet var okButton: NSButtonCell!
    @IBOutlet var stopButton: NSButton!
    @IBOutlet var log: NSTextView!
    @IBOutlet var skipButton: NSButton!
    @IBOutlet var showInfoBox: NSButton!
    
    var showInfo : Bool = false
    var isRunning : Bool = false
    var menuSelect : Int = 2
    var delay: Int = 0
    var path: String = ""
    var lePopOver = NSPopover()
    
    @IBAction func infoToggle(_ sender: NSButton) {
        setInfo()
    }
    
    func setInfo() {
        if showInfoBox.state == .off {
            showInfo = false
            theWork.showInfo = false
        } else {
            showInfo = true
            theWork.showInfo = true
        }
        updateWallpaper(path: theWork.directory, name: theWork.imageFile)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.maxSize = NSMakeSize(CGFloat(Float.greatestFiniteMagnitude), CGFloat(Float.greatestFiniteMagnitude))
        log.isHorizontallyResizable = true
        log.textContainer?.widthTracksTextView = false
        log.textContainer?.containerSize = NSMakeSize(CGFloat(Float.greatestFiniteMagnitude), CGFloat(Float.greatestFiniteMagnitude))
        pathName.stringValue = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.path
        path = pathName.stringValue
        stopButton.isEnabled = false
        okButton.isEnabled = true
        delaySelect.removeAllItems()
        delaySelect.addItems(withTitles:
                                ["Every 5 seconds",
                                 "Every minute",
                                 "Every 5 minutes",
                                 "Every 15 minutes",
                                 "Every 30 minutes",
                                 "Every hour",
                                 "Every day"
                                ])
        loadDefaults()

        self.delay = getSeconds(selection: menuSelect)
        if isRunning {
            stopButton.isEnabled = true
            skipButton.isEnabled = true
            setUp(secondsDelay: delay, path: path)
            okButton.isEnabled = false
            stopButton.title = "Stop"
            theWork.start()
        }
    }

    func addLogItem(_ fileName: String) {
        let formatter = DateFormatter()
        let now = Date()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let date = formatter.string(from: now)
      //  log.insertText(date , replacementRange: NSRange(location: 0, length: date.count))
        log.isEditable = true
        log.insertText(date + " - " + fileName + "\n")
        log.isEditable = false
    }
    
    func saveDefaults() {
        let mySettings = UserDefaults.standard
        mySettings.set(delaySelect.indexOfSelectedItem, forKey: "menuSelect")
        mySettings.set(self.path, forKey: "path")
        mySettings.set(showInfo, forKey: "showinformation")
        mySettings.set(isRunning, forKey: "isRunning")
        mySettings.set(theWork.count, forKey: "count")
    }
    
    func loadDefaults() {
        let mySettings = UserDefaults.standard
        menuSelect = mySettings.object(forKey: "menuSelect") as? Int ?? 2
        delaySelect.select(delaySelect.menu?.item(at: menuSelect))
        self.path = mySettings.object(forKey: "path") as? String ?? FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.path
        pathName.stringValue = self.path
        showInfo = mySettings.bool(forKey: "showinformation")
        if showInfo == true { showInfoBox.state = .on } else { showInfoBox.state = .off }
        setInfo()
        theWork.count = mySettings.object(forKey: "count") as? Int ?? 0
        isRunning = mySettings.bool(forKey: "isRunning")
        stopButton.title = "Start"
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.

        }
    }

    func getFileName() -> String? {
        let dialog = NSOpenPanel();
        dialog.title                   = "Choose folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = true
        dialog.canChooseFiles = false
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            if (result != nil) {
                let selectedPath: String = result!.path
                self.pathName.stringValue = selectedPath // show path in user interface
                return selectedPath
            }
        }
            // User clicked on "Cancel"
            return nil
    }

    @IBAction func selectPath(_ sender: Any) {
            path = self.getFileName() ?? FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.path
    }
    
    @IBAction func Ok(_ sender: Any) {
        //print("Ok button was preseed - path = \(path) or \(pathName.stringValue)")
        stopButton.isEnabled = true
        skipButton.isEnabled = true
        setUp(secondsDelay: delay, path: path)
    }
    
    @IBAction func exitApp(_ sender: Any) {
        saveDefaults()
        exit(0)
    }
    
    @IBAction func stop(_ sender: Any) {
        if isRunning {
            okButton.isEnabled = true
            stopButton.title = "Start"
            skipButton.isEnabled = false
            theWork.stop()
            isRunning = false
        } else {
            okButton.isEnabled = false
            stopButton.title = "Stop"
            skipButton.isEnabled = true
            theWork.start()
            isRunning = true
        }
        saveDefaults()
    }
    
    @IBAction func selectDelay(_ sender: Any) {
        self.delay = getSeconds(selection: delaySelect.indexOfSelectedItem)
        theWork.seconds = UInt32(self.delay)
        saveDefaults()
    }
    
    func getSeconds(selection: Int) -> Int {
        var secs = 0
        switch selection {
        case 0:
            secs = 5
        case 1:
            secs = 1 * 60
        case 2:
            secs = 5 * 60
        case 3:
            secs = 15 * 60
        case 4:
            secs = 30 * 60
        case 5:
            secs = 60 * 60
        case 6:
            secs = 60 * 24 * 60
        default:
            secs = 5 * 60
        }
        return secs
    }
    
    @IBAction func nextImage(_ sender: NSButton) {
        theWork.skip()
    }
}

