//
//  New.swift
//  cestrum-cli
//
//  Created by Wadÿe on 17/03/2025.
//

import Foundation
import ArgumentParser
import CestrumCore

struct New: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "new",
        abstract: "Registers a new configuration."
    )
    
    @Argument(help: "The file name (or path) of the configuration to register.")
    var filePath: String
    
    func run() throws {
        let fileURL = try formURLfromString(filePath, havingExtension: "cesc")
        let data = try Data(configurationPath: fileURL)
        let graph = try decode(from: data, fileKind: .description)
        let encodedGraph = try encode(configuration: graph)
        let configurationName = graph.namespace
        let configurationFileName = "\(configurationName).cesc"
        
        guard !FileManager.default.fileExists(atPath: URL.cestrumDirectory.appendingPathComponent(configurationFileName).path) else {
            print(Message.warning("Configuration '\(configurationName)' already exists"))
            print(Message.info("If you wish to override it, please run 'cestrum override \(filePath)' instead", kind: .tip))
            throw ExitCode(2)
        }
        
        guard !graph.hasCycles else {
            print(Message.error("The given configuration cannot be registered because its graph exhibits at least one cycle; configurations must be acyclic"))
            throw ExitCode.failure
        }
        
        do {
            try encodedGraph.write(to: .cestrumDirectory.appendingPathComponent(configurationFileName))
            print(Message.success("Registered configuration '\(configurationName)'"))
        } catch {
            print(Message.error("Could not register the configuration\nReason: \(error)"))
            throw ExitCode.failure
        }
    }
}
