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
    
    var showInfo : Bool = false
    
    @IBAction func infoToggle(_ sender: NSButton) {
        if showInfo {
            print("checked")
            showInfo = false
        } else {
            print("unchecked")
            showInfo = true
        }
    }
    
    
    var delay: Int = 0
    var path: String = ""
    var value: Int = 0
    
    @available(macOS 10.10, *)
    override func viewDidLoad() {
        super.viewDidLoad()
        pathName.stringValue = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.absoluteString
        self.delay = 5 // * 60
        value += 1
        
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
                //print("The selected path = \(path)")
                //self.pathName.mutableSetValue(forKey: path)
                pathName.stringValue = path
                return path
                // path contains the file path e.g
                // /Users/ourcodeworld/Desktop/file.txt
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
        setUp(secondsDelay: delay, path: path)
    }
    
    @IBAction func exitApp(_ sender: Any) {
        exit(0)
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

