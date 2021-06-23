//
//  main.swift
//  SwiftStringsExtractor
//
//  Created by 梁宪松 on 2021/6/23.
//

import ArgumentParser
import Foundation
import SwiftStringsExtractor
import SwiftSyntax
import Path

func recursiveFiles(withExtensions exts: [String], at path: Path) throws -> [Path] {
    if path.isFile {
        if exts.contains(path.extension) {
            return [path]
        }
        return []
    } else if path.isDirectory {
        var files: [Path] = []
        for entry in path.ls() {
            let list = try recursiveFiles(withExtensions: exts, at: entry)
            files.append(contentsOf: list)
        }
        return files
    }
    return []
}

enum InternalError: Error {
    case illegalArg(String)
}
/**
 A command line program to run the problem
 */
struct StringsExtractor: ParsableCommand {
    
    @Argument(
        help: """
        Path to visit
        """
    )
    var path: String?
    
    @Option(name: .shortAndLong, parsing: .upToNextOption, help: """
        File extensions, default: .mm, .swift, .m, .h
        """)
    var exts: [String]
    
    func run() throws {

        var ets = exts
        if exts.count == 0 {
            ets = ["mm", "swift", "m", "h"]
        } else {
            ets = exts.map { (item) -> String in
                return item.replacingOccurrences(of: ".", with: "")
            }
        }
        
        guard var p = path else {
            throw InternalError.illegalArg("Path could not be empty")
        }
        
        if !p.hasPrefix("file://") {
            p = "file://" + p
        }
        
        guard let url = URL.init(string: p) else {
            throw InternalError.illegalArg("Path illegal")
        }
        
        guard let pPath = Path.init(url: url) else {
            throw InternalError.illegalArg("Path error")
        }
        
        let extractor = SwiftStringsExtractor.init()
        extractor.visitCallBack = {(str) in
            print(str)
        }
        
        if pPath.isFile == true {
            print("============ \(p) ============")
            let tree = try! SyntaxParser.parse(url)
            extractor.walk(tree)
            print("============ end ============\n")
        } else {
            let paths = try recursiveFiles(withExtensions: ets, at: pPath)
            
            for path in paths {
                print("============ \(path) ============")
                
                guard let u = URL.init(string: "file://" + path.string) else {
                    continue
                }
                let tree = try! SyntaxParser.parse(u)
                extractor.walk(tree)
                
                print("============ end ============\n")
            }
        }
        
        print("extract done")
    }
}

StringsExtractor.main()
