import Foundation
import SwiftSyntax

/// Syntax Tree Visitor
public class SwiftStringsExtractor: SyntaxVisitor {
    
    /// callback 回调
    public var visitCallBack: ((String) -> Void)?
    
    public override init() {
        super.init()
    }

    // for swift
    public override func visitPost(_ node: StringSegmentSyntax) {
        // print("StringSegmentSyntax: ", node.content)
        visitCallBack?(node.content.text)
    }
    
    // for Objective-C
    public override func visit(_ token: TokenSyntax) -> SyntaxVisitorContinueKind {
        switch token.tokenKind {
        case let .stringLiteral(text):
            // print("TokenSyntax: ", text)
            visitCallBack?(text)
        default:
            break
        }
        return .visitChildren
    }
}
