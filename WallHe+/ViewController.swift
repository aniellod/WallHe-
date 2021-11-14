//
//  ViewController.swift
//  WallHe+
//
//  Created by Aniello Di Meglio on 2021-11-11.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var pathName: NSTextField!
    @IBOutlet weak var delaySelect: NSPopUpButton!
    @IBOutlet var okButton: NSButtonCell!
    @IBOutlet var stopButton: NSButton!
    
    var showInfo : Bool = false
    
    @IBAction func infoToggle(_ sender: NSButton) {
        if showInfo {
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
    var value: Int = 0
    
    @available(macOS 10.10, *)
    override func viewDidLoad() {
        super.viewDidLoad()
        pathName.stringValue = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.path
        path = pathName.stringValue
        self.delay = 5 // * 60
        value += 1
        stopButton.isEnabled = false
        okButton.isEnabled = true
            print("The value is \(value)")
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
        path = getFileName()!
    }
    
    @IBAction func Ok(_ sender: Any) {
        print("Ok button was preseed - path = \(path)")
        okButton.isEnabled = false
        stopButton.isEnabled = true
        setUp(secondsDelay: delay, path: path) //, instance: theWork)
    }
    
    @IBAction func exitApp(_ sender: Any) {
        exit(0)
    }
    
    @IBAction func stop(_ sender: Any) {
        okButton.isEnabled = true
        stopButton.isEnabled = false
        theWork.stop()
    }
    
    @IBAction func selectDelay(_ sender: Any) {
        switch delaySelect.indexOfSelectedItem {
            case 0:
            self.delay = 5 // * 60
            case 1:
            self.delay = 10 //* 60
            case 2:
            self.delay = 15 //* 60
            default:
                print("default")
        }
    }
}

