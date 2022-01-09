//
//  extensions.swift
//  WallHe+
//
//  Created by Aniello Di Meglio (Admin) on 2022-01-09.
//

import Foundation
import SwiftUI

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

extension String {
    func slash() -> String {
        return self.last != "/" ? self + "/" : self
    }

    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}
