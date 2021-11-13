//
//  AppDelegate.swift
//  WallHe+
//
//  Created by Aniello Di Meglio (Admin) on 2021-11-11.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var popoverView: NSPopover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem.button?.title = "🌅"
        statusItem.button?.target = self
        //statusItem.button?.action = #selector(showSettings)
        statusItem.button?.action = #selector(togglePopover)
    }

    @objc func togglePopover(sender: AnyObject) {
            if(popoverView.isShown) {
                hidePopover(sender)
            }
            else {
                showPopover(sender)
            }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

   // @objc func showSettings() {
   @objc func showPopover(_ sender: AnyObject) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "ViewController") as?
                ViewController else {
                    fatalError("Unable to open viewcontroller")
                }
        //let popoverView = NSPopover()
        popoverView.contentViewController = vc
        popoverView.behavior = .applicationDefined
        popoverView.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .maxY)
    }
    
    func hidePopover(_ sender: AnyObject) {
            popoverView.performClose(sender)
        }
}

