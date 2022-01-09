//
//  selectedFolders.swift
//  WallHe+
//
//  Created by Aniello Di Meglio (Admin) on 2021-12-22.
//

import Foundation

class directoryItems: NSObject {
    
    @objc dynamic var name: String
    @objc dynamic var fullURL: URL
    
    init(_ name: String, _ fullURL: URL) {
        self.name = name
        self.fullURL = fullURL
    }
}
