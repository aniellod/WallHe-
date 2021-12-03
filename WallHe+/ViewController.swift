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
    @IBOutlet weak var delaySelect: NSPopUpButton!
    @IBOutlet var okButton: NSButtonCell!
    @IBOutlet var stopButton: NSButton!
    @IBOutlet var log: NSTextView!
    @IBOutlet var skipButton: NSButton!
    @IBOutlet var showInfoBox: NSButton!
    @IBOutlet weak var doSubDirectories: NSButton!
    @IBOutlet weak var progress: NSProgressIndicator!
    @IBOutlet weak var loadingText: NSTextField!
    
    var showInfo : Bool = false
    var isRunning : Bool = false
    var menuSelect : Int = 2
    var delay: Int = 0
    var path: [String] = []
    var lePopOver = NSPopover()
    var data: NSMutableArray = NSMutableArray()

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
        updateWallpaper(name: theWork.imageFile)
     //   updateWallpaper(path: theWork.directory, name: theWork.imageFile)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup the log window so each line doesn't wrap around
        log.maxSize = NSMakeSize(CGFloat(Float.greatestFiniteMagnitude), CGFloat(Float.greatestFiniteMagnitude))
        log.isHorizontallyResizable = true
        log.textContainer?.widthTracksTextView = false
        log.textContainer?.containerSize = NSMakeSize(CGFloat(Float.greatestFiniteMagnitude), CGFloat(Float.greatestFiniteMagnitude))
        stopButton.isEnabled = false
        okButton.isEnabled = true
        delaySelect.removeAllItems()
        progress.isHidden = true
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
            setUp(secondsDelay: delay, paths: path, subs: (doSubDirectories.state == .on ? true : false))
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
        log.isEditable = true
        log.textStorage?.append(NSAttributedString(string: date + " - " + fileName + "\n"))
        log.isEditable = false
    }
    
    func saveDefaults() {
        let mySettings = UserDefaults.standard
        mySettings.set(delaySelect.indexOfSelectedItem, forKey: "menuSelect")
        mySettings.set(self.path, forKey: "path")
        mySettings.set(showInfo, forKey: "showinformation")
        mySettings.set(isRunning, forKey: "isRunning")
        mySettings.set(theWork.count, forKey: "count")
        mySettings.set(doSubDirectories.state, forKey: "subdirs")
    }
    
    func loadDefaults() {
        let mySettings = UserDefaults.standard
        menuSelect = mySettings.object(forKey: "menuSelect") as? Int ?? 2
        delaySelect.select(delaySelect.menu?.item(at: menuSelect))
        self.path = mySettings.object(forKey: "path") as? [String] ?? [FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.path]
        displaySelectedFolders()
        showInfo = mySettings.bool(forKey: "showinformation")
        showInfoBox.state = showInfo == true ? .on : .off
        setInfo()
        theWork.count = mySettings.object(forKey: "count") as? Int ?? 0
        isRunning = mySettings.bool(forKey: "isRunning")
        stopButton.title = "Start"
        doSubDirectories.state = mySettings.object(forKey: "subdirs") as? NSButton.StateValue ?? .off
    }
    
    func displaySelectedFolders() {
        var folder: String = ""
        for path in self.path {
            folder = folder + "\n" + path
        }
        addLogItem(folder)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.

        }
    }

    func getFileName() -> [String] {
        let dialog = NSOpenPanel();
        dialog.title                   = "Choose folder";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = true;
        dialog.canChooseDirectories = true
        dialog.canChooseFiles = false
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.urls // Pathname of the file
            print("Result = \(result)")
            var selectedPath: Array<String> = []
            if (result.count != 0) {
                for path in result {
                    selectedPath.append(path.path)
                }
                return selectedPath
            }
        }
            // User clicked on "Cancel"
            return []
    }

    @IBAction func selectPath(_ sender: Any) {
        path = self.getFileName() // ?? FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.path
    }
    
    @IBAction func Ok(_ sender: Any) {  //load button
        errCounter = 0
        stopButton.isEnabled = true
        skipButton.isEnabled = true
        displaySelectedFolders()
        setUp(secondsDelay: delay, paths: path,subs: (doSubDirectories.state == .on ? true : false))
    }
    
    @IBAction func exitApp(_ sender: Any) {
        stopAnimation()
        saveDefaults()
        exit(0)
    }
    
    @IBAction func stop(_ sender: Any) {
        let type = sender is NSButton
        var typeCheck: String = ""
        if type == false { //if the call is not from a button, it is a string.
            typeCheck = sender as! String
        }

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

        if typeCheck == "_Any_" {
            okButton.isEnabled = true
            stopButton.title = "Start"
            stopButton.isEnabled = false
            skipButton.isEnabled = false
            theWork.stop()
            isRunning = false
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
    
    func startAnimation() {
        progress.isHidden = false
        loadingText.isHidden = false
        progress.startAnimation(nil)
    }
    
    func stopAnimation() {
        progress.stopAnimation(nil)
        progress.isHidden = true
        loadingText.isHidden = true
    }
}

