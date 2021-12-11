//
//  AppDelegate.swift
//  WallHe+
//
//  Created by Aniello Di Meglio on 2021-11-11.
//
//  Copyright (C) 2021 Aniello Di Meglio
//
//  MIT License

import Cocoa

var vc: ViewController = ViewController()
var avc: AdvancedViewController = AdvancedViewController()

var logValue: String = ""

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var popoverView: NSPopover = NSPopover()
    var advancedPopoverView: NSPopover = NSPopover()
    var storyboard: NSStoryboard = NSStoryboard()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let itemImage = NSImage(named: "Wallpapers-icon16")
        itemImage?.isTemplate = true
        statusItem.button?.image = itemImage
        statusItem.button?.target = self
        statusItem.button?.action = #selector(togglePopover)
        
        storyboard = NSStoryboard(name: "Main", bundle: nil)
        vc = (storyboard.instantiateController(withIdentifier: "ViewController") as?
              ViewController)!
        togglePopover(sender: self)
        avc = (storyboard.instantiateController(withIdentifier: "AdvancedViewController") as?
                                                  AdvancedViewController)!
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
    
    @objc func showAdvancedPopover(_ sender: AnyObject) {
        advancedPopoverView.contentViewController = avc
        advancedPopoverView.behavior = .transient
        //advancedPopoverView.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .maxY)
     }
    
    func hideAdvancedPopover(_ sender: AnyObject) {
        advancedPopoverView.performClose(sender)
        }
}

//protocol viewMaker: NSViewController {
//    init()
//    
//    func getLog(logText: String)
//
//}
