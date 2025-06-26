//
//  File.swift
//  cestrum-cli
//
//  Created by Wadÿe on 15/05/2025.
//

import Foundation
import CestrumCore
import ArgumentParser

struct Empty: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "empty",
        abstract: "Create and register a new empty configuration."
    )
    
    @Argument(help: "The name of the new empty configuration")
    var configurationName: String
    
    func run() throws {
        let configurationFileName = "\(configurationName).cesc"
        guard !FileManager.default.fileExists(atPath: URL.cestrumDirectory.appendingPathComponent(configurationFileName).path) else {
            print(Message.error("Configuration '\(configurationName)' already exists"))
            return
        }
        let graph = try DependencyGraph(name: configurationName, deployments: [], dependencies: [])
        let encodedGraph = try encode(configuration: graph)
        
        do {
            try encodedGraph.write(to: .cestrumDirectory.appendingPathComponent(configurationFileName))
            print(Message.success("Registered empty configuration '\(configurationName)'"))
        } catch {
            print(Message.error("Could not register the configuration\nReason: \(error)"))
            throw ExitCode.failure
        }
    }
}
