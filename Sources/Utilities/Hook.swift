//
//  Hook.swift
//  cestrum-cli
//
//  Created by Wadÿe on 17/03/2025.
//

import Foundation
import ArgumentParser
import CestrumCore

extension DependencyGraph {
    static func hook(name: String) throws -> DependencyGraph {
        let configurationFileDirectory = URL.cestrumDirectory.appendingPathComponent("\(name).cesc")
        guard FileManager.default.fileExists(atPath: configurationFileDirectory.path) else {
            print(Message.error("Configuration '\(name)' not found."))
            throw ExitCode.success
        }
        let data = try Data(configurationPath: configurationFileDirectory)
        let configuration = try decode(from: data)
        return configuration
    }
}
