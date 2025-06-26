// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser

@main
struct CestrumCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "cestrum",
        abstract: "Manage and orchestrate Kubernetes deployment reconfigurations 🍃",
        version: "beta-1.0",
        subcommands: [New.self, Plan.self, View.self, Apply.self, Override.self, Remove.self]
    )
}
