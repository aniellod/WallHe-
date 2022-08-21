//
//  jsonIO.swift
//  WallHe+
//
//  Created by Aniello Di Meglio (Admin) on 2022-01-10.
//

import Foundation
import Cocoa

class saveReadJson {
    
    private var path:[URL]
    private var theFileName:URL
    
    init() {
        path = []
        theFileName = URL(string: "/tmp/file.json")!
    }
    
    var pathToSave: [URL] {
        get { return path }
        set { path = newValue }
    }
    
    var fullyQualifiedFileName: URL {
        get { return theFileName }
        set { theFileName = newValue }
    }
    
    func saveDocumentDirectory() {
        let filePath = getFilename()
        if filePath != nil {
            let levels = pathToSave
            let json = try? JSONEncoder().encode(levels)
            do {
                 try json!.write(to: filePath!)
                     fullyQualifiedFileName = filePath!
            } catch {
                print("Failed to write JSON data: \(error.localizedDescription)")
            }
        }
    }
    
    func saveExisting() {
        if FileManager().fileExists(atPath: fullyQualifiedFileName.path) {
            print("\(#line): pathtosave:\(pathToSave) \nfully:\(fullyQualifiedFileName)")
            let json = try? JSONEncoder().encode(pathToSave)
            do {
                 try json!.write(to: fullyQualifiedFileName)
            } catch {
                print("Failed to write JSON data: \(error.localizedDescription)")
            }
        }
    }
    
    func openDocument() -> [URL] {
        let fileName = getDocument()
        if fileName == nil { return [] }
        do {
            fullyQualifiedFileName = fileName!
            let data = try Data(contentsOf: fileName!, options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let paths: [URL] = try! decoder.decode([URL].self, from: data)
          //  print("\(#line): paths=\(paths) theFileName=\(theFileName)")
            return paths
        } catch { print("\(error)") }
        return []
    }
    
    private func getDocument() -> URL? {
        let dialog = NSOpenPanel();
        dialog.title                   = "Choose file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = false
        dialog.canChooseFiles = true
        
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url! // Pathname of the file
            print("Result = \(String(describing: result))")
            if (!result.pathComponents.isEmpty) {
                return result
            }
        }
        // "Cancel" was clicked
        return nil
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFilename() -> URL? {
        let dialog = NSSavePanel()
        dialog.title = "Save set to:"
        dialog.canCreateDirectories = true
        dialog.directoryURL = getDocumentsDirectory()
        dialog.runModal()
        print("dialog.url = \(String(describing: dialog.url!))")
        return dialog.url
    }
    
    private func append(toPath path: String, withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            
            return pathURL.absoluteString
        }
        
        return nil
    }
}
