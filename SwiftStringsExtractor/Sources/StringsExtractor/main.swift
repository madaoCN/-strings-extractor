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
        Path for StringExtractor to visit
        """
    )
    var path: String?

    @Argument(
        help: """
        File extensions
        """
    )
    var exts: [String]
    
    mutating func run() throws {
        
        guard let p = path else {
            throw InternalError.illegalArg("Path could not be empty")
        }
        
        guard let url = URL.init(string: p) else {
            throw InternalError.illegalArg("Path illegal")
        }
        
        let paths = try recursiveFiles(withExtensions: exts, at: Path.init(url: url)!)
        
        let extractor = SwiftStringsExtractor.init()
        extractor.visitCallBack = {(str) in
            print(str)
        }
    
        for path in paths {
            guard let u = URL.init(string: path.string) else {
                continue
            }
            let tree = try! SyntaxParser.parse(u)
            extractor.walk(tree)
        }
    }
}

StringsExtractor.main()
