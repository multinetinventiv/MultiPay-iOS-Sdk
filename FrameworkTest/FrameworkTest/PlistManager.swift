//
//  ViewController+Plist.swift
//  FrameworkTest
//
//  Created by ilker sevim on 4.03.2021.
//  Copyright © 2021 multinet. All rights reserved.
//

import Foundation
import Multipay

func getPlist(environment:Environment) -> [String:AnyObject]?
{
    
    var apiFileNameStart = ""
    
    switch environment {
    case .dev:
        apiFileNameStart = "Dev"
        break
    case .test:
        apiFileNameStart = "Test"
        break
    case .pilot:
        apiFileNameStart = "Pilot"
        break
    case .production:
        apiFileNameStart = "Prod"
        break
    }
    
    let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let documentFileURL = documentDirectoryURL.appendingPathComponent(apiFileNameStart + "-Configs.plist", isDirectory: false)
    let filemanager = FileManager.default
    
    if filemanager.fileExists(atPath: documentFileURL.path), let xml = FileManager.default.contents(atPath: documentFileURL.path) {
        
        return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String:AnyObject]
    } else {
        if let bundlePath = Bundle.main.path(forResource: apiFileNameStart + "-Configs", ofType: "plist"), filemanager.fileExists(atPath: bundlePath), let xml = FileManager.default.contents(atPath: bundlePath) {
            
            do {
                try filemanager.copyItem(at: URL(fileURLWithPath: bundlePath), to: documentFileURL)
            } catch {
                print(error)
            }
            
            
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String : AnyObject]
        }
    }
    
    return nil
}

func getMutableDictionaryFromPlist(lastSelectedApiType:Environment) -> (mutDict: NSMutableDictionary?, url: URL)
{
    
    let environment:Environment = lastSelectedApiType
    
    var apiFileNameStart = ""
    
    switch environment {
    case .dev:
        apiFileNameStart = "Dev"
        break
    case .test:
        apiFileNameStart = "Test"
        break
    case .pilot:
        apiFileNameStart = "Pilot"
        break
    case .production:
        apiFileNameStart = "Prod"
        break
    }
    
    let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let documentFileURL = documentDirectoryURL.appendingPathComponent(apiFileNameStart + "-Configs.plist", isDirectory: false)
    let filemanager = FileManager.default
    
    if filemanager.fileExists(atPath: documentFileURL.path) {
        let tempDict = NSMutableDictionary(contentsOfFile: documentFileURL.path)!
        return (tempDict, documentFileURL)
    }
    
    return (nil, documentFileURL)
}
