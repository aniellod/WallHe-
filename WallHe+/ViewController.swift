//
//  ViewController.swift
//  WallHe+
//
//  Created by Aniello Di Meglio on 2021-11-11.
//

import Cocoa
import SwiftUI

class ViewController: NSViewController {
    @IBOutlet weak var pathName: NSTextField!
    @IBOutlet weak var delaySelect: NSPopUpButton!
    @IBOutlet var okButton: NSButtonCell!
    @IBOutlet var stopButton: NSButton!
    @IBOutlet var log: NSTextView!
    @IBOutlet var skipButton: NSButton!
    
    
    var showInfo : Bool = false
    var isRunning : Bool = false
    
    @IBAction func infoToggle(_ sender: NSButton) {
        if !showInfo {
            print("checked")
            showInfo = false
            theWork.showInfo = false
        } else {
            print("unchecked")
            showInfo = true
            theWork.showInfo = true
        }
        updateWallpaper(path: theWork.getCurrentFullPath(), name: theWork.getCurrentImageFile())
    }
    
    
    var delay: Int = 0
    var path: String = ""
    
    @available(macOS 10.10, *)
    override func viewDidLoad() {
        super.viewDidLoad()
        pathName.stringValue = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.path
        path = pathName.stringValue
        self.delay = 10
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
       // selectDelay(self)
        self.delay = 10
    }
    
    func addLogItem(_ fileName: String) {
        log.insertText(fileName + "\n")
    }
   
    @available(macOS 11.0, *)
    struct ContentView: View {
        @State private var text = "HELLOHELLO"
        
        var body: some View {
            TextEditor(text: $text)
        }
    }
    
    func saveDefaults() {
        let mySettings = UserDefaults.standard
        mySettings.set(delaySelect.indexOfSelectedItem, forKey: "menuSelect")
        mySettings.set(self.path, forKey: "path")
        mySettings.set(showInfo, forKey: "showinformation")
        mySettings.set(isRunning, forKey: "isRunning")
    }
    
    func loadDefaults() {
        let mySettings = UserDefaults.standard
        let menuSelect = mySettings.object(forKey: "menuSelect") as? Int ?? 2
        delaySelect.select(delaySelect.menu?.item(at: menuSelect))
        self.path = mySettings.object(forKey: "path") as? String ?? FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.path
        pathName.stringValue = self.path
        showInfo = mySettings.bool(forKey: "showinformation")
        isRunning = mySettings.bool(forKey: "isRunning")
        if isRunning {
            Ok(self)
        }
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

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            if (result != nil) {
                let path: String = result!.path
                pathName.stringValue = path
                return path
            }
        }
            // User clicked on "Cancel"
            return nil
    }
    
    @IBAction func selectPath(_ sender: Any) {
//        theWork.stop()
//        okButton.isEnabled = true
//        stopButton.isEnabled = false
//        skipButton.isEnabled = false
        path = getFileName() ?? FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.path
    }
    
    @IBAction func Ok(_ sender: Any) {
        print("Ok button was preseed - path = \(path)")
        okButton.isEnabled = false
        stopButton.isEnabled = true
        skipButton.isEnabled = true
        isRunning = true
        setUp(secondsDelay: delay, path: path)
    }
    
    @IBAction func exitApp(_ sender: Any) {
        saveDefaults()
        exit(0)
    }
    
    @IBAction func stop(_ sender: Any) {
        okButton.isEnabled = true
        stopButton.isEnabled = false
        skipButton.isEnabled = false
        theWork.stop()
        isRunning = false
        saveDefaults()
    }
    
    @IBAction func selectDelay(_ sender: Any) {
        switch delaySelect.indexOfSelectedItem {
        case 0:
            self.delay = 5
        case 1:
            self.delay = 1 * 60
        case 2:
            self.delay = 5 * 60
        case 3:
            self.delay = 15 * 60
        case 4:
            self.delay = 30 * 60
        case 5:
            self.delay = 60 * 60
        case 6:
            self.delay = 60 * 24 * 60
        default:
            self.delay = 5 * 60
        }
        saveDefaults()
        theWork.stop()
        theWork.setSeconds(UInt32(self.delay))
        theWork.start()
    }
    
    @IBAction func nextImage(_ sender: NSButton) {
        theWork.stop()
        theWork.start()
    }
}

