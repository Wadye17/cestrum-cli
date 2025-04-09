//
//  Messages.swift
//  cestrum-cli
//
//  Created by Wadÿe on 17/03/2025.
//

import Foundation
import Prism
import CestrumCore

struct Message: CustomStringConvertible {
    let content: Prism
    
    private init(content: Prism) {
        self.content = content
    }
    
    static func unexpected(_ body: String) -> Message {
        let content = Prism(spacing: .spaces) {
            ForegroundColor(.magenta) {
                Bold("[!] Unexpected:")
            }
            body
        }
        return Message(content: content)
    }
    
    static func success(_ body: String) -> Message {
        let content = Prism(spacing: .spaces) {
            ForegroundColor(.green) {
                Bold("[✓] Success:")
            }
            body
        }
        return Message(content: content)
    }
    
    static func notice(_ body: String) -> Message {
        let content = Prism(spacing: .spaces) {
            ForegroundColor(.blue) {
                Bold("[i] Notice:")
            }
            body
        }
        return Message(content: content)
    }
    
    static func warning(_ body: String) -> Message {
        let content = Prism(spacing: .spaces) {
            ForegroundColor(.yellow) {
                Bold("[!] Warning:")
            }
            body
        }
        return Message(content: content)
    }
    
    static func error(_ body: String) -> Message {
        let content = Prism(spacing: .spaces) {
            ForegroundColor(.red) {
                Bold("[×] Error:")
            }
            body
        }
        return Message(content: content)
    }
    
    static func fullError(_ body: String) -> Message {
        let content = Prism(spacing: .spaces) {
            ForegroundColor(.red) {
                Bold("[×] \(body)")
            }
        }
        return Message(content: content)
    }
    
    static func interpretationError(_ cesrError: CESRError) -> Message {
        var body: Prism
        if let line = cesrError.line {
            body = Prism {
                ForegroundColor(.red) {
                    Bold("Line \(line):")
                }
                "\(cesrError.message)"
            }
        } else {
            body = Prism {
                ForegroundColor(.red) {
                    cesrError.message
                }
            }
        }
        let content = Prism(spacing: .spaces) {
            ForegroundColor(.red) {
                Bold(" |")
            }
            body.description
        }
        return Message(content: content)
    }
    
    static func fatalError(_ body: String) -> Message {
        let content = Prism(spacing: .spaces) {
            ForegroundColor(.red) {
                Bold("[×] Fatal error:")
                body
            }
        }
        return Message(content: content)
    }
    
    static func plan(header: String, body: String, isEmpty: Bool = false) -> Message {
        let content = Prism(spacing: .newlines) {
            let header = "[\(header)]:"
            ForegroundColor(.cyan) {
                Bold(header)
            }
            ForegroundColor(isEmpty ? .gray : .default) {
                body
            }
            ForegroundColor(.cyan) { "\r\(header.map({ _ in return "—" }).joined(separator: ""))" }
        }
        return Message(content: content)
    }
    
    static func graph(_ graph: DependencyGraph) -> Message {
        let content = Prism(spacing: .newlines) {
            let header = "[Configuration] '\(graph.namespace)':"
            ForegroundColor(.cyan) {
                Underline { Bold(header) }
            }
            graph.description
            ForegroundColor(.cyan) { "\r\(header.map({ _ in return "—" }).joined(separator: ""))" }
        }
        return Message(content: content)
    }
    
    var description: String {
        self.content.description
    }
}
