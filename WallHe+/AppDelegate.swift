//
//  AppDelegate.swift
//  WallHe+
//
//  Created by Aniello Di Meglio on 2021-11-11.
//

import Cocoa

//var vc: ViewController = ViewController()

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var popoverView: NSPopover = NSPopover()
    var storyboard: NSStoryboard = NSStoryboard()
    var vc: ViewController = ViewController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem.button?.title = "🌅"
        statusItem.button?.target = self
        statusItem.button?.action = #selector(togglePopover)
        
        storyboard = NSStoryboard(name: "Main", bundle: nil)
        vc = (storyboard.instantiateController(withIdentifier: "ViewController") as?
              ViewController)!
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

   @objc func showPopover(_ sender: AnyObject) {
        popoverView.contentViewController = vc
        popoverView.behavior = .transient
        popoverView.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .maxY)
    }
    
    func hidePopover(_ sender: AnyObject) {
            popoverView.performClose(sender)
        }
}
