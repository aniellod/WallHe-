//
//  main.swift
//  wallhe (requires MacOS 10.15+)
//
//  Swift 5
//
//  Created by Aniello Di Meglio on 2021-11-03.
//
//  Parts were converted to Swift 5.5 from Objective-C by Swiftify v5.5.22755 - https://swiftify.com/
//  Inspired by Wally by Antonio Di Monaco
//
//  Warning - very buggy and little error checking. Lots of cargo culting...
//
//
//  Requirements:
//      Swift-Image to handle .png:     https://github.com/koher/swift-image.git
//      Accessibility control to enable keyboard control of wallpaper
//
//  Very basic wallpaper controler for MacOS 10.15+
//
//  Specify image folder and delay, Wallhe will randomly pick an image, resize/tile it to fit all visible desktops then loop through all images. Control-C to exit.

//  Copyright (C) 2021 Aniello Di Meglio
//
//  MIT License

import Foundation
import SwiftUI
import CoreGraphics
import SwiftImage // https://github.com/koher/swift-image.git

let theWork = thread2()
//var theFilelist: Array<String> = []

class thread2 {
    var filelist: Array<String>
    var seconds: UInt32
    var currentImageFile: String
    var currentFullPath: String
    var count: Int
    var showInfo: Bool
    var fullpath: String
    var thread: Thread
    
    init() {
        self.seconds = 0
        self.filelist = []
        self.currentImageFile = ""
        self.currentFullPath = ""
        self.count = 0
        self.showInfo = false
        self.fullpath = ""
        self.thread = Thread()
    }
    
    var fileList: Array<String> {
        get { return filelist }
        set { filelist = newValue }
    }
    
    var delay: UInt32 {
        get { return seconds }
        set { seconds = newValue }
    }
    
    var directory: String {
        get { return currentFullPath }
        set { currentFullPath = newValue }
    }
    
    var imageFile: String {
        get { return currentImageFile }
        set { currentImageFile = newValue }
    }
    
    func load() {
        filelist.removeAll()
        filelist = buildFileList(directory)
        filelist.shuffle()
        count = 0
    }
    
    func start() {
        thread = Thread.init(target: self, selector: #selector(mainLoop), object: nil)
        thread.start()
    }
    
    func stop() {
        while thread.isExecuting {
            thread.cancel()
        }
    }
    
    func skip() {
        while thread.isExecuting {
            thread.cancel()
        }
        thread = Thread.init(target: self, selector: #selector(mainLoop), object: nil)
        thread.start()
    }
    
    @objc func mainLoop() {
        let initCount = filelist.count
        for i in count..<filelist.count {
            let imageFile = filelist[i]
                fullpath = directory
            if directory.last != "/" {
                    fullpath += "/"
            }
            self.currentImageFile = imageFile
            self.currentFullPath = fullpath
            self.count+=1
            let countString = String(self.count) + "/" + String(filelist.count) + " - "
            DispatchQueue.main.async {
                vc.addLogItem(countString + imageFile)
            }
            autoreleasepool {
                updateWallpaper(path: fullpath, name: imageFile)
            }
           // print("Initcount=\(initCount) fileList.count=\(fileList.count)")
            for _ in 1..<seconds { // checks for cancellation every second
                sleep(1)
                if thread.isCancelled {
                    return
                }
            }
            if initCount != fileList.count { //if we have a new count, restart with the right number of images.
                break
            }
        }
        self.count = 0 //we're out of the loop, reset the count
        self.start() //restart loop, otherwise this thread terminates.
    }
}

// setBackground: input=path to prepared image file. Updates the display with the new wallpaper on all screens.
func setBackground(theURL: String) {
    let workspace = NSWorkspace()
    let fixedURL = URL(string: theURL)
    var options = [NSWorkspace.DesktopImageOptionKey: Any]()
    options[.imageScaling] = NSImageScaling.scaleProportionallyUpOrDown.rawValue
    options[.allowClipping] = false
    let theScreens = NSScreen.screens
    for x in theScreens {
        do {
        try workspace.setDesktopImageURL(fixedURL!, for: x, options: options)
        } catch {print("Unable to update wallpaper!")}
    }
}

// fileName: outputs the filename to use. This is a really silly hack as it should be able to tell
// MacOS to reload the wallpaper file. Need to switch names as otherwise MacOS will not update it otherwise.
func fileName() -> String {
    var fileName = "wallhe-wallpaper1.png"
    let path = NSSearchPathForDirectoriesInDomains(.picturesDirectory, .userDomainMask, true)[0] as String
    let url = NSURL(fileURLWithPath: path)
    if let pathComponent = url.appendingPathComponent(fileName) {
        let filePath = pathComponent.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            fileName = "wallhe-wallpaper2.png"
            let deleted = FileManager()
            do {
                let fileToDeleteURL = url.appendingPathComponent("wallhe-wallpaper1.png")
                try deleted.removeItem(at: fileToDeleteURL!)
               } catch { return fileName }
        } else {
            fileName = "wallhe-wallpaper1.png"
            do {
                let deleted = FileManager()
                let fileToDeleteURL = url.appendingPathComponent("wallhe-wallpaper2.png")
                try deleted.removeItem(at: fileToDeleteURL!)
            } catch { return fileName }
        }
    }
    return fileName
}

// buildWallpaper: input is the image; output is the tiled wallpaper ready to go.
func buildWallpaper(sample: NSImage, text: String...) -> NSImage {
    let textFont = NSFont(name: "Helvetica Bold", size: 18)!
    let textFontAttributes = [
        NSAttributedString.Key.font: textFont,
        NSAttributedString.Key.shadow: NSShadow(),
        NSAttributedString.Key.foregroundColor: NSColor.gray,
        NSAttributedString.Key.backgroundColor: NSColor.black
    ]
    
    var drawText=NSString(string: text[0])
    if !theWork.showInfo {
        drawText = ""
    }
    
    let screenSize = NSScreen.screenSize
    let sw = screenSize!.width
    let sh = screenSize!.height
    let tiles = Int(sw / sample.size.width)
    let resultImage = NSImage(size: (NSMakeSize(sw,sh)))
    
    resultImage.lockFocus()
    
    do {
        for x in 0...tiles {
            sample.draw(at: NSPoint(x: Int(sample.size.width) * x, y: 0),
                        from: NSRect.zero,
                        operation: NSCompositingOperation.sourceOver,
                        fraction: 1.0)
        }
        sample.draw(at: NSPoint(x: Int(sample.size.width) * tiles, y: 0),
                    from: NSRect(x: 0, y:0, width: (sw - sample.size.width * 2), height: sh),
                    operation: NSCompositingOperation.sourceOver, fraction: 1.0)
    }
    drawText.draw(at: NSPoint(x: 20, y: sh - 60), withAttributes: textFontAttributes)
    resultImage.unlockFocus()
    
    return resultImage
}

// extention to NSScreen to provide easy access screen to dimenstions
extension NSScreen{
    static let screenWidth = NSScreen.main?.frame.width
    static let screenHeight = NSScreen.main?.frame.height
    static let screenSize = NSScreen.main?.frame.size
}

// extension to NSImage to write PNG formatted images for the wallpaper
extension NSImage {
    var pngData: Data? {
        guard   let tiffRepresentation = tiffRepresentation,
                let bitmapImage = NSBitmapImageRep(data: tiffRepresentation)
        else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        autoreleasepool {
            do {
                try pngData?.write(to: url, options: options)
                return true
            } catch {
                print(error)
            return false
            }
        }
    }
}

// resizedImage: input = URL of input image; size = new size of image; output = new resized image
func resizedImage(at url: URL, for size: CGSize) -> NSImage? {
    if url.path.lowercased().contains(".png") {
        let thisImage = SwiftImage.Image<RGB<UInt8>>(contentsOfFile: url.path)
        let result = thisImage?.resizedTo(width: Int(size.width), height: Int(size.height))
        let scaledImage = result?.nsImage
        return scaledImage
    } else { // this is faster but doesn't seem to handle png files.
        guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            return nil
        }
        
        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: image.bitsPerComponent,
                                bytesPerRow: 0,
                                space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                bitmapInfo: image.bitmapInfo.rawValue)
        context?.interpolationQuality = .high
        autoreleasepool {
            context?.draw(image, in: CGRect(origin: .zero, size: size))
        } 
        guard let scaledImage = context?.makeImage() else { return nil }
        
        return NSImage(cgImage: scaledImage,
                       size: CGSize(width: size.width,height: size.height))
    }
}

// updateWallpaper: input path to image
func updateWallpaper(path: String, name: String) {
    let desktopURL = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!
    let destinationURL: URL = desktopURL.appendingPathComponent(fileName())
    
    let fullPath = path + name
    let theURL = URL(fileURLWithPath: fullPath)
    let origImage = NSImage(contentsOf: theURL)
    guard let height = origImage?.size.height else {
        print("Error in calculating height of image at \(path)")
        return
    }
    let ratio = NSScreen.screenHeight! / height
    let newWidth = (origImage!.size.width) * ratio

    guard let newImage = resizedImage(at: theURL, for: CGSize(width: newWidth, height: NSScreen.screenHeight!))
    else {
        print("Error \(theURL) cannot be opened.")
        return
    }

    let finalImage = buildWallpaper(sample: newImage, text: fullPath)
    
    guard finalImage.pngWrite(to: destinationURL) else {
        print("File count not be saved")
        return
    }
    setBackground(theURL: (destinationURL.absoluteString))
}

func setUp(secondsDelay: Int, path: String) {
    let filemgr = FileManager.default
    var dirName = ""
    var filelist: Array<String> = []

    if !filemgr.fileExists(atPath: path) {
        dirName = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask).first!.path
    } else {
        dirName = path
    }
    
    filelist = buildFileList(dirName)
    
    if filelist.count == 0 {
        return
    }
    
    let seconds: UInt32 = UInt32(abs(Int(exactly: secondsDelay)!))
    
    theWork.fileList = filelist
    theWork.delay = seconds
    theWork.directory = path
    theWork.load()
}

func buildFileList(_ pathToSearch: String) -> Array<String> {
    let filemgr = FileManager.default
    var theFilelist: Array<String> = []
    
    let directoryURL = URL(fileURLWithPath: pathToSearch)
    do {
        theFilelist = try filemgr.contentsOfDirectory(atPath: pathToSearch)
    } catch { print(error) }
    
//    filelist = filelist.filter{  //is there a way for MacOS to return only supported imagefiles without relying on file extensions?
//           $0.lowercased().contains(".jp")
//        || $0.lowercased().contains(".png")
//        || $0.lowercased().contains(".bmp")
//    }
    
    let queue = DispatchQueue(label: "on.images")
    queue.async {
        theFilelist = theFilelist.filter{ NSImage(contentsOfFile: pathToSearch+"/"+$0) != nil } //filter out non-images
   
        if theFilelist.count == 0 {
            print()
            print("No images found in directory \(String(describing: directoryURL))")
        }
        //print("filelist.count=\(theFilelist.count)")
        theWork.fileList = theFilelist //update the number of images we actually have
    }
    return theFilelist
}

//func buildFileList(_ pathToSearch: String) -> Array<String> {
//    let filemgr = FileManager.default
//    var filelist: Array<String> = []
//
//    let directoryURL = URL(fileURLWithPath: pathToSearch)
//    do {
//        filelist = try filemgr.contentsOfDirectory(atPath: pathToSearch)
//    } catch { print(error) }
//
////    filelist = filelist.filter{  //is there a way for MacOS to return only supported imagefiles without relying on file extensions?
////           $0.lowercased().contains(".jp")
////        || $0.lowercased().contains(".png")
////        || $0.lowercased().contains(".bmp")
////    }
//
//    let queue = DispatchQueue(label: "on.images")
//    queue.async {
//        filelist = filelist.filter{ NSImage(contentsOfFile: pathToSearch+"/"+$0) != nil } //filter out non-images
//
//        if filelist.count == 0 {
//            print()
//            print("No images found in directory \(String(describing: directoryURL))")
//        }
//        print("filelist.count=\(filelist.count)")
//    }
//    return filelist
//}
