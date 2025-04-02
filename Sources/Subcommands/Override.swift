//
//  Override.swift
//  cestrum-cli
//
//  Created by Wadÿe on 17/03/2025.
//

import Foundation
import CestrumCore
import ArgumentParser

struct Override: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "override",
        abstract: "Overrides an existing configuration with another."
    )
    
    @Argument(help: "The file name (or path) of the newer version of the configuration.")
    var filePath: String
    
    func run() throws {
        let fileURL = try formURLfromString(filePath, havingExtension: "cesc")
        let data = try Data(configurationPath: fileURL)
        let newGraph = try decode(from: data)
        let configurationName = newGraph.namespace
        let configurationFileName = "\(configurationName).cesc"
        
        guard FileManager.default.fileExists(atPath: URL.cestrumDirectory.appendingPathComponent(configurationFileName).path) else {
            print(Message.error("Configuration '\(configurationName)' does not exist."))
            return
        }
        
        do {
            try save(newGraph)
            print(Message.success("Overridden configuration '\(configurationName)' !"))
        } catch {
            print(Message.unexpected("Could not complete the overriding of the configuration. Reason: \(error)"))
            throw ExitCode.failure
        }
    }
}
