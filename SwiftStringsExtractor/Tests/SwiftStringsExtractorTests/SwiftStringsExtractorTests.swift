import XCTest
import SwiftSyntax
@testable import SwiftStringsExtractor

final class SwiftStringsExtractorTests: XCTestCase {
    let swiftSource = """
    import Foundation

    var GlobalStringV = "GlobalStringV"
    let GobalStringL = "GobalStringL"

    class TestObject: NSObject {
    static let clazzString = "clazzString"
    
    func hello() {
        print("Hello world")
    }
    }
    """
    
    let ocSource = """
    NSString* bundlePath = nil;
    bundlePath = [[NSBundle mainBundle] bundlePath];
    bundlePath = [bundlePath stringByAppendingString: @"/Frameworks/UnityFramework.framework"];
    """
    
    func testSwiftExtractor() {
        // 解析语法树
        let tree = try! SyntaxParser.parse(source: swiftSource)
        // 遍历
        let extractor = SwiftStringsExtractor.init()
        extractor.walk(tree)
    }
    
    func testOCExtractor() {
        // 解析语法树
        let tree = try! SyntaxParser.parse(source: ocSource)
        // 遍历
        let extractor = SwiftStringsExtractor.init()
        extractor.walk(tree)
    }

    static var allTests = [
        ("testSwiftExtractor", testSwiftExtractor),
        ("testOCExtractor", testOCExtractor),
    ]
}
