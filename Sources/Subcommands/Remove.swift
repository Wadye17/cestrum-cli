//
//  Remove.swift
//  cestrum-cli
//
//  Created by Wadÿe on 10/04/2025.
//

import Foundation
import ArgumentParser
import CestrumCore

struct Remove: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "remove",
        abstract: "Removes a configuration."
    )
    
    @Argument(help: "The name of the configuration to remove.")
    var configurationName: String
    
    func run() throws {
        let configurationFileDirectory = URL.cestrumDirectory.appendingPathComponent("\(configurationName).cesc")
        guard FileManager.default.fileExists(atPath: configurationFileDirectory.path) else {
            print(Message.error("No such configuration named '\(configurationName)' is registered"))
            throw ExitCode.failure
        }
        try FileManager.default.removeItem(at: configurationFileDirectory)
        print(Message.success("Removed configuration '\(configurationName)'"))
    }
}
